---
name: debug-slow-mac
description: Diagnose why your Mac is running slowly. Identifies CPU hogs, memory pressure, runaway processes, and maps them to tmux sessions when applicable. Use when asked "why is my computer slow", "what's using CPU", "what's eating memory", or similar.
metadata:
  short-description: Debug slow Mac performance
---

# Debug Slow Mac

Systematically diagnose macOS performance issues by checking CPU, memory, and identifying the worst offenders.

## Workflow

### 1. Get System Overview

Run these in parallel to get a quick snapshot:

```bash
# Load average and basic stats
uptime

# Memory pressure
vm_stat | head -10

# Top CPU consumers (snapshot)
ps -Ao pid,pcpu,pmem,comm -r | head -15
```

Key metrics to report:
- **Load average**: Should be roughly equal to CPU core count. Much higher = overloaded
- **Pages free vs wired**: Low free + high wired = memory pressure
- **CPU idle %**: Below 20% idle = CPU bottleneck

### 2. Identify Top Offenders

Get detailed process info sorted by CPU:

```bash
ps -Ao pid,pcpu,pmem,comm -r | head -20
```

For processes with high CPU, get their full command line:

```bash
ps -eo pid,pcpu,pmem,command -r | head -15
```

### 3. Check Docker/OrbStack (if running)

```bash
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null | head -15
```

### 4. Map High-CPU Processes to Tmux Sessions

When processes like `claude`, `nvim`, `node`, etc. are consuming resources, identify exactly which tmux session/window/pane they're in.

#### Step 1: Get all tmux panes with their TTYs

```bash
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_tty} #{pane_current_command}'
```

#### Step 2: For a specific high-CPU PID, trace to its tmux pane

```bash
# Get the TTY for the process
ps -o pid,tty,command -p <PID>

# Match the TTY (e.g., ttys043) against tmux panes
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_tty}' | grep ttys043
```

#### Step 3: For processes that spawn children (like claude spawning node)

Trace the parent chain to find the original TTY:

```bash
# Get parent PID
ps -o pid,ppid,tty,command -p <PID>

# If TTY shows "??", check the parent process
ps -o pid,ppid,tty,command -p <PPID>

# Keep tracing up until you find a real TTY
```

#### Step 4: Build a summary of which tmux locations have high-CPU processes

```bash
# For each high-CPU process, find its tmux location
for pid in <PID1> <PID2> <PID3>; do
  tty=$(ps -o tty= -p $pid 2>/dev/null | tr -d ' ')
  if [ "$tty" != "??" ] && [ -n "$tty" ]; then
    pane=$(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_tty}' | grep "$tty" | cut -d' ' -f1)
    cmd=$(ps -o comm= -p $pid)
    echo "$pane -> $cmd (PID $pid)"
  fi
done
```

#### Example Output to Provide User

Present findings like:

| Process | PID | CPU | Tmux Location | Action |
|---------|-----|-----|---------------|--------|
| claude | 71816 | 57% | `tertiary:4.1` | `tmux switch-client -t tertiary:4.1` |
| nvim | 12317 | 52% | `tertiary:3.1` | Close buffers or restart |
| node (vite) | 84975 | 15% | `irm:1.1` | `pkill -f vite` if not needed |

Always provide the `tmux switch-client -t <location>` command so the user can jump directly to the offending pane.

### 5. Check for Common Culprits

#### Node.js / TypeScript LSP
```bash
ps -eo pid,pcpu,pmem,command | grep -E 'tsserver|vtsls|node.*typescript' | grep -v grep
```

High CPU here usually means:
- Large TypeScript project being type-checked
- Multiple neovim/VSCode instances with LSP

#### Electron Apps
```bash
ps -eo pid,pcpu,pmem,command | grep -E 'Electron|Helper.*Renderer' | grep -v grep
```

Common offenders: Slack, Discord, Linear, VSCode, browsers

#### Claude Code instances
```bash
ps -eo pid,pcpu,pmem,command | grep -E '[c]laude' | head -10
```

### 6. Provide Actionable Recommendations

Based on findings, suggest:

1. **For Docker/OrbStack**: `orbctl stop` if not needed
2. **For specific containers**: `docker stop <name>`
3. **For Storybook/dev servers**: `pkill -f storybook` or `pkill -f vite`
4. **For runaway Node processes**: Identify and kill specific PIDs
5. **For Electron apps**: Quit via GUI or `pkill -f <AppName>`
6. **For LSP issues**: Close editor buffers or restart editor

Always offer to kill specific processes and provide the exact command.

## Output Format

Present findings in a clear table:

| Process | CPU | Memory | Issue |
|---------|-----|--------|-------|
| ProcessName | X% | Y% | Brief explanation |

Then provide:
1. Root cause summary
2. Specific commands to fix
3. Ask if user wants you to run the fix commands

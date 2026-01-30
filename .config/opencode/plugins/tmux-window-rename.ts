import type { PluginContext, PluginHooks } from "@opencode-ai/plugin"
import { execSync } from "child_process"

export const TmuxWindowRename = async (): Promise<PluginHooks> => {
  const rename = (prefix: string) => {
    try {
      const idx = execSync('tmux display-message -p -t "$TMUX_PANE" "#I"', { encoding: "utf8" }).trim()
      execSync(`tmux rename-window -t ${idx} "${prefix} opencode"`)
    } catch {}
  }

  return {
    event: async ({ event }) => {
      const props = event.properties as Record<string, unknown> | undefined

      if (event.type === "session.created" || event.type === "session.updated") {
        if ((props?.info as { parentID?: string })?.parentID) return
        rename("🤖")
      }

      if (event.type === "session.idle") {
        rename("💬")
      }

      if (event.type === "session.status") {
        if (props?.status === "generating" || props?.status === "tool") {
          rename("⚡")
        }
      }
    },
  }
}

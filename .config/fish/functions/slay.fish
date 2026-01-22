function slay
    ps -Ao pid,%cpu,comm | awk '$2 > 90 {print $1, $2, $3}' | while read pid cpu command
        echo "Killing PID $pid ($command) - CPU: $cpu%"
        kill -9 $pid
    end
end

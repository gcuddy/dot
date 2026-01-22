function git_search
    set -l search_term $argv[1]

    if test -z "$search_term"
        echo "Usage: git_search <search-term>"
        return 1
    end

    set -l repo_root (git rev-parse --show-toplevel)

    echo "Searching unstaged changes..."
    for file in (git diff --name-only)
        set -l full_path "$repo_root/$file"
        if rg -q "$search_term" $full_path
            echo "In file: $file"
            rg -n "$search_term" $full_path
        end
    end

    echo "Searching staged changes..."
    for file in (git diff --cached --name-only)
        set -l file_content (git show :$file)
        if echo "$file_content" | rg -q "$search_term"
            echo "In file: $file"
            echo "$file_content" | rg -n "$search_term"
        end
    end
end

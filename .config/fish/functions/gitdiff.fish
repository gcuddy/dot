function gitdiff
    for file in (git diff --name-only main)
        echo (git rev-parse --show-toplevel)/$file
    end
end

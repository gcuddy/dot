function alembicr
    set -l latest_file (find (pwd)/common/common/db/migrations/versions -type f -name "*.py" ! -name "__init__.py" | sort | tail -n 1)
    set -l revision_id (grep '^revision =' $latest_file | awk -F'"' '{print $2}' | string trim)
    echo $revision_id
end

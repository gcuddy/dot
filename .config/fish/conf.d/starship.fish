set -l cached ~/.config/fish/conf.d/starship.cached.fish
if not test -f $cached
    starship init fish --print-full-init > $cached
end
source $cached

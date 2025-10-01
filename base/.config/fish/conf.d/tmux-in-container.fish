# ~/.config/fish/conf.d/tmux-in-container.fish

function in_container --description 'Detect common containers robustly'
    test -f /.dockerenv; and return 0
    test -f /run/.containerenv; and return 0

    if command -q systemd-detect-virt
        systemd-detect-virt --container >/dev/null 2>&1; and return 0
    end

    for f in /proc/self/mountinfo /proc/1/mountinfo
        if test -r $f
            grep -qaE '(docker|containerd|kubepods|libpod|podman|cri-o|rkt|lxc|nspawn)' $f; and return 0
        end
    end

    for f in /proc/self/cgroup /proc/1/cgroup
        if test -r $f
            grep -qaE '(docker|containerd|kubepods|libpod|podman|cri-o|rkt|lxc|machine.slice)' $f; and return 0
        end
    end

    if test -r /proc/1/environ
        string match -rq 'container=' (tr '\0' '\n' </proc/1/environ); and return 0
    end

    return 1
end

# Optional debug
if set -q FISH_TMUX_DEBUG
    echo "[tmux-auto] interactive="(status is-interactive)" tmux="$TMUX" container="(in_container; and echo yes; or echo no)
end

# Auto-attach only for interactive shells in containers, not already inside tmux
if status is-interactive; and in_container; and not set -q TMUX; and not set -q FISH_NO_TMUX
    command -q tmux; or begin
        set -q FISH_TMUX_DEBUG; and echo "[tmux-auto] tmux not found"
        exit 0
    end

    # If any session exists, attach. Otherwise create main.
    if tmux has-session >/dev/null 2>&1
        set -q FISH_TMUX_DEBUG; and echo "[tmux-auto] attaching to existing session"
        exec tmux attach
    else
        set -q FISH_TMUX_DEBUG; and echo "[tmux-auto] creating session 'main'"
        exec tmux new -s main
    end
end

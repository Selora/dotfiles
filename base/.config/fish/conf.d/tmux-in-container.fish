# # ~/.config/fish/conf.d/tmux-in-container.fish

function in_container --description 'Detect whether this shell is actually running inside a container'
    test -f /.dockerenv; and return 0
    test -f /run/.containerenv; and return 0

    if command -q systemd-detect-virt
        systemd-detect-virt --quiet --container; and return 0
    end

    # Check explicit container markers from PID 1
    if test -r /proc/1/environ
        tr '\0' '\n' </proc/1/environ | string match -rq '^container='; and return 0
    end

    # cgroup check, but only if the current process itself is in a clearly containerized path
    if test -r /proc/self/cgroup
        string match -rq '.*/(docker|libpod|kubepods|machine.slice/libpod|lxc|podman)-.*' (cat /proc/self/cgroup); and return 0
    end

    return 1
end

if set -q FISH_TMUX_DEBUG
    echo "[tmux-auto] interactive="(status is-interactive)" tmux="$TMUX" container="(in_container; and echo yes; or echo no)
end

if status is-interactive; and in_container; and not set -q TMUX; and not set -q FISH_NO_TMUX
    command -q tmux; or begin
        set -q FISH_TMUX_DEBUG; and echo "[tmux-auto] tmux not found"
        return
    end

    if tmux has-session >/dev/null 2>&1
        set -q FISH_TMUX_DEBUG; and echo "[tmux-auto] attaching to existing session"
        exec tmux attach
    else
        set -q FISH_TMUX_DEBUG; and echo "[tmux-auto] creating session 'main'"
        exec tmux new -s main
    end
end

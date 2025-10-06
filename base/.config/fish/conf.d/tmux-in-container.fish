# ~/.config/fish/conf.d/tmux-in-container.fish
#
# ~/.config/fish/conf.d/tmux-in-container.fish

function in_container --description 'Detect common container runtimes'
    # Fast markers
    test -f /.dockerenv; and return 0
    test -f /run/.containerenv; and return 0

    # systemd-nspawn / others
    if command -q systemd-detect-virt
        systemd-detect-virt --container >/dev/null 2>&1; and return 0
    end

    # Heuristics for cgroup v1/v2 and mountinfo
    if test -r /proc/1/mountinfo
        grep -qaE '(docker|containerd|kubepods|libpod|podman|rkt)' /proc/1/mountinfo; and return 0
    end
    if test -r /proc/1/cgroup
        grep -qaE '(docker|containerd|kubepods|libpod|machine.slice|podman)' /proc/1/cgroup; and return 0
    end

    return 1
end

# Auto-attach tmux only for interactive shells inside containers
if status is-interactive; and in_container; and not set -q TMUX; and not set -q FISH_NO_TMUX
    command -q tmux; or return

    # pick first existing session, else create 'main'
    set -l s (tmux list-sessions -F '#{session_name}' 2>/dev/null | head -n1)
    if test -n "$s"
        exec tmux attach -t "$s"
    else
        tmux new-session -ds main
        exec tmux attach -t main
    end
end

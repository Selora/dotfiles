if test -f /etc/arch-release
    if type -q pikaur
        function pikaur
            env -i HOME=$HOME TERM=$TERM PATH=/usr/bin:/bin:/usr/sbin:/sbin command pikaur $argv
        end
    end
end

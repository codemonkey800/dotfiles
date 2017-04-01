function serve -d 'Starts a static HTTP server in the current dir.'
    set -l cmd "python3 -m http.server"
    set -l port 8080

    if set -e argv[1]
        set port $argv[1]
    end

    set cmd "$cmd $port"

    if test $port -eq 80
        set cmd "sudo $cmd"
    end

    eval $cmd
end


function serve --description 'Starts a static HTTP server in the current dir.'
    if test $argv[1] = 80
        sudo python3 -m http.server 80
    else
       python3 -m http.server $argv[1]
   end
end


function wait-for-online -d 'Waits for a working internet connection and prints the time elapsed.'
  set seconds 0
  while not ping -c 1 'google.com' > /dev/null ^&1
    echo "$seconds seconds elapsed"
    sleep 1
    set seconds (math "$seconds + 1")
    clear
  end
  echo "It took $seconds seconds for your internet to come back."
end


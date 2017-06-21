function random-cow -d 'Retrieves a random cow to be used by cowsay'
  set cows (cowsay -l | sed 1d | string split ' ')
  echo $cows[(random 1 (count $cows))]
end

function lc -w ls -d 'Lists all files in a directory in a column'
  ll $argv | tail -n +2 | choose '8:'
end


function lc -d 'Lists all files in a directory in a column'
  ll $argv | tail -n +2 | pawk f[8:]
end


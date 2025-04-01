function lc -w ls -d 'Lists all files in a directory in a column'
  for x in (ls $argv)
    echo $x
  end
end


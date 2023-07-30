function size -d 'Calculates the size of a file or list of files and sorts them.'
  set sort 'sort'

  if test (uname) = 'Darwin'
    set sort 'gsort'
  end

  du -csh $argv | $sort -h
end


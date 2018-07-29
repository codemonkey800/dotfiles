function size -d 'Calculates the size of a file or list of files and sorts them.'
  set cmd "du -csh $argv"
  set sort 'sort -h'

  if test (uname) = 'Darwin'
    set sort 'gsort -h'
  end

  eval "$cmd | $sort"
end


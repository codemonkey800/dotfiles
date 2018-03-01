function run -d 'Runs the specified file using the correct execution environment'
  set exe "$argv[1]"
  set exit_code 0

  set -e argv[1]

  function __run_help
    echo 'Usage: run <file>'
    echo
    echo 'Arguments:'
    echo '  file - The file to execute'
  end

  if not test -f $exe
    echo "Unable to run '$exe' because it doesn't exist!"
    echo
    __run_help
    set exit_code -1
  else if test -x $exe
    eval "./$exe $argv"
    set exit_code $status
  else
    set -l parts (string split '.' "$exe")
    set -l name $parts[1]
    set -l ext $parts[-1]

    if test "$exe" = "$name"
      echo 'Unable to determine execution environment with extension.'
      set exit_code -1
    else
      switch "$ext"
        case 'cpp'
          clang++ -std=c++1z -o "$name" "$exe"
          and eval "./$name $argv"
          set exit_code $status
          rm -f "$name"
        case 'java'
          javac "$exe"
          and java "$name" $argv
          set exit_code $status
          and rm -f "$name.class"
        case 'fish'
          fish "$exe" $argv
          set exit_code $status
        case 'py'
          python3 "$exe" $argv
          set exit_code $status
        case 'sh'
          bash "$exe" $argv
          set exit_code $status
        case 'js'
          node "$exe" $argv
          set exit_code $status
      end
    end
  end

  clear-functions __run
  return $exit_code
end


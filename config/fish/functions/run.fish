function run -d 'Runs the specified file using the correct execution environment'
  set -l exe "$argv[1]"
  set -l exit_code 0

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
    eval "./$exe"
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
          and eval "./$name"
          set exit_code $status
          rm -f "$name"
        case 'java'
          javac "$exe"
          and java "$name"
          set exit_code $status
          rm -f "$name.class"
        case 'fish'
          fish "$exe"
          set exit_code $status
        case 'py'
          python3 "$exe"
          set exit_code $status
        case 'sh'
          bash "$exe"
          set exit_code $status
      end
    end
  end

  clear-functions __run
  return $exit_code
end


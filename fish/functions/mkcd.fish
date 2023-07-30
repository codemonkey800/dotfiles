function mkcd -d "Creates a new directory if it doesn't exist and then cd's into it"
  if not test -d "$argv"
    mkdir -p "$argv"
  end
  cd "$argv"
end


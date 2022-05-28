function clean-functions -d "Clean functions given a certain pattern"
  functions -e (functions -a | rg $argv)
end

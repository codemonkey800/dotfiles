function dokku -d 'Dokku CLI frontend for my personal stage and prod servers.'
  function __dokku_help
    echo 'Usage: dokku stage|prod [dokku options]'
  end

  switch "$argv[1]"
    case 'stage'
      set -e argv[1]
      echo '====== Stage Server ======'
      ssh stage dokku -- $argv
    case 'prod'
      set -e argv[1]
      echo '====== Prod Server ======'
      ssh prod dokku -- $argv
    case 'help'
      __dokku_help
      clear-functions __dokku
    case '*'
      __dokku_help
      clear-functions __dokku
      return -1
  end
end


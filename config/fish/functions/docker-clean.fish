function docker-clean -d 'Cleans up non-running contains, <none> images, and volumes.'
  echo 'Removing non-running containers'
  if docker ps -a | egrep 'Created|Exited'
      docker rm -f (docker ps -a | egrep 'Created|Exited' | pawk 'f[0]')
  else
      echo 'No containers to remove'
  end

  echo 'Removing <none> images'
  if docker images | grep '<none>'
      docker rmi -f (docker images | grep '<none>' | pawk 'f[2]')
  else
      echo 'No images to remove'
  end

  echo 'Removing volumes'
  if docker volume ls | grep local
      docker volume rm (docker volume ls | grep local | pawk 'f[1]')
  else
      echo 'No volumes to remove'
  end

  echo 'All done!'
end


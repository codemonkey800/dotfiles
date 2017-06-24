function docker-update -d 'Updates all docker images.'
  for image in (command docker images | pawk 'f[0]' | tail -n +2)
    command docker pull $image
  end

  clear-functions __docker_update
end


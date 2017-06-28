function docker-update -d 'Updates all docker images.'
  for image in (docker images --format '{{ .Repository }}:{{ .Tag }}')
    docker pull $image
  end
end


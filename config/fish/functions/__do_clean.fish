function __do_clean -d 'Cleans up non-running contains, <none> images, and volumes.'
  set volumes (docker volume ls -qf 'dangling=true')
  set containers (docker ps -qf 'status=exited')
  set images (docker images -qf 'dangling=true')

  set volume_count (count $volumes)
  if test $volume_count -gt 0
    docker volume rm $volumes > /dev/null ^&1
  end
  echo "Removed $volume_count volumes."

  set container_count (count $containers)
  if test $container_count -gt 0
    docker rm $containers > /dev/null ^&1
  end
  echo "Removed $container_count containers."

  set image_count (count $images)
  if test $image_count -gt 0
    docker rmi $images > /dev/null ^&1
  end
  echo "Removed $image_count images."
end


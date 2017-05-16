function nm-restart -d 'Convenience function for restarting the NetworkManager service.'
  sudo systemctl restart NetworkManager
  if echo $argv | grep -qE '^(-w|--wait)'
    wait-for-online
  end
end

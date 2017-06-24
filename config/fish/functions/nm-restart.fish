function nm-restart -d 'Convenience function for restarting the NetworkManager service.'
  sudo systemctl restart 'NetworkManager'
  if echo "$argv" | egrep -q '^(-w|--wait)'
    wait-for-online
  end
end

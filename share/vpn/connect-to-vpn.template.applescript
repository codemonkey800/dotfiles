tell application "System Events"
  tell current location of network preferences
    set vpn to service "%s"
    connect vpn
  end tell
end tell

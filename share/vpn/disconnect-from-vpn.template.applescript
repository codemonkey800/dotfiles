tell application "System Events"
  tell current location of network preferences
    set vpn to service "%s"
    if exists vpn then disconnect vpn
  end tell
end tell

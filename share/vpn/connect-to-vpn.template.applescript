tell application "System Events"
  tell current location of network preferences
    set vpn to service "${SERVICE}"
    connect vpn
  end tell
end tell

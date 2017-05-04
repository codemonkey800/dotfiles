function public-ip -d 'Gets the public ip using an external service'
  curl -q 'http://ipinfo.io/ip'
end


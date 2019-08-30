function gitio
  set url (pbpaste)

  if string match -qr 'https://github.com/.*' $url
    set short_url (
      curl -si 'https://git.io' -F "url=$url" \
        | rg 'Location' \
        | pawk f[1]
    )

    echo "Short URL: $short_url"
    echo 'Copied to clipboard'
    echo -n $short_url | pbcopy
  else
    echo 'Please copy a GitHub url to your clipboard'
  end
end

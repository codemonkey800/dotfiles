function gitio
  set url (pbpaste)
  set should_create_pr_link false

  for arg in $argv
    switch $arg
      case '-p' '--pr-link'
        set should_create_pr_link true
    end
  end

  if string match -qr 'https://github.com/.*' $url
    set short_url (
      curl -si 'https://git.io' -F "url=$url" \
        | rg 'Location' \
        | awk '{print $2}'
    )

    set created_pr_link false
    if eval $should_create_pr_link
      set pr_number (string match -r 'https://github.com/.*/pull/(\d+)' $url)[2]

      if string match -qr '\d+' $pr_number
        set pr_link "[PR $pr_number]($short_url)"
        echo "PR Link: $pr_link"
        echo -n $pr_link | pbcopy
        set created_pr_link true
      else
        echo 'Not a PR link'
      end
    end

    if not eval $created_pr_link
      echo "Short URL: $short_url"
      echo -n $short_url | pbcopy
    end

    echo 'Copied to clipboard'
  else
    echo 'Please copy a GitHub url to your clipboard'
  end
end

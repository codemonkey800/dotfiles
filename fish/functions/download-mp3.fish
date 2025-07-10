function download-mp3
  set -l id ""
  set -l output "%(title)s.%(ext)s"

  function _print_help
    echo "Usage: download-mp3 --id <video_id> [--output <output_template>]"
    echo ""
    echo "Options:"
    echo "  --id       (required) YouTube video ID"
    echo "  --output   (optional) Output filename template (default: '%(title)s.%(ext)s')"
    echo "  -h, --help           Show this help message"
  end

  set -l argv_copy $argv
  while test (count $argv_copy) -gt 0
    set -l arg $argv_copy[1]
    switch $arg
      case --id '--id=*'
        if string match -q -- '--id=*' $arg
          set id (string replace -- '--id=' '' $arg)
          set argv_copy $argv_copy[2..-1]
        else
          if test (count $argv_copy) -lt 2
            echo "Error: --id requires a value"
            _print_help
            return -1
          end
          set id $argv_copy[2]
          set argv_copy $argv_copy[3..-1]
        end

      case --output '--output=*'
        if string match -q -- '--output=*' $arg
          set output (string replace -- '--output=' '' $arg)
          set argv_copy $argv_copy[2..-1]
        else
          if test (count $argv_copy) -lt 2
            echo "Error: --output requires a value"
            _print_help
            return -1
          end
          set output $argv_copy[2]
          set argv_copy $argv_copy[3..-1]
        end

      case -h --help
        _print_help
        return 0

      case \*
        echo "Invalid flag: $arg"
        _print_help
        return -1
    end
  end

  if test -z "$id"
    echo "Error: --id is required."
    _print_help
    return -1
  end

  yt-dlp \
    -f bestaudio/best \
    -x \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    -o "$output" \
    "https://www.youtube.com/watch?v=$id"
end

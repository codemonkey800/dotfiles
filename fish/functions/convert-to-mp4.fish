function convert-to-mp4 -d 'Converts video files to MP4 using ffmpeg with optimal settings'
  set -l input_file ""
  set -l output_file ""

  function _print_help
    echo "Usage: convert-to-mp4 <input_file> [output_file]"
    echo ""
    echo "Converts video files to MP4 using ffmpeg with archival quality H.264/AAC encoding."
    echo ""
    echo "Arguments:"
    echo "  input_file   (required) Path to input video file"
    echo "  output_file  (optional) Output MP4 filename (default: input name with .mp4 extension)"
    echo ""
    echo "Options:"
    echo "  -h, --help   Show this help message"
    echo ""
    echo "Examples:"
    echo "  convert-to-mp4 video.mov"
    echo "  convert-to-mp4 video.avi output.mp4"
  end

  # Parse arguments
  set -l argv_copy $argv
  while test (count $argv_copy) -gt 0
    set -l arg $argv_copy[1]
    switch $arg
      case -h --help
        _print_help
        return 0
      case \*
        if test -z "$input_file"
          set input_file $arg
        else if test -z "$output_file"
          set output_file $arg
        else
          echo "Error: Too many arguments provided"
          _print_help
          return 1
        end
    end
    set argv_copy $argv_copy[2..-1]
  end

  # Validate input
  if test -z "$input_file"
    echo "Error: Input file is required"
    _print_help
    return 1
  end

  if not test -f "$input_file"
    echo "Error: Input file '$input_file' does not exist"
    return 1
  end

  # Check if ffmpeg is available
  if not command -v ffmpeg >/dev/null
    echo "Error: ffmpeg is not installed or not in PATH"
    echo "Install with: brew install ffmpeg"
    return 1
  end

  # Set output filename if not provided
  if test -z "$output_file"
    set output_file (string replace -r '\.[^.]*$' '.mp4' "$input_file")
  end

  # Ensure output has .mp4 extension
  if not string match -q "*.mp4" "$output_file"
    set output_file "$output_file.mp4"
  end

  # Check if output file already exists
  if test -f "$output_file"
    echo "Warning: Output file '$output_file' already exists"
    read -l -P "Overwrite? [y/N] " confirm
    if not string match -qi "y*" "$confirm"
      echo "Conversion cancelled"
      return 0
    end
  end

  echo "Converting '$input_file' to '$output_file'..."

  # Use ffmpeg with archival quality settings for MP4 conversion
  ffmpeg \
    -i "$input_file" \
    -c:v libx264 \
    -preset medium \
    -crf 18 \
    -c:a aac \
    -b:a 192k \
    -movflags +faststart \
    -y \
    "$output_file"

  set -l exit_code $status
  if test $exit_code -eq 0
    echo "Conversion completed successfully: '$output_file'"
  else
    echo "Conversion failed with exit code $exit_code"
    return $exit_code
  end
end
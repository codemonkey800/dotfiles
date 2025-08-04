# Completions for claude-cleanup script

# Disable file completions for most options
complete -c claude-cleanup -f

# First positional argument: operations
complete -c claude-cleanup -n '__fish_is_first_token' -a 'remove' -d 'Remove entire project entries matching pattern'
complete -c claude-cleanup -n '__fish_is_first_token' -a 'clean-history' -d 'Clear conversation history for matching projects'
complete -c claude-cleanup -n '__fish_is_first_token' -a 'list' -d 'List projects with conversation history counts'

# Second positional argument: directory completions for remove/clean-history, pattern for list
complete -c claude-cleanup -n '__fish_seen_subcommand_from remove clean-history' -a '(claude-cleanup list 2>/dev/null | sed -n "s/^[[:space:]]*\\([^[:space:]].*[^[:space:]]\\)[[:space:]]*\\[.*\\]\$/\\1/p")' -d 'Project directory'
complete -c claude-cleanup -n '__fish_seen_subcommand_from list' -a '' -d 'Regex pattern to match project paths (optional)'

# Flags
complete -c claude-cleanup -l dry-run -d 'Preview changes without modifying files'
complete -c claude-cleanup -l verbose -d 'Show detailed output'
complete -c claude-cleanup -l help -d 'Show help message'
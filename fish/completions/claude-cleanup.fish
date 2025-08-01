# Completions for claude-cleanup script

# Disable file completions for most options
complete -c claude-cleanup -f

# Operations
complete -c claude-cleanup -l operation -d "Operation to perform" -xa "remove clean-history list"
complete -c claude-cleanup -l operation -d "Remove entire project entries" -xa "remove"
complete -c claude-cleanup -l operation -d "Clear conversation history" -xa "clean-history"
complete -c claude-cleanup -l operation -d "List projects with history counts" -xa "list"

# Pattern option
complete -c claude-cleanup -l pattern -d "Regex pattern to match project paths"

# Flags
complete -c claude-cleanup -l dry-run -d "Preview changes without modifying files"
complete -c claude-cleanup -l verbose -d "Show detailed output"
complete -c claude-cleanup -l help -d "Show help message"

# Backup suffix option
complete -c claude-cleanup -l backup-suffix -d "Custom backup file suffix (default: .backup)"

# Enable file completion only for pattern and backup-suffix arguments
complete -c claude-cleanup -l pattern -r
complete -c claude-cleanup -l backup-suffix -r
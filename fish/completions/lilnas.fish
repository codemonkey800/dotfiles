#!/usr/bin/env fish
# Fish shell completions for lilnas
#
# Installation:
#   Copy to ~/.config/fish/completions/lilnas.fish
#   or source this file: source lilnas.fish
#
# Usage:
#   lilnas <tab>           - Show available commands
#   lilnas up <tab>        - Show available services
#   lilnas up --<tab>      - Show available flags

# Helper function to check if no command has been specified yet
function __lilnas_no_command
    set -l cmd (commandline -opc)
    set -e cmd[1] # Remove the command itself
    test (count $cmd) -eq 0
end

# Helper function to check if using a specific command
function __lilnas_using_command
    set -l cmd (commandline -opc)
    test (count $cmd) -gt 1 -a "$cmd[2]" = "$argv[1]"
end

# Helper function to check if a flag is not present
function __lilnas_flag_not_present
    set -l cmd (commandline -opc)
    not contains -- "$argv[1]" $cmd
end

# Helper function to check if neither --apps nor --services is present
function __lilnas_no_filter_flags
    __lilnas_flag_not_present --apps
    and __lilnas_flag_not_present --services
end

# Get the script directory
function __lilnas_script_dir
    set -l script_path (which lilnas 2>/dev/null)
    if test -z "$script_path"
        # Try looking for lilnas.fish in current directory
        if test -f ./lilnas.fish
            set script_path (realpath ./lilnas.fish)
        else
            return 1
        end
    end
    dirname (realpath $script_path)
end

# Helper function to list all services
function __lilnas_list_all_services
    if type -q lilnas
        lilnas list 2>/dev/null | grep -Ev "^Now using Node"
    end
end

# Helper function to list app services only
function __lilnas_list_app_services
    if type -q lilnas
        lilnas list --apps 2>/dev/null | grep -Ev "^Now using Node"
    end
end

# Helper function to list infra services only
function __lilnas_list_infra_services
    if type -q lilnas
        lilnas list --services 2>/dev/null | grep -Ev "^Now using Node"
    end
end

# Complete main commands
complete -c lilnas -f -n '__lilnas_no_command' -a 'list' -d 'List all services in the monorepo'
complete -c lilnas -f -n '__lilnas_no_command' -a 'up' -d 'Bring up services with docker-compose up -d'
complete -c lilnas -f -n '__lilnas_no_command' -a 'down' -d 'Bring down services with docker-compose down'
complete -c lilnas -f -n '__lilnas_no_command' -a 'redeploy' -d 'Redeploy services (bring down then up)'
complete -c lilnas -f -n '__lilnas_no_command' -a 'help' -d 'Show help message'

# Complete help flags (available for all commands)
complete -c lilnas -f -s h -l help -d 'Show help message'

# Complete help flags for individual subcommands
complete -c lilnas -f -n '__lilnas_using_command list' -s h -l help -d 'Show help for list command'
complete -c lilnas -f -n '__lilnas_using_command up' -s h -l help -d 'Show help for up command'
complete -c lilnas -f -n '__lilnas_using_command down' -s h -l help -d 'Show help for down command'
complete -c lilnas -f -n '__lilnas_using_command redeploy' -s h -l help -d 'Show help for redeploy command'

# Complete --apps flag for list/up/down/redeploy (only when --services not present)
complete -c lilnas -f -n '__lilnas_using_command list; and __lilnas_flag_not_present --services' -l apps -d 'Target only package services (from packages/*)'
complete -c lilnas -f -n '__lilnas_using_command up; and __lilnas_flag_not_present --services' -l apps -d 'Target only package services (from packages/*)'
complete -c lilnas -f -n '__lilnas_using_command down; and __lilnas_flag_not_present --services' -l apps -d 'Target only package services (from packages/*)'
complete -c lilnas -f -n '__lilnas_using_command redeploy; and __lilnas_flag_not_present --services' -l apps -d 'Target only package services (from packages/*)'

# Complete --services flag for list/up/down/redeploy (only when --apps not present)
complete -c lilnas -f -n '__lilnas_using_command list; and __lilnas_flag_not_present --apps' -l services -d 'Target only infrastructure services (from infra/*)'
complete -c lilnas -f -n '__lilnas_using_command up; and __lilnas_flag_not_present --apps' -l services -d 'Target only infrastructure services (from infra/*)'
complete -c lilnas -f -n '__lilnas_using_command down; and __lilnas_flag_not_present --apps' -l services -d 'Target only infrastructure services (from infra/*)'
complete -c lilnas -f -n '__lilnas_using_command redeploy; and __lilnas_flag_not_present --apps' -l services -d 'Target only infrastructure services (from infra/*)'

# Complete service names for up command (only when no filter flags present)
complete -c lilnas -f -n '__lilnas_using_command up; and __lilnas_no_filter_flags' -a '(__lilnas_list_all_services)' -d 'Service name'

# Complete service names for down command (only when no filter flags present)
complete -c lilnas -f -n '__lilnas_using_command down; and __lilnas_no_filter_flags' -a '(__lilnas_list_all_services)' -d 'Service name'

# Complete service names for redeploy command (only when no filter flags present)
complete -c lilnas -f -n '__lilnas_using_command redeploy; and __lilnas_no_filter_flags' -a '(__lilnas_list_all_services)' -d 'Service name'

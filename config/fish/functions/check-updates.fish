function check-updates -d 'Checks updates for Arch ABS and AUR'
    set -l base_cmd "sort -u | sed 's/^/  /'"
    set -l checkupdates_found false
    set -l checkupdates_aur_found false

    if exists checkupdates
        set checkupdates_found true
    end

    if exists checkupdates-aur
        set checkupdates_aur_found true
    end

    if not eval "$checkupdates_found; and $checkupdates_aur_found"
        echo 'checkupdates nor checkupdate-aur were found.'
        return -1
    else
        if eval $checkupdates_found
            echo 'ABS:'
            eval "checkupdates | $base_cmd"
        end
        if eval $checkupdates_aur_found
            echo 'AUR:'
            eval "checkupdates-aur | $base_cmd"
        end
    end
end


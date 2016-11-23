if exists tree
    function tree -d "Runs the tree command with color enabled and pipes it to less for paging"
       eval  (which tree) -C $argv | less
    end
end


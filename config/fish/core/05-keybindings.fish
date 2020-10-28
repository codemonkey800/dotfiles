# Vi bindings
if test "$fish_key_bindings" = 'fish_vi_key_bindings'
  bind -M default H beginning-of-line
  bind -M default L end-of-line
  bind -M default dH backward-kill-line
  bind -M default dL kill-line
  bind -M default -m insert cH backward-kill-line repaint-mode
  bind -M default -m insert cL kill-line repaint-mode
  bind -M visual H beginning-of-line
  bind -M visual L end-of-line
  bind -M insert -m default jk backward-char force-repaint


  # FZF bindings
  bind -M insert \ef '__fzf_search_current_dir'
  bind -M insert \ed '__fzf_search_dir'
  bind -M insert \ec '__fzf_search_history'
  bind -M insert \eb '__fzf_search_branch'
else
  # FZF bindings
  bind \ez '__fzf_search_current_dir'
  bind \ex '__fzf_search_dir'
  bind \ec '__fzf_search_history'
  bind \ev '__fzf_search_branch'
end


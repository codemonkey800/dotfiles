function __add_pm_tools_dir --on-variable PWD
  if string match -qe ~/projects/postmates $PWD
    set PATH \
      $PATH \
      ~/projects/postmates/tools/bin \
      ~/projects/postmates/skel/src/cloud/deploy
  end
end

__add_pm_tools_dir


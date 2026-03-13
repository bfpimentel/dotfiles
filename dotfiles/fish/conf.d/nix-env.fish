set -l nix_profile_path /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
set -l single_user_profile_path ~/.nix-profile/etc/profile.d/nix.sh

if test -e $nix_profile_path
  set -l owner (string split -n ' ' (command ls -nd /nix/store 2>/dev/null))[3]
  if not test -k /nix/store -a $owner -eq 0
    set nix_profile_path $single_user_profile_path
  end
else
  set nix_profile_path $single_user_profile_path
end

if test -e $nix_profile_path
  for line in (command env -u BASH_ENV bash -c '. "$0"; for name in PATH "${!NIX_@}"; do printf "%s=%s\0" "$name" "${!name}"; done' $nix_profile_path | string split0)
    set -xg (string split -m 1 = $line)
  end

  set -al NIX_PROFILES
  if test (count $NIX_PROFILES) -eq 0
    set -a NIX_PROFILES $HOME/.nix-profile
  end

  set -l __nix_profile_paths (string split ' ' -- $NIX_PROFILES)[-1..1]
  set -l __extra_completionsdir \
    $__nix_profile_paths/etc/fish/completions \
    $__nix_profile_paths/share/fish/vendor_completions.d
  set -l __extra_functionsdir \
    $__nix_profile_paths/etc/fish/functions \
    $__nix_profile_paths/share/fish/vendor_functions.d
  set -l __extra_confdir \
    $__nix_profile_paths/etc/fish/conf.d \
    $__nix_profile_paths/share/fish/vendor_conf.d \

  set -l existing_conf_paths

  for path in $__extra_functionsdir
    if set -l idx (contains --index -- $path $fish_function_path)
      set -e fish_function_path[$idx]
      set -a existing_conf_paths $__extra_confdir[(contains --index -- $path $__extra_functionsdir)]
    end
  end

  if set -l idx (contains --index -- $__fish_data_dir/functions $fish_function_path)
    set -l new_path $fish_function_path[1..$idx]
    set -e new_path[$idx]
    set -a new_path $__extra_functionsdir
    set fish_function_path $new_path $fish_function_path[$idx..-1]
  else
    set -a fish_function_path $__extra_functionsdir
  end

  for path in $__extra_completionsdir
    if set -l idx (contains --index -- $path $fish_complete_path)
      set -e fish_complete_path[$idx]
    end
  end

  if set -l idx (contains --index -- $__fish_data_dir/completions $fish_complete_path)
    set -l new_path $fish_complete_path[1..$idx]
    set -e new_path[$idx]
    set -a new_path $__extra_completionsdir
    set fish_complete_path $new_path $fish_complete_path[$idx..-1]
  else
    set -a fish_complete_path $__extra_completionsdir
  end

  set -l sourcelist

  for file in $__fish_config_dir/conf.d/*.fish $__fish_sysconf_dir/conf.d/*.fish
    set -l basename (string replace -r '^.*/' '' -- $file)
    contains -- $basename $sourcelist
    or set -a sourcelist $basename
  end
  for root in $__extra_confdir
    for file in $root/*.fish
      set -l basename (string replace -r '^.*/' '' -- $file)
      contains -- $basename $sourcelist
      and continue
      set -a sourcelist $basename
      contains -- $root $existing_conf_paths
      and continue
      [ -f $file -a -r $file ]
      and source $file
    end
  end
end

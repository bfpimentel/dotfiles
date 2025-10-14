{
  pkgs,
  ...
}:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    clock24 = true;
    terminal = "xterm-256color";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
        extraConfig = /* tmux */ ''
          set -g @vim_navigator_mapping_left "C-Left C-h"
          set -g @vim_navigator_mapping_right "C-Right C-l"
          set -g @vim_navigator_mapping_up "C-k"
          set -g @vim_navigator_mapping_down "C-j"
          set -g @vim_navigator_mapping_prev "" 
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = /* tmux */ ''
          set -g @continuum-restore 'on'
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = /* tmux */ ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-processes 'lazygit nvim'
        '';
      }
    ];
    extraConfig = /* tmux */ ''
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # Set tmux bar to the top
      set-option -g status-position top

      set -g focus-events on

      # Set window titles to show current directory instead of executable
      set -g automatic-rename on
      set -g automatic-rename-format '#{b:pane_current_path}'

      # Keybinds
      set-window-option -g mode-keys vi

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection

      # remove delay for exiting insert mode with ESC in Neovim
      set -sg escape-time 10

      # Status bar configuration
      set -g status-bg "#24292f"
      set -g status-fg "#adbac7"
      set -g window-status-format '#[fg=#c9d1d9] #I:#W '
      set -g window-status-current-format '#[fg=#58a6ff] 󰻃 #I:#W '
      set -g status-left '#[fg=#ffdf5d]  #{=50:session_name}'
      # set -g status-right '#[fg=green]CPU:#{cpu} #[fg=yellow]MEM:#{mem}'
      set -g pane-border-style fg="#313641"
      set -g pane-active-border-style fg="#58a6ff"
      set -g status-interval 5
      set -g status-justify centre
      set -g status-left-length 50
      set -g message-style fg="#adbac7",bg="#24292f"
    '';
  };
}

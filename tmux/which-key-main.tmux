display-menu -T "#[fg=#BD93F9,bold] WHICH KEY (MAIN) #[default]" -x C -y C \
    "󰁍 Pane Management                                             " p "display-menu -T \"#[fg=#BD93F9,bold] PANE MANAGEMENT #[default]\" -x C -y C \
        \"󰜶 Split Vertical                                          \" v \"split-window -h -c \\\"#{pane_current_path}\\\"\" \
        \"󰜷 Split Horizontal                                        \" h \"split-window -v -c \\\"#{pane_current_path}\\\"\" \
        \"󰊓 Zoom Toggle                                             \" z \"resize-pane -Z\" \
        \"󰗼 Kill Pane                                               \" x \"confirm-before -p \\\"Kill pane #P? (y/n)\\\" kill-pane\" \
        \"󰗽 Break Pane to Window                                    \" b \"break-pane -d\" \
        \"󱊄 Swap Pane Up                                            \" U \"swap-pane -U\" \
        \"󱊁 Swap Pane Down                                          \" D \"swap-pane -D\" \
        \"󰈈 Mark Pane                                               \" m \"select-pane -m\" \
        \"󰈉 Unmark All Panes                                        \" M \"select-pane -M\" \
        \"󰒓 Join Marked Pane                                        \" j \"join-pane\" \
        \"󱗿 Clear Pane History                                      \" c \"clear-history\" \
        \"\" \"\" \"\" \
        \"󰁍 Back to Main Menu                                       \" r \"source-file ~/.config/tmux/which-key-main.tmux\" " \
    "󰐗 Window Management                                           " w "display-menu -T \"#[fg=#BD93F9,bold] WINDOW MANAGEMENT #[default]\" -x C -y C \
        \"󰐗 New Window                                              \" c \"new-window -c \\\"#{pane_current_path}\\\"\" \
        \"󰑕 Rename Window                                           \" R \"command-prompt -I \\\"#W\\\" \\\"rename-window %%\\\"\" \
        \"󰗼 Kill Window                                             \" X \"confirm-before -p \\\"Kill window #W? (y/n)\\\" kill-window\" \
        \"󰕰 Next Window                                             \" n \"next-window\" \
        \"󰕰 Previous Window                                         \" p \"previous-window\" \
        \"󰕰 Last Window                                             \" l \"last-window\" \
        \"󱂬 Swap Window Left                                        \" < \"swap-window -t -1 \\; select-window -t -1\" \
        \"󱂬 Swap Window Right                                       \" > \"swap-window -t +1 \\; select-window -t +1\" \
        \"󰒺 Choose Window List                                      \" W \"choose-tree -Zw\" \
        \"\" \"\" \"\" \
        \"󰁍 Back to Main Menu                                       \" r \"source-file ~/.config/tmux/which-key-main.tmux\" " \
    "󰒺 Session Management                                          " s "display-menu -T \"#[fg=#BD93F9,bold] SESSION MANAGEMENT #[default]\" -x C -y C \
        \"󰒺 New Session                                             \" S \"new-session\" \
        \"󰑕 Rename Session                                          \" R \"command-prompt -I \\\"#S\\\" \\\"rename-session %%\\\"\" \
        \"󰙅 Choose Session                                          \" s \"choose-session\" \
        \"󰒲 Detach Current Client                                   \" d \"detach-client\" \
        \"󰗼 Kill Session                                            \" K \"confirm-before -p \\\"Kill session #S? (y/n)\\\" kill-session\" \
        \"\" \"\" \"\" \
        \"󰁍 Back to Main Menu                                       \" r \"source-file ~/.config/tmux/which-key-main.tmux\" " \
    "󰘺 Layouts and Resizing                                        " L "display-menu -T \"#[fg=#BD93F9,bold] LAYOUTS & RESIZING #[default]\" -x C -y C \
        \"󰘺 Layout Even Horizontal                                  \" 1 \"select-layout even-horizontal\" \
        \"󰘺 Layout Even Vertical                                    \" 2 \"select-layout even-vertical\" \
        \"󰘺 Layout Main Horizontal                                  \" 3 \"select-layout main-horizontal\" \
        \"󰘺 Layout Main Vertical                                    \" 4 \"select-layout main-vertical\" \
        \"󰘺 Layout Tiled                                            \" 5 \"select-layout tiled\" \
        \"󰘺 Spread Panes Evenly                                     \" + \"select-layout -E\" \
        \"󰁍 Resize Left by Five                                     \" H \"resize-pane -L 5\" \
        \"󰁝 Resize Down by Five                                     \" J \"resize-pane -D 5\" \
        \"󰁔 Resize Up by Five                                       \" K \"resize-pane -U 5\" \
        \"󰁅 Resize Right by Five                                    \" L \"resize-pane -R 5\" \
        \"\" \"\" \"\" \
        \"󰁍 Back to Main Menu                                       \" r \"source-file ~/.config/tmux/which-key-main.tmux\" " \
    "󰘔 Buffers and Copy Mode                                       " B "display-menu -T \"#[fg=#BD93F9,bold] BUFFERS & COPY MODE #[default]\" -x C -y C \
        \"󰘔 Enter Copy Mode                                         \" e \"copy-mode\" \
        \"󰅍 List Paste Buffers                                      \" b \"list-buffers\" \
        \"󰅍 Choose Paste Buffer                                     \" c \"choose-buffer\" \
        \"󰅍 Paste Last Buffer                                       \" p \"paste-buffer\" \
        \"\" \"\" \"\" \
        \"󰁍 Back to Main Menu                                       \" r \"source-file ~/.config/tmux/which-key-main.tmux\" " \
    "󰒓 System and Toggles                                          " T "display-menu -T \"#[fg=#BD93F9,bold] SYSTEM & TOGGLES #[default]\" -x C -y C \
        \"󰍽 Mouse On                                                \" m \"set -g mouse on \\; display-message \\\"Mouse: ON\\\"\" \
        \"󰍽 Mouse Off                                               \" M \"set -g mouse off \\; display-message \\\"Mouse: OFF\\\"\" \
        \"󰆫 Synchronize Panes On                                    \" S \"setw -g synchronize-panes on \\; display-message \\\"Sync Panes: ON\\\"\" \
        \"󰆫 Synchronize Panes Off                                   \" y \"setw -g synchronize-panes off \\; display-message \\\"Sync Panes: OFF\\\"\" \
        \"󰏩 Status Position Top                                     \" t \"set -g status-position top\" \
        \"󰏩 Status Position Bottom                                  \" B \"set -g status-position bottom\" \
        \"󰑓 Reload Configuration                                    \" r \"source-file ~/.config/tmux/tmux.conf \\; display-message \\\"Config Reloaded!\\\"\" \
        \"󰛵 List All Keybindings                                    \" k \"list-keys\" \
        \"󰔟 Show Clock                                              \" C \"clock-mode\" \
        \"󰒓 Describe Key                                            \" d \"command-prompt -k \\\"describe-key %%\\\"\" \
        \"\" \"\" \"\" \
        \"󰁍 Back to Main Menu                                       \" r \"source-file ~/.config/tmux/which-key-main.tmux\" " \
    "" "" "" \
    "󰗼 Close Menu                                                  " q "detach-client"

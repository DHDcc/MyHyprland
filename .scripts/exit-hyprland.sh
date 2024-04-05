# close all client windows
# required for graceful exit since many apps aren't good SIGNAL citizens
HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
#
# try to defer a system shutdown
# ( sleep 2; sudo shutdown now ) &  # doesn't work bc bg process is child of hyprland and will get killed with parent
# f*!* it, just shutdown now
#sudo shutdown now

#exit hyprland
# DON'T DO IT! Exiting hyprland aborts shutdown request.
# Instead rely on shutdown to exit hyprland process.
# (Hyprland appears to be a good Linux SIGNAL citizen.)
hyprctl dispatch exit >> /tmp/hypr/hyprexitwithgrace.log 2>&1

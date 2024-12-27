-- Update with path to stats_provider
sbar.exec('killall stats_provider >/dev/null; $CONFIG_DIR/sketchybar-system-stats/target/release/stats_provider --cpu usage --disk usage --memory usage')

-- Add 'disk_usage' item to the bar
local disk_usage = sbar.add('item', 'disk_usage', {
    position = 'center',
    padding_right = 4,
    label = {
        font = {
            family = "SF Pro",
            style = "Bold",
            size = 10,
        },
    }
})

-- Subscribe to system stats updates
disk_usage:subscribe('system_stats', function(env)
    -- Capture system stats from the environment
    local network_rx = env.NETWORK_RX_en0 or "N/A"
    local network_tx = env.NETWORK_TX_en0 or "N/A"
    local cpu_temp = env.CPU_TEMP or "N/A"
    local ram_used = env.RAM_USED or "N/A"

    -- Process CPU_USAGE
    local cpu_usage = env.CPU_USAGE or "N/A" -- Initial value

    -- Build the label to display
    local ram_used_with_max = string.format(
            "%s - %s - %s - %s - %s",
            cpu_usage, cpu_temp, ram_used, network_rx, network_tx
    )

    -- Update the bar item
    disk_usage:set { label = ram_used_with_max }
end)

-- Execute the external stats provider and configure SketchyBar
os.execute([[
    export CONFIG_DIR=~/.config
    ## Start the helper with desired CLI args
    killall stats_provider
    # Update with path to stats_provider and invoke CLI for your desired stats
    # This example will send cpu, disk, and ram usage percentages
    $CONFIG_DIR/sketchybar-system-stats/target/release/stats_provider --cpu temperature usage --memory ram_used ram_total --disk used total --network en0 en6 --interval 1 &
    sketchybar --add item disk_usage right \
               --set disk_usage script="sketchybar --set disk_usage label=\$DISK_USAGE" \
               --subscribe disk_usage system_stats
]])
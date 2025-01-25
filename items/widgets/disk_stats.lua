-- Initialize both event providers
sbar.exec('killall stats_provider >/dev/null; $CONFIG_DIR/sketchybar-system-stats/target/release/stats_provider --disk usage --memory usage --network en0 en6')
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 1.0")

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

-- Variable to store the last CPU load value
local last_cpu_load = "N/A"

-- Subscribe to CPU update events from cpu_load provider
disk_usage:subscribe('cpu_update', function(env)
    last_cpu_load = tonumber(env.total_load)
end)

-- Subscribe to system stats events for other metrics
disk_usage:subscribe('system_stats', function(env)
    -- Handle network interface selection (en0 or en6)
    local network_rx
    local network_tx
    if env.NETWORK_RX_en0 == "0KB/s" and env.NETWORK_TX_en0 == "0KB/s" then
        network_rx = env.NETWORK_RX_en6 or "0KB/s"
        network_tx = env.NETWORK_TX_en6 or "0KB/s"
    else
        network_rx = env.NETWORK_RX_en0 or "0KB/s"
        network_tx = env.NETWORK_TX_en0 or "0KB/s"
    end
    
    -- Get CPU temperature and RAM usage
    local cpu_temp = env.CPU_TEMP or "N/A"
    local ram_used = env.RAM_USED or "N/A"
    
    -- Format the display string with all metrics
    local stats_display = string.format(
        "%s%% - %s - %s - %s - %s",
        last_cpu_load, cpu_temp, ram_used, network_rx, network_tx
    )

    disk_usage:set { label = stats_display }
end)

-- Initialize the stats provider with 1 second update interval
os.execute([[
export CONFIG_DIR=~/.config
killall stats_provider
$CONFIG_DIR/sketchybar-system-stats/target/release/stats_provider --cpu temperature --memory ram_used ram_total --disk used total --network en0 en6 --interval 1 &
sketchybar --add item disk_usage right \
           --set disk_usage script="sketchybar --set disk_usage label=\$DISK_USAGE" \
           --subscribe disk_usage system_stats
]])
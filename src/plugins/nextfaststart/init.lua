-- license:MIT
-- copyright-holders:Robin Verhagen-Guest
local exports = {
	name = "nextfaststart",
	version = "1.0.0",
	description = "Next Fast Startup plugin",
	license = "MIT",
	author = { name = "Robin Verhagen-Guest" }}

local nextfaststart = exports

local reset_subscription, stop_subscription
local port_2f3b_tap_handler, port_2f3b_change_notifier
local plugin_running = false;
local frameskip = 0;
local throttled = true;

local function normal_speed()
	manager.machine.video.frameskip = frameskip
	manager.machine.video.throttled = throttled
end

local function max_speed(backup)
	if(backup) then
		frameskip = manager.machine.video.frameskip
		throttled = manager.machine.video.throttled
	end
	manager.machine.video.frameskip = 10;
	manager.machine.video.throttled = false;
end

local function tap_handler(offset, data, mask)
	if(data == 0) then
		emu.print_info("nextfaststart: Normal Speed command received")
		normal_speed()
	elseif(data == 1) then
		emu.print_info("nextfaststart: Max Speed command received")
		max_speed(false)
	else
		emu.print_info("nextfaststart: Command " .. data .. " ignored")
	end				
	return nil
end

local function reset_notifier()
	local rom = emu.romname();
	if(not plugin_running and rom == "tbblue") then
		plugin_running = true;
		emu.print_info("nextfaststart: Started Next machine at  Max Speed");
		max_speed(true)
		port_2f3b_tap_handler = manager.machine.devices[':maincpu'].spaces["io"]:install_write_tap(0x2f3b, 0x2f3b, "io_2f3b", tap_handler)		
	elseif(plugin_running and rom == "tbblue") then		
		emu.print_info("nextfaststart: Reset at Max Speed")
		max_speed(false)
	elseif(plugin_running and rom ~= "tbblue") then
		emu.print_info("nextfaststart: Reverting to Normal Speed")
		normal_speed()
		plugin_running = false
	end
end

local function stop_notifier()
	if(plugin_running) then
		emu.print_info("nextfaststart: Reverting to Normal Speed")
		normal_speed()					
		plugin_running = false
	end
end

function nextfaststart.startplugin()
	print("nextfaststart: Started plugin")
	reset_subscription = emu.add_machine_reset_notifier(reset_notifier)				
	stop_subscription = emu.add_machine_stop_notifier(stop_notifier)	
end

return exports

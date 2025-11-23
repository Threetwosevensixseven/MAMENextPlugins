-- license:MIT
-- copyright-holders:Robin Verhagen-Guest
local exports = {
	name = "debugstart",
	version = "1.0.0",
	description = "Debugger Startup plugin",
	license = "MIT",
	author = { name = "Robin Verhagen-Guest" }}

local debugstart = exports

local reset_subscription
local plugin_running = false

local function reset_notifier()
	if(not plugin_running) then
		plugin_running = true
		if (manager.machine.debugger ~= nil) then
			emu.print_info("debugstart: Hiding debugger but keeping it enabled")
			manager.machine.debugger.execution_state="run"	
		else
			emu.print_info("debugstart: Debugger not enabled, start MAME with -d")
		end
	end
end

function debugstart.startplugin()
	emu.print_info("debugstart: Started plugin")
	debugstart = emu.add_machine_reset_notifier(reset_notifier)			
end

return exports

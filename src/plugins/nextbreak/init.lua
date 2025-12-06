-- license:MIT
-- copyright-holders:Robin Verhagen-Guest
local exports = {
	name = "nextbreak",
	version = "1.0.0",
	description = "Debugger Startup plugin",
	license = "MIT",
	author = { name = "Robin Verhagen-Guest" }}

local nextbreak = exports

local reset_subscription, opcode_tap_handler
local plugin_running = false
local opcode_tap_installed = false
local break_state = 0
local pc = -1
local cpu

local function handle_opcode(offset, data, mask)
	if((break_state == 0 or break_state == 1) and data == 0xfd) then
		break_state = 1
		pc = offset
	elseif(break_state == 1 and data == 0x00 and cpu.state["PC"].value == pc + 1) then
		emu.print_info("nextbreak: Break!")
		manager.machine.debugger.execution_state = "stop"
		break_state = 0
		pc = -1
	else
		break_state = 0
		pc = -1
	end
end

local function reset_notifier()
	break_state = 0
	local rom = emu.romname()
	if(not plugin_running and rom == "tbblue") then
		plugin_running = true
		if (manager.machine.debugger ~= nil) then
			emu.print_info("nextbreak: Hiding debugger but keeping it enabled")
			manager.machine.debugger.execution_state="run"	
		else
			emu.print_info("nextbreak: Debugger not enabled, start MAME with -d")
		end
		emu.print_info("nextbreak: Watching for $FD $00 break opcode")
		cpu = manager.machine.devices[":maincpu"]
		opcode_tap_handler = manager.machine.devices[':maincpu'].spaces["opcodes"]:install_read_tap(0x0000, 0xffff, "opcodes", handle_opcode)				
	elseif(plugin_running and rom == "tbblue") then		
		manager.machine.debugger.execution_state="run"
	elseif(plugin_running and rom ~= "tbblue") then
		plugin_running = false
	end
end

function nextbreak.startplugin()
	emu.print_info("nextbreak: Started plugin")
	reset_subscription = emu.add_machine_reset_notifier(reset_notifier)
end

return exports

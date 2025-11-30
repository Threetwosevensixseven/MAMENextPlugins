-- license:MIT
-- copyright-holders:Robin Verhagen-Guest
local exports = {
	name = "nextbreak",
	version = "1.0.0",
	description = "Debugger Startup plugin",
	license = "MIT",
	author = { name = "Robin Verhagen-Guest" }}

local nextbreak = exports

local reset_subscription, opcode_tap_handler, port_2f3b_tap_handler
local plugin_running = false
local opcode_tap_installed = false
local break_state = 0

local function handle_opcode(offset, data, mask)
	if(break_state == 0 and data == 0xfd) then
		--emu.print_info("nextbreak: handle_opcode: " .. string.format("%x", offset) .. ", " .. string.format("%x", data) .. ", " .. mask)
		break_state = 1
	elseif(break_state == 1 and data == 0xfd) then
		break_state = 1
	elseif(break_state == 1 and data == 0x00) then
		--emu.print_info("nextbreak: handle_opcode: " .. string.format("%x", offset) .. ", " .. string.format("%x", data) .. ", " .. mask)
		emu.print_info("nextbreak: Break!")
		manager.machine.debugger.execution_state="stop"
		break_state = 0
	else
		break_state = 0
	end
	return nil
end

local function handle_port(offset, data, mask)
	if(not opcode_tap_installed) then
		if( data == 2) then
			opcode_tap_installed = true
			emu.print_info("nextbreak: Installing opcode tap")
			opcode_tap_handler = manager.machine.devices[':maincpu'].spaces["opcodes"]:install_read_tap(0x0000, 0xffff, "opcodes", handle_opcode)	
		else
			emu.print_info("nextbreak: Command " .. data .. " ignored")
		end
	end
	return nil
end

local function reset_notifier()
	break_state = 0
	local rom = emu.romname()
	if(not plugin_running and rom == "tbblue") then
		if (manager.machine.debugger ~= nil) then
			emu.print_info("nextbreak: Hiding debugger but keeping it enabled")
			manager.machine.debugger.execution_state="run"	
		else
			emu.print_info("nextbreak: Debugger not enabled, start MAME with -d")
		end
		emu.print_info("nextbreak: Installing port 0x2f3b tap")
		port_2f3b_tap_handler = manager.machine.devices[':maincpu'].spaces["io"]:install_write_tap(0x2f3b, 0x2f3b, "io_2f3b", handle_port)	
	elseif(plugin_running and rom == "tbblue") then		
		emu.print_info("nextbreak: Reset Next")
	elseif(plugin_running and rom ~= "tbblue") then
		emu.print_info("nextbreak: Reset non-Next")
		plugin_running = false
	end
end

function nextbreak.startplugin()
	emu.print_info("nextbreak: Started plugin")
	reset_subscription = emu.add_machine_reset_notifier(reset_notifier)
end

return exports

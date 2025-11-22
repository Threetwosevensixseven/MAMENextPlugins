-- license:MIT
-- copyright-holders:Robin Verhagen-Guest
local exports = {
	name = "nextfaststart",
	version = "0.0.1",
	description = "Next Fast Startup plugin",
	license = "MIT",
	author = { name = "Robin Verhagen-Guest" }}

local nextfaststart = exports

local reset_subscription, stop_subscription, frame_subscription, nr_tap_handler, nr_change_notifier;
local plugin_running = false;
local frameskip = 0;
local throttled = true;
local state_level = 0;

function nextfaststart.startplugin()
	print("nextfaststart: Started plugin")
	reset_subscription = emu.add_machine_reset_notifier(
			function ()
				local rom = emu.romname();
				if(not plugin_running and rom == "tbblue")
				then
					plugin_running = true;
					state_level = 0;
					emu.print_info("nextfaststart: Started watching Next speed");
					
					--emu.print_info("nextfaststart: nr_7f=" .. manager.machine.devices[':regs_map'].spaces["program"]:read_u8(0x7f))
					
					nr_tap_handler = manager.machine.devices[':regs_map'].spaces["program"]:install_write_tap(127, 127, "m_nr_7f_user_register_0", function(offset, data, mask)
							--if(data >= 32 and data <= 127)
							--then
							--	emu.print_info("nextfaststart: nextreg 0x7f, '" .. string.char(data) .. "'")
							--else
						    -- 	emu.print_info("nextfaststart: nextreg 0x7f, " .. data)
							--end
							
							if(state_level == 0 and data == 77) then -- start to first M							
								state_level = 1
							elseif(state_level == 1 and data == 65) then -- first M to A
								state_level = 2
							elseif(state_level == 2 and data == 77) then -- A to second M
								state_level = 3
							elseif(state_level == 3 and data == 69) then -- second M to E
								state_level = 4
							elseif(state_level == 3 and data == 65) then -- second M reinterpreted as first M back to A
								state_level = 2
							elseif(state_level == 4 and data == 0) then -- E to command 0
						     	emu.print_info("nextfaststart: Slow down command received")
								emu.print_info("nextfaststart: Changing Next frameskip from " .. manager.machine.video.frameskip .. " to " .. frameskip);
								manager.machine.video.frameskip = frameskip;
								emu.print_info("nextfaststart: Changing Next throttled from " .. tostring(manager.machine.video.throttled) .. " to " .. tostring(throttled));	
								manager.machine.video.throttled = throttled;
								state_level = 0
							else
								state_level = 0
							end
							--emu.print_info("nextfaststart: state_level " .. state_level)
							
							return nil
						end)

					nr_change_notifier = manager.machine.devices[':regs_map'].spaces["program"]:add_change_notifier(function(mode)
							emu.print_info("nextfaststart: Reinstalling - mode " .. mode)
							nr_tap_handler:reinstall()
						end)
									
					frameskip = manager.machine.video.frameskip;
					manager.machine.video.frameskip = 10;
					emu.print_info("nextfaststart: Changing Next frameskip from " .. frameskip .. " to " .. manager.machine.video.frameskip);
					throttled = manager.machine.video.throttled;
					manager.machine.video.throttled = false;
					emu.print_info("nextfaststart: Changing Next throttled from " .. tostring(throttled) .. " to " .. tostring(manager.machine.video.throttled));					
				end
			    if(plugin_running and rom ~= "tbblue")
				then
					emu.print_info("nextfaststart: Changing Next frameskip from " .. manager.machine.video.frameskip .. " to " .. frameskip);
					manager.machine.video.frameskip = frameskip;
					emu.print_info("nextfaststart: Changing Next throttled from " .. tostring(manager.machine.video.throttled) .. " to " .. tostring(throttled));	
					manager.machine.video.throttled = throttled;
					emu.print_info("nextfaststart: Stopped watching Next speed");
					plugin_running = false;	
				end
			end)
				
	stop_subscription = emu.add_machine_stop_notifier(
			function ()
				if(plugin_running)
				then
					emu.print_info("nextfaststart: Changing Next frameskip from " .. manager.machine.video.frameskip .. " to " .. frameskip);
					manager.machine.video.frameskip = frameskip;
					emu.print_info("nextfaststart: Changing Next throttled from " .. tostring(manager.machine.video.throttled) .. " to " .. tostring(throttled));	
					manager.machine.video.throttled = throttled;
					emu.print_info("nextfaststart: Stopped watching Next speed");
					
					--if(not nr_tap_handler == nil)
					--then
					--		print("nextfaststart: nr_tap_handler remove")
					--		nr_tap_handler:remove()				
					--end
					
					plugin_running = false;
				end
			end)

	local function menu_populate()
		return {{ "This is a", "test", "off" }, { "Also a", "test", "" }}
	end

	local function menu_callback(index, event)
		emu.print_info("index: " .. index .. " event: " .. event)
		return false
	end

	emu.register_menu(menu_callback, menu_populate, "Next Fast Startup")
end

return exports

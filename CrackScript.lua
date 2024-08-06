util.require_natives("natives-3095a")

local functions = require('CrackScript.lib.functions')
local api = require('CrackScript.lib.api')
local exclude_handler = require('CrackScript.lib.exclude_handler')
local vehicle_copy = require('CrackScript.lib.vehicle_copy')

local scriptHome = filesystem.scripts_dir() .. "/CrackScript/"
local debug_file_path = scriptHome .. "debug.txt"
local chat_log_file_path = scriptHome .. "chat_log.txt"
functions.create_directory(scriptHome)

-------------------------------------
-- Menüerstellung
-------------------------------------
local main_menu = menu.my_root()
local crack_script_menu = menu.list(main_menu, "CrackScript", {}, "Options for CrackScript")
local toxic_menu = menu.list(crack_script_menu, "Toxic", {}, "Toxic actions")
local host_only_menu = menu.list(toxic_menu, "Host Only", {}, "Host only actions")
local kick_menu = menu.list(toxic_menu, "Kick", {}, "Kick actions")
local crash_menu = menu.list(toxic_menu, "Crash", {}, "Crash actions")
local exclude_menu = menu.list(crack_script_menu, "Exclude", {}, "Exclude actions for all toxic actions in CrackScript")
local chat_options_menu = menu.list(crack_script_menu, "Chat Options", {}, "Options for chat")
local vehicle_menu = menu.list(crack_script_menu, "Vehicles", {}, "Vehicle options")

-------------------------------------
-- Menüaktionen für Ausschlussoptionen
-------------------------------------
local exclude_self_toggle = true
menu.toggle(exclude_menu, "Exclude Self", {}, "Exclude Self", function(state)
    exclude_self_toggle = state
    functions.log_debug("Exclude Self toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Self toggled: " .. tostring(state))
    exclude_handler.set_exclude_self(state)
end, true)

local exclude_friends_toggle = false
menu.toggle(exclude_menu, "Exclude Friends", {}, "Exclude Friends", function(state)
    exclude_friends_toggle = state
    functions.log_debug("Exclude Friends toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Friends toggled: " .. tostring(state))
    exclude_handler.set_exclude_friends(state)
end, false)

-------------------------------------
-- Menüaktionen für Chatoptionen
-------------------------------------
local log_chat_toggle, kick_prohibited_chat_toggle, detect_ip_toggle = false, false, false

chat_options_menu:toggle("Log Chat to Textfile", {}, "Log all chat messages to a text file", function(state)
    log_chat_toggle = state
    functions.log_debug("Log Chat to Textfile toggled: " .. tostring(state), debug_file_path)
    util.toast("Log Chat to Textfile toggled: " .. tostring(state))
end, false)

chat_options_menu:toggle("Kick Russian/Chinese Chatters", {}, "Kick players using Russian or Chinese characters", function(state)
    kick_prohibited_chat_toggle = state
    functions.log_debug("Kick Russian/Chinese Chatters toggled: " .. tostring(state), debug_file_path)
    util.toast("Kick Russian/Chinese Chatters toggled: " .. tostring(state))
    exclude_handler.set_kick_prohibited_chat(state)
end, false)

chat_options_menu:toggle("Anti IP Share", {}, "Detect IP addresses in chat and respond with sender's IP", function(state)
    detect_ip_toggle = state
    functions.log_debug("Detect IP Addresses toggled: " .. tostring(state), debug_file_path)
    util.toast("Detect IP Addresses toggled: " .. tostring(state))
    exclude_handler.set_detect_ip(state)
end, false)

chat.on_message(function(_, message_sender, message_text)
    local player_name = players.get_name(message_sender)
    functions.log_debug("Chat message received - Player: " .. player_name .. ", Message: " .. message_text, debug_file_path)
    api.handle_chat_message(log_chat_toggle, kick_prohibited_chat_toggle, detect_ip_toggle, player_name, message_text, message_sender, chat_log_file_path, debug_file_path)
end)

-------------------------------------
-- Menüaktionen für Host-Only-Optionen
-------------------------------------
host_only_menu:toggle("Anti-Barcode", {}, "Block players with barcode-style names from joining", function(state)
    api.set_anti_barcode(state)
    functions.log_debug("Anti-Barcode toggled: " .. tostring(state), debug_file_path)
    util.toast("Anti-Barcode toggled: " .. tostring(state))
    exclude_handler.set_anti_barcode(state)
end, false)

-------------------------------------
-- Menüaktionen für Kick-Optionen
-------------------------------------
kick_menu:action("Kick All Players", {"kickall"}, "Kick all players in the lobby", function()
    exclude_handler.kick_all_players(debug_file_path)
    util.toast("Kicked all players in the lobby")
end)

kick_menu:action("Kick Session Host", {"kicksessionhost"}, "Kick the session host", function()
    api.kick_session_host(debug_file_path)
end)

kick_menu:action("Kick All Modders", {"kickmodders"}, "Kick all modders in the lobby", function()
    exclude_handler.kick_all_modders(debug_file_path)
    util.toast("Kicked all modders in the lobby")
end)

kick_menu:action("Kick Random Player", {"kickrandom"}, "Kick a random player in the lobby", function()
    exclude_handler.kick_random_player(debug_file_path)
end)

-------------------------------------
-- Menüaktionen für Crash-Optionen
-------------------------------------
crash_menu:action("Crash All Players", {"crashall"}, "Crash all players in the lobby", function()
    exclude_handler.crash_all_players(debug_file_path)
    util.toast("Crashed all players in the lobby")
end)

-------------------------------------
-- Menüaktionen für Fahrzeuge
-------------------------------------
vehicle_menu:action("Copy Current Vehicle", {"vehcopy"}, "Copy the vehicle you are currently in.", function()
    vehicle_copy.copy_current_vehicle()
end)
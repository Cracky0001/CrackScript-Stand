util.require_natives(1663599433)

local functions = require('lib.crackscript.functions')
local api = require('lib.crackscript.api')

local scriptHome = filesystem.scripts_dir() .. "/CrackScript/"
local debug_file_path = scriptHome .. "debug.txt"
local chat_log_file_path = scriptHome .. "chat_log.txt"
local blacklist_file_path = scriptHome .. "antiRus.txt"

functions.create_directory(scriptHome)
functions.generate_blacklist(blacklist_file_path)

local log_chat_toggle = false
local kick_prohibited_chat_toggle = false
local detect_ip_toggle = false
local anti_barcode_toggle = false

local exclude_friends_toggle = false
local exclude_org_toggle = false
local exclude_crew_toggle = false
local exclude_strangers_toggle = false

local blacklist = functions.load_blacklist(blacklist_file_path)

local main_menu = menu.my_root()

local crack_script_menu = menu.list(main_menu, "CrackScript", {}, "Options for CrackScript")

local chat_options_menu = menu.list(crack_script_menu, "Chat Options", {}, "Options for chat")
chat_options_menu:toggle("Log Chat to Textfile", {}, "Log all chat messages to a text file", function(state)
    log_chat_toggle = state
    functions.log_debug("Log Chat to Textfile toggled: " .. tostring(state), debug_file_path)
    util.toast("Log Chat to Textfile toggled: " .. tostring(state))
end, false)
chat_options_menu:toggle("Kick Russian/Chinese Chatters", {}, "Kick players using Russian or Chinese characters", function(state)
    kick_prohibited_chat_toggle = state
    functions.log_debug("Kick Russian/Chinese Chatters toggled: " .. tostring(state), debug_file_path)
    util.toast("Kick Russian/Chinese Chatters toggled: " .. tostring(state))
end, false)
chat_options_menu:toggle("Anti IP Share", {}, "Detect IP addresses in chat and respond with sender's IP", function(state)
    detect_ip_toggle = state
    functions.log_debug("Detect IP Addresses toggled: " .. tostring(state), debug_file_path)
    util.toast("Detect IP Addresses toggled: " .. tostring(state))
end, false)

chat.on_message(function(packet_sender, message_sender, message_text, is_team_chat)
    local player_name = players.get_name(message_sender)
    functions.log_debug("Chat message received - Player: " .. player_name .. ", Message: " .. message_text, debug_file_path)
    api.handle_chat_message(log_chat_toggle, kick_prohibited_chat_toggle, detect_ip_toggle, player_name, message_text, message_sender, chat_log_file_path, debug_file_path, blacklist)
end)

local toxic_menu = menu.list(crack_script_menu, "Toxic", {}, "Toxic actions")
local exclude_options_menu = menu.list(toxic_menu, "Exclude", {}, "Exclude Options")
exclude_options_menu:toggle("Exclude Friends (BROKE)", {}, "Exclude friends from actions", function(state)
    exclude_friends_toggle = state
    functions.log_debug("Exclude Friends toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Friends toggled: " .. tostring(state))
end, false)
exclude_options_menu:toggle("Exclude Organization", {}, "Exclude organization members from actions", function(state)
    exclude_org_toggle = state
    functions.log_debug("Exclude Organization toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Organization toggled: " .. tostring(state))
end, false)
exclude_options_menu:toggle("Exclude Crew", {}, "Exclude crew members from actions", function(state)
    exclude_crew_toggle = state
    functions.log_debug("Exclude Crew toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Crew toggled: " .. tostring(state))
end, false)
exclude_options_menu:toggle("Exclude Strangers", {}, "Exclude strangers from actions", function(state)
    exclude_strangers_toggle = state
    functions.log_debug("Exclude Strangers toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Strangers toggled: " .. tostring(state))
end, false)

toxic_menu:action("Kick All Players", {"kickall"}, "Kick all players in the lobby", function()
    api.kick_all_players(debug_file_path, exclude_friends_toggle, exclude_org_toggle, exclude_crew_toggle, exclude_strangers_toggle)
    util.toast("Kicked all players in the lobby")
end)
toxic_menu:action("Crash All Players", {"crashall"}, "Crash all players in the lobby", function()
    api.crash_all_players(debug_file_path, exclude_friends_toggle, exclude_org_toggle, exclude_crew_toggle, exclude_strangers_toggle)
    util.toast("Crashed all players in the lobby")
end)
toxic_menu:action("Kick Session Host", {"kicksessionhost"}, "Kick the session host", function()
    api.kick_session_host(debug_file_path)
end)

toxic_menu:toggle("Anti-Barcode", {}, "Kick players with barcode-style names", function(state)
    anti_barcode_toggle = state
    functions.log_debug("Anti-Barcode toggled: " .. tostring(state), debug_file_path)
    util.toast("Anti-Barcode toggled: " .. tostring(state))
end, false)

toxic_menu:action("Kick All Modders", {"kickmodders"}, "Kick all modders in the lobby", function()
    api.kick_all_modders(debug_file_path, exclude_friends_toggle, exclude_org_toggle, exclude_crew_toggle, exclude_strangers_toggle)
    util.toast("Kicked all modders in the lobby")
end)

toxic_menu:action("Kick Random Player", {"kickrandom"}, "Kick a random player in the lobby", function()
    api.kick_random_player(debug_file_path)
end)

players.on_join(function(pid)
    if anti_barcode_toggle then
        local player_name = players.get_name(pid)
        if functions.is_barcode_name(player_name) then
            menu.trigger_commands("kick " .. player_name)
            functions.log_debug("Kicked barcode player on join: " .. player_name, debug_file_path)
            util.toast("Kicked barcode player on join: " .. player_name)
        end
    end
end)

-- CrackScript.lua
util.require_natives(1663599433)

local functions = require('lib.crackscript.functions')
local api = require('lib.crackscript.api')

local scriptHome = filesystem.scripts_dir() .. "/CrackScript/"
local debug_file_path = scriptHome .. "debug.txt"
local chat_log_file_path = scriptHome .. "chat_log.txt"
local blacklist_file_path = scriptHome .. "antiRus.txt"
local chatbot_file_path = scriptHome .. "chatbot.json"

functions.create_directory(scriptHome)
functions.generate_blacklist(blacklist_file_path)
if not filesystem.exists(chatbot_file_path) then
    functions.generate_default_chatbot(chatbot_file_path)
end

local log_chat_toggle = false
local kick_prohibited_chat_toggle = false
local chat_bot_toggle = false
local detect_ip_toggle = false
local chatbot_delay = 1000  -- Default delay in milliseconds

local blacklist = functions.load_blacklist(blacklist_file_path)
local chatbot_data = functions.load_chatbot(chatbot_file_path)

local main_menu = menu.my_root()

local crack_script_menu = menu.list(main_menu, "CrackScript", {}, "Options for CrackScript")

local chat_options_menu = menu.list(crack_script_menu, "Chat Options", {}, "Options for chat")
chat_options_menu:toggle("Log Chat to Textfile", {}, "Log all chat messages to a text file", function(state)
    log_chat_toggle = state
    functions.log_debug("Log Chat to Textfile toggled: " .. tostring(state), debug_file_path)
end, false)
chat_options_menu:toggle("Kick Russian/Chinese Chatters", {}, "Kick players using Russian or Chinese characters", function(state)
    kick_prohibited_chat_toggle = state
    functions.log_debug("Kick Russian/Chinese Chatters toggled: " .. tostring(state), debug_file_path)
end, false)

-- New Chatbot Subcategory
local chatbot_options_menu = menu.list(chat_options_menu, "Chat Bot (Doesn't work!)", {}, "Options for Chat Bot")
chatbot_options_menu:toggle("Enable", {}, "Enable the Chat Bot", function(state)
    chat_bot_toggle = state
    functions.log_debug("Chat Bot toggled: " .. tostring(state), debug_file_path)
end, false)
chatbot_options_menu:slider("Response Delay (ms)", {}, "Delay in milliseconds before the Chat Bot responds", 0, 10000, chatbot_delay, 100, function(value)
    chatbot_delay = value
    functions.log_debug("Chat Bot delay set to: " .. tostring(value) .. " ms", debug_file_path)
end)
chatbot_options_menu:toggle("Detect IP Addresses", {}, "Detect IP addresses in chat and respond with sender's IP", function(state)
    detect_ip_toggle = state
    functions.log_debug("Detect IP Addresses toggled: " .. tostring(state), debug_file_path)
end, false)

chat.on_message(function(packet_sender, message_sender, message_text, is_team_chat)
    local player_name = players.get_name(message_sender)
    functions.log_debug("Chat message received - Player: " .. player_name .. ", Message: " .. message_text, debug_file_path)
    if log_chat_toggle then
        api.log_chat_to_file(chat_log_file_path, player_name, message_text)
    end
    if kick_prohibited_chat_toggle then
        api.kick_if_prohibited_characters(player_name, message_text, debug_file_path, blacklist)
    end
    if chat_bot_toggle then
        util.yield(chatbot_delay)  -- Delay before responding
        local triggered, response = api.respond_to_chat_message(player_name, message_text, chatbot_data)
        if triggered then
            util.toast("Chatbot triggered: " .. response)
        end
    end
    if detect_ip_toggle then
        api.detect_ip_and_respond(player_name, message_text, debug_file_path)
    end
end)

local toxic_menu = menu.list(crack_script_menu, "Toxic", {}, "Toxic actions")
toxic_menu:action("Kick All Players", {"kickall"}, "Kick all players in the lobby", function()
    api.kick_all_players(debug_file_path)
end)
toxic_menu:action("Crash All Players", {"crashall"}, "Crash all players in the lobby", function()
    api.crash_all_players(debug_file_path)
end)

toxic_menu:action("Kick Session Host", {"kicksessionhost"}, "Kick the session host", function()
    local host_id = players.get_host()
    if host_id == players.user() then
        util.toast("You are the session host. Kicking yourself will disconnect you from the session. Are you sure you want to proceed? Type /yes to confirm.")
        
        chat.on_message(function(packet_sender, message_sender, message_text, is_team_chat)
            if players.get_name(message_sender) == players.get_name(players.user()) and message_text == "/yes" then
                menu.trigger_commands("kick " .. players.get_name(host_id))
                functions.log_debug("Kicked self as session host", debug_file_path)
            end
        end)
    else
        menu.trigger_commands("kick " .. players.get_name(host_id))
        functions.log_debug("Kicked session host: " .. players.get_name(host_id), debug_file_path)
    end
end)

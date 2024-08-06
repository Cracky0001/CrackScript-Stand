local functions = require('CrackScript.lib.functions')
local chat_kick = require('CrackScript.lib.chat_kick')
local exclude_handler = require('CrackScript.lib.exclude_handler')

local api = {}
local anti_barcode_toggle = false

api.set_anti_barcode = function(state)
    anti_barcode_toggle = state
    exclude_handler.set_anti_barcode(state)
end

api.handle_chat_message = function(log_chat_toggle, kick_prohibited_chat_toggle, detect_ip_toggle, player_name, message_text, message_sender, chat_log_file_path, debug_file_path)
    exclude_handler.handle_chat_message(log_chat_toggle, kick_prohibited_chat_toggle, detect_ip_toggle, player_name, message_text, message_sender, chat_log_file_path, debug_file_path)
end

api.kick_session_host = function(debug_file_path)
    local host_id = players.get_host()
    if host_id == players.user() then
        util.toast("You are the session host you idiot!")
        chat.on_message(function(_, message_sender, message_text)
            if players.get_name(message_sender) == players.get_name(players.user()) and message_text == "/yes" then
                menu.trigger_commands("kick " .. players.get_name(host_id))
                functions.log_debug("Kicked self as session host", debug_file_path)
                util.toast("Kicked self as session host")
            end
        end)
    else
        menu.trigger_commands("kick " .. players.get_name(host_id))
        functions.log_debug("Kicked session host: " .. players.get_name(host_id), debug_file_path)
        util.toast("Kicked session host: " .. players.get_name(host_id))
    end
end

api.check_and_block_barcode = function(pid)
    exclude_handler.check_and_block_barcode(pid)
end

return api

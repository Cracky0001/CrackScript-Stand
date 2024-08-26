function kickRussianChineseChat()
    chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
        local player_name = players.get_name(sender)
        for pid, name in ipairs(players.list(false, false, true)) do
            if name == player_name and not players.is_friend(pid) and sender ~= players.user() then
                if string.match(text, "[\u{4e00}-\u{9fa5}]") or string.match(text, "[\u{0400}-\u{04FF}]") then
                    util.toast("Kicking " .. player_name .. " for using Russian or Chinese characters in chat")
                    menu.trigger_commands("kick " .. player_name)
                end
            end
        end
    end)
end

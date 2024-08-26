function antiIPShare()
    chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
        local player_name = players.get_name(sender)
        for pid, name in ipairs(players.list(false, false, true)) do
            if name == player_name and not players.is_friend(pid) and sender ~= players.user() then
                if string.match(text, "%d+%.%d+%.%d+%.%d+") then
                    util.toast("Kicking " .. player_name .. " for sharing an IP address in chat")
                    menu.trigger_commands("kick " .. player_name)
                end
            end
        end
    end)
end

function kickModders()
    for _, pid in ipairs(players.list(false, false, true)) do
        if players.is_marked_as_modder(pid) then
            menu.trigger_commands("kick " .. players.get_name(pid))
        end
    end
end

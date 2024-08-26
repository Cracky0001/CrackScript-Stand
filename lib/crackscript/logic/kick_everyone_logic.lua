function kickEveryone()
    for _, pid in ipairs(players.list(false, false, true)) do
        if pid ~= players.user() then
            menu.trigger_commands("kick " .. players.get_name(pid))
        end
    end
end

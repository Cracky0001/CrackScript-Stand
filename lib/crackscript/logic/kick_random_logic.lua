function kickRandom()
    local playersList = players.list(false, false, true)
    local randomPlayer = playersList[math.random(#playersList)]
    if randomPlayer ~= players.user() then
        menu.trigger_commands("kick " .. players.get_name(randomPlayer))
        util.toast("Kicked " .. players.get_name(randomPlayer))
    end
end

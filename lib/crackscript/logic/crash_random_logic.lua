function crashRandom()
    local playersList = players.list(false, false, true)
    local randomPlayer = playersList[math.random(#playersList)]
    if randomPlayer ~= players.user() then
        menu.trigger_commands("crash " .. players.get_name(randomPlayer))
        util.toast("Crashed " .. players.get_name(randomPlayer))
    end
end

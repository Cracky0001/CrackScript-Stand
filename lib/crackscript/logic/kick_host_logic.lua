function kickHost()
    for _, pid in ipairs(players.list(false, false, true)) do
        if pid == players.get_host() then
            menu.trigger_commands("kick " .. players.get_name(pid))
            util.toast("Kicked the host: " .. players.get_name(pid))
        else
            util.toast("It seems like you or a friend is the host! " .. shrugFace)
        end
    end
end

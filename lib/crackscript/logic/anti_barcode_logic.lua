function checkBarcodeName()
    if antiBarcodeEnabled and players.get_host() == players.user() then
        for pid, name in ipairs(players.list(false, false, true)) do
            if string.match(name, "l") or string.match(name, "I") or string.match(name, "1") or string.match(name, "0") then
                util.toast("Kicking " .. name .. " for barcode name")
                menu.trigger_commands("kick " .. name)
            end
        end
    end
end

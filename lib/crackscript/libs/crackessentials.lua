-- Lua Scripts/crackscript/libs/crackessentials.lua

-- xQueenyx => essential stuff go here

function ObtainName(pid)
    return players.get_name(pid)
end

function IsFriend(pid) -- Cwacky => this function is not working and triggers an error on every damned chat message
    return players.is_friend(pid) 
end

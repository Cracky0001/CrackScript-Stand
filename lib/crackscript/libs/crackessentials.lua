-- Lua Scripts/crackscript/libs/crackessentials.lua

-- xQueenyx => essential stuff go here

------------------------------------------------------------------------------------------------------------------------
--                                              player functions                                                      --
------------------------------------------------------------------------------------------------------------------------
-- Obtain player name based on their player ID
function ObtainName(pid)
    return players.get_name(pid)
end

-- Check if a player is a friend
function IsFriend(pid)
    return players.is_friend(pid) -- Cwacky => macht probleme oder ich bin zu blöd das richtig anzuwenden.
end

-- Check if a player is a modder
function IsModder(pid)
    return players.is_marked_as_modder(pid)
end

-- Check if player is the session host
function IsPlayerHost(pid)
    return players.get_host() == pid
end



------------------------------------------------------------------------------------------------------------------------
--                                              chat functions                                                        --
-- Parameters: 1. message (string), 2. team_chat (bool), 3. local history (bool), 4. networked (bool)                 --
------------------------------------------------------------------------------------------------------------------------
-- Send chat message to all players
function SendGlobalChatMessage(message)
    chat.send_message(message, false, true, true)
end

-- Send chat message to Team/Organization chat
function SendTeamChatMessage(message)
    chat.send_message(message, true, false, false)
end

-- Send chat message in Local chat
function SendLocalChatMessage(message)
    chat.send_message(message, true, true, false)
end



------------------------------------------------------------------------------------------------------------------------
--                                              debug functions                                                       --
------------------------------------------------------------------------------------------------------------------------
function DebugPrint(msg)
    util.log("[CrackyScript] " .. msg)
end

function DebugPrintError(msg)
    util.log("[CrackyScript] [ERROR] " .. msg)
end

function DebugPrintWarning(msg)
    util.log("[CrackyScript] [WARNING] " .. msg)
end

function DebugPrintSuccess(msg)
    util.log("[CrackyScript] [SUCCESS] " .. msg)
end

function DebugPrintInfo(msg)
    util.log("[CrackyScript] [INFO] " .. msg)
end


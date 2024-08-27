-- Lua Scripts/crackscript/libs/functions.lua

-- xQueenyx => rewriting the functions and moving it to one file for a better overview ;) 
-- Cwacky => Fenk juuuu ♥

-- Cwacky => 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Chat Functions wie Kick bei IP-Adressen, anti russian/chinese chat, anti beggar Dürfen nicht menu.toggle_loop sein sondern menu.toggle.
-- machen aber trozdem noch probleme!
-- Desweiteren müsstest du einmal in crackessentials.lua die Funktion IsFriend(pid) anpassen, da sie nicht funktioniert.
-- ich habe statt "IsFriend(pid)" wieder die for _, "pid in ipairs(players.list(false, false, true)) do" genutzt, da es sonst zu einem Fehler kommt.
-- Ehm ja, das wars eigentlich schon. :D 
----------------------------------------------------------------------------------------------------------------------------------------------------------------

local self = {}
require("crackscript.libs.crackessentials")
function self.checkBarcodeName()
    if antiBarcodeEnabled and players.get_host() == players.user() then
        for _, pid in ipairs(players.list(false, false, true)) do
            local name = ObtainName(pid)
            -- Überprüfe auf eine Kombination aus l, I, 1, 0, die eine Barcode-Struktur darstellt
            if string.match(name, "^[lI10]+$") and string.len(name) >= 3 then
                util.toast("Kicking " .. name .. " for barcode name")
                menu.trigger_commands("kick " .. name)
            end
        end
    end
end

function self.antiIPShare()
    chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
        local player_name = ObtainName(sender)
        util.log("Received message from: " .. player_name .. ", Message: " .. text)
        for _, pid in ipairs(players.list(false, false, true)) do
            util.log("Checking player with pid: " .. pid)
            if pid == sender then  -- Check if the sender is in the list
                for _, phrase in ipairs(blacklistedPhrases) do
                    if string.match(text:lower(), phrase:lower()) then
                        util.toast("Kicking " .. player_name .. " for bagging")
                        menu.trigger_commands("kick " .. player_name)
                        break
                    end
                end
            end
        end
    end)
end



-- function to copy the vehicle of the local player (ghettofix)
function self.copyVehicle()
    local player_id = players.user() 
    local player_name = players.get_name(player_id)  
    menu.trigger_commands("copyvehicle " .. player_name)
end

-- function to crash a random player
function self.crashRandom()
    local playersList = players.list(false, false, true)
    local randomPlayer = playersList[math.random(#playersList)]
    if randomPlayer ~= players.user() then
        local plname = ObtainName(randomPlayer)
        menu.trigger_commands("crash " .. plname)
        util.toast("Crashed " .. plname)
    end
end

-- function to kick a random player
function self.kickRandom()
    local playersList = players.list(false, false, true)
    local randomPlayer = playersList[math.random(#playersList)]
    if randomPlayer ~= players.user() then
        local plname = ObtainName(randomPlayer)
        menu.trigger_commands("kick " .. plname)
        util.toast("Kicked " .. plname)
    end
end

-- function to kick everyone in the session (can trigger a network error to self)
function self.kickEveryone()
    for _, pid in ipairs(players.list(false, false, true)) do
        if pid ~= players.user() then
            menu.trigger_commands("kick " .. ObtainName(pid))
        end
    end
end

-- function to kick the host
function self.kickHost()
    for _, pid in ipairs(players.list(false, false, true)) do
        if pid == players.get_host() then
            local plname = ObtainName(pid)
            menu.trigger_commands("kick " .. plname)
            util.toast("Kicked the host: " .. plname)
        else
            util.toast("It seems like you or a friend is the host! " .. shrugFace)
        end
    end
end

-- function to all flagged modders
function self.kickModders()
    for _, pid in ipairs(players.list(false, false, true)) do
        if players.is_marked_as_modder(pid) then
            menu.trigger_commands("kick " .. ObtainName(pid))
        end
    end
end

-- function to kick players with Russian or Chinese characters in chat
function kickRussianChineseChat()
    chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
        local player_name = ObtainName(sender)
        if IsFriend(sender) and sender ~= players.user() then
            if string.match(text, "[\u{4e00}-\u{9fa5}]") or string.match(text, "[\u{0400}-\u{04FF}]") then
                util.toast("Kicking " .. player_name .. " for using Russian or Chinese characters in chat")
                menu.trigger_commands("kick " .. player_name)
            end
        end
    end)
end

-- function to spawn a random vehicle
function self.spawnRandomVehicle()
    local vehicles = {
        "adder",
        "airbus",
        "airtug",
        "akuma",
        "alpha",
        "alphaz1",
        "ambulance",
        "annihilator",
        "apc",
        "ardent",
        "armytanker",
        "armytrailer",
        "armytrailer2",
        "asea",
        "asea2",
        "asterope",
        "autarch",
        "avarus",
        "avenger",
        "avenger2",
        "bagger",
        "baletrailer",
        "baller",
        "baller2",
        "baller3",
        "baller4",
        "baller5",
        "baller6",
        "banshee",
        "banshee2",
        "barracks",
        "barracks2",
        "barracks3",
        "barrage",
        "bati",
        "bati2",
        "benson",
        "besra",
        "bestiagts",
        "bf400",
        "bfinjection",
        "biff",
        "bifta",
        "bison",
        "bison2",
        "bison3",
        "bjxl",
        "blade",
        "blazer",
        "blazer2",
        "blazer3",
        "blazer4",
        "blazer5",
        "blimp",
        "blimp2",
        "blimp3",
        "blista",
        "blista2",
        "blista3",
        "bmx",
        "boattrailer",
        "bobcatxl",
        "bodhi2",
        "bombushka",
        "boxville",
        "boxville2",
        "boxville3",
        "boxville4",
        "boxville5",
        "brawler",
        "brickade",
        "brioso",
        "bruiser",
        "bruiser2",
        "bruiser3",
        "brutus",
        "brutus2",
        "brutus3",
        "btype",
        "btype2",
        "btype3",
        "buccaneer",
        "buccaneer2",
        "buffalo",
        "buffalo2",
        "buffalo3",
        "bulldozer",
        "bullet",
        "burrito",
        "burrito2",
        "burrito3",
        "burrito4",
        "burrito5",
        "bus",
        "cablecar",
        "caddy",
        "caddy2",
        "caddy3",
        "camper",
        "caracara",
        "caracara2",
        "carbonizzare",
        "carbonrs",
        "casco",
        "cavalcade",
        "cavalcade2",
        "cheburek",
        "cheetah",
        "cheetah2",
        "chernobog",
        "chimera",
        "chino",
        "chino2",
        "cliffhanger",
        "clique",
        "coach",
        "cog55",
        "cog552",
        "cogcabrio",
        "cognoscenti",
        "cognoscenti2",
        "comet2",
        "comet3",
        "comet4",
        "comet5",
        "contender",
        "coquette",
        "coquette2",
        "coquette3",
        "crusader",
        "cuban800",
        "cutter",
        "cyclone",
        "daemon",
        "daemon2",
        "deathbike",
        "deathbike2",
        "deathbike3",
        "defiler",
        "deluxo",
        "deveste",
        "deviant",
        "diablous",
        "diablous2",
        "dilettante",
        "dilettante2",
        "dinghy",
        "dinghy2",
        "dinghy3",
        "dloader",
        "docktrailer",
        "docktug",
        "dodo",
        "dominator",
        "dominator2",
        "dominator3",
        "dominator4",
        "dominator5",
        "dominator6",
        "double",
        "drafter"
        -- keine Lust mehr zu schreiben
    }
    menu.trigger_commands("spawn " .. vehicles[math.random(#vehicles)])

end

-- function to explode players in blacklisted vehicles
function self.vehicleCheck()
    -- Tabelle, um zu verfolgen, welche Spieler bereits eine Nachricht erhalten haben
    local notifiedPlayers = {}

    if vehicleCheckEnabled then
        local vehhashlist = {
            "oppressor2",
            "oppressor",
            "deluxo",
            "scramjet",
            "vigilante",
            "toreador",
            "strikeforce",
            "minitank"
        }

        -- Tick handler für regelmäßige Überprüfungen
        util.create_tick_handler(function()
            if vehicleCheckEnabled then
                for _, pid in ipairs(players.list(false, false, true)) do -- 1:self, 2:friends, 3:others
                    local model = players.get_vehicle_model(pid)
                    local inBlacklistedVehicle = false

                    for _, vehhash in ipairs(vehhashlist) do
                        if model == util.joaat(vehhash) then
                            inBlacklistedVehicle = true

                            -- Explosion auslösen
                            local pos = players.get_position(pid)
                            ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, false, true, 0.0)
                            util.toast(ObtainName(pid) .. " is in a " .. vehhash .. "! KaBoom!")

                            -- Globale Chat-Benachrichtigung senden
                            if globalChatNotifications and not notifiedPlayers[pid] then
                                chat.send_message("Attention! " .. ObtainName(pid) .. " is in a " .. vehhash .. "!\nKaBoom!", false, true, true) -- 1:teamchat 2:Local History 3:Networwked
                                notifiedPlayers[pid] = true -- Markiere den Spieler als benachrichtigt
                            end
                            break
                        end
                    end

                    -- Entferne den Spieler aus der Benachrichtigungsliste, wenn er nicht mehr in einem blacklisted Fahrzeug ist
                    if not inBlacklistedVehicle then
                        notifiedPlayers[pid] = nil
                    end
                end
            end
            util.yield(1000) -- Warte 1 Sekunde vor der nächsten Überprüfung
        end)
    end
end

-- function to Kick beggars
function self.antiBeggar()
    local blacklistedPhrases = {
        "give me money",
        "drop money",
        "money drop",
        "moneydrop",
        "moneybag",
        "money bag",
        "moneybag drop",
        "money bag drop",
        "moneybagdrop",
        "moneyrain",
        "money rain",
        "moneyrain drop",
        "money rain drop",
        "moneyraindrop",
        "gimme money",
        "gimme cash",
        "gimme moni",
        "can i have money",
        "can i have cash",
        "can i have moni",
        "can i get money",
        "can i get cash",
        "can i get moni",
        "can i get a money drop",
        "can i get a cash drop",
        "can i get a moni drop",
        "can you drop money",
        "can you drop cash",
        "can you drop moni",
        "can you drop me money",
        "can you drop me cash",
        "can you drop me moni",
        "drop me money",
        "drop me cash",
        "drop me moni",
        "drop me a money drop",
        "drop me a cash drop",
        "drop me a moni drop",
        "drop me a moneybag",
        "drop me a money bag",
        "drop me a moneybag drop",
        "drop me a money bag drop",
        "drop me a moneybagdrop"
    }

    local kickedPlayers = {}

    -- Loop durch alle Spieler, die nicht Freund oder Sie selbst sind
    for _, pid in ipairs(players.list(false, false, true)) do
        local player_name = ObtainName(pid)

        chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
            -- Überprüfe nur Nachrichten von dem Spieler, der aktuell in der Schleife ist
            if sender == pid and not kickedPlayers[pid] then
                for _, phrase in ipairs(blacklistedPhrases) do
                    if string.match(text:lower(), phrase:lower()) then
                        chat.send_message("Attention! " .. player_name .. " is begging for money!\n say goodbye!", true, true, true)
                        util.toast("Kicking " .. player_name .. " for begging")
                        menu.trigger_commands("kick " .. player_name)
                        kickedPlayers[pid] = true -- Markiere den Spieler als gekickt
                        break
                    end
                end
            end
        end)
    end
end

return self
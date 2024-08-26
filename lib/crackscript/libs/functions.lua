-- xQueenyx => rewriting the functions and moving it to one file for a better overview ;)
local self = {}
require("crackscript.libs.crackessentials")
function self.checkBarcodeName()
    if antiBarcodeEnabled and players.get_host() == players.user() then
        -- xQueenyx => rewriting this function here as name is not working as second param
        for _, pid in ipairs(players.list(false, false, true)) do
            local name = ObtainName(pid)
            if string.match(name, "l") or string.match(name, "I") or string.match(name, "1") or string.match(name, "0") then
                util.toast("Kicking " .. name .. " for barcode name")
                menu.trigger_commands("kick " .. name)
            end
        end
    end
end

function self.antiIPShare()
    chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
        local player_name = ObtainName(sender)
        if not IsFriend(sender) and not sender == players.user() then
            if string.match(text, "%d+%.%d+%.%d+%.%d+") then
                util.toast("Kicking " .. player_name .. " for sharing an IP address in chat")
                menu.trigger_commands("kick " .. player_name)
            end
        end
    end)
end

function self.copyVehicle()
    local player_id = players.user() 
    local player_name = players.get_name(player_id)  
    menu.trigger_commands("copyvehicle " .. player_name)
end

function self.crashRandom()
    local playersList = players.list(false, false, true)
    local randomPlayer = playersList[math.random(#playersList)]
    if randomPlayer ~= players.user() then
        local plname = ObtainName(randomPlayer)
        menu.trigger_commands("crash " .. plname)
        util.toast("Crashed " .. plname)
    end
end

function self.kickRandom()
    local playersList = players.list(false, false, true)
    local randomPlayer = playersList[math.random(#playersList)]
    if randomPlayer ~= players.user() then
        local plname = ObtainName(randomPlayer)
        menu.trigger_commands("kick " .. plname)
        util.toast("Kicked " .. plname)
    end
end


function self.kickEveryone()
    for _, pid in ipairs(players.list(false, false, true)) do
        if pid ~= players.user() then
            menu.trigger_commands("kick " .. ObtainName(pid))
        end
    end
end

function self.kickHost()
    for _, pid in ipairs(players.list(false, false, true)) do
        if pid == players.get_host() then
            local plname = ObtainName(pid)
            menu.trigger_commands("kick " .. plname)
            util.toast("Kicked the host: " .. pplname)
        else
            util.toast("It seems like you or a friend is the host! " .. shrugFace)
        end
    end
end

function self.kickModders()
    for _, pid in ipairs(players.list(false, false, true)) do
        if players.is_marked_as_modder(pid) then
            menu.trigger_commands("kick " .. ObtainName(pid))
        end
    end
end

function self.kickRussianChineseChat()
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

function self.vehicleCheck()
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

        -- Tick handler for regular checks
        util.create_tick_handler(function()
            if vehicleCheckEnabled then
                for _, pid in ipairs(players.list(true, false, false)) do -- Check for players
                    local model = players.get_vehicle_model(pid)
                    for _, vehhash in ipairs(vehhashlist) do
                        if model == util.joaat(vehhash) then
                            -- Get the position and cause an explosion on them
                            local pos = players.get_position(pid)
                            ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, false, true, 0.0)
                            util.toast(ObtainName(pid) .. " was in a " .. vehhash .. " - Boom!")
                        end
                    end
                end
            end
            util.yield(10) -- Wait 5 seconds before the next check
        end)
    end
end

return self
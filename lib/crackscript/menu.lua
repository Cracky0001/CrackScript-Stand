-- Lua Scripts/lib/crackscript/menu.lua

util.require_natives("2944a", "g")

-- Hauptmenü definieren
local rootMenu = menu.my_root()
menu.divider(rootMenu, "CrackScript v" .. versionNum)
local HostOptions = menu.list(rootMenu, "Host Options", {"cshostoptions"}, "Configure the host options")
local Blocks = menu.list(HostOptions, "Blocks", {"csblocks"}, "Configure the block settings")
local ToxicOptions = menu.list(rootMenu, "Toxic Options", {"cstoxicoptions"}, "Configure the toxic options")
local AntiGriefing = menu.list(rootMenu, "Anti-Griefing", {"csantigriefing"}, "Configure the anti-griefing settings")
local VehicleBlacklist = menu.list(AntiGriefing, "Vehicle Blacklist", {"csvehicleblacklist"}, "Configure the vehicle blacklist")
local ChatOptions = menu.list(rootMenu, "Chat Options", {"cschatoptions"}, "Configure the chat options")
local VehicleOptions = menu.list(rootMenu, "Vehicle Options", {"csvehicleoptions"}, "Configure the vehicle options")
local Credits = menu.list(rootMenu, "Credits", {"cscredits"}, "Show the credits")

-- Globale Variablen deklarieren
antiBarcodeEnabled = false
vehicleCheckEnabled = false
kickRussianChineseEnabled = false
detect_ip_toggle = false

shrugFace = "(ツ)"

-- Logik-Dateien einbinden
require("lib.crackscript.logic.anti_barcode_logic")
require("lib.crackscript.logic.vehicle_blacklist_logic")
require("lib.crackscript.logic.crash_random_logic")
require("lib.crackscript.logic.kick_everyone_logic")
require("lib.crackscript.logic.kick_random_logic")
require("lib.crackscript.logic.kick_modders_logic")
require("lib.crackscript.logic.kick_host_logic")
require("lib.crackscript.logic.kick_russian_chinese_logic")
require("lib.crackscript.logic.anti_ip_share_logic")
require("lib.crackscript.logic.spawn_random_vehicle")

-- Anti-Barcode (Host Options)
menu.divider(Blocks, "Blocks")
menu.toggle(Blocks, "Anti-Barcode", {"csantibarcode"}, "Will kick players with a barcode name", function(state)
    antiBarcodeEnabled = state
    if state then
        util.toast("Anti-Barcode Enabled")
        checkBarcodeName()
    else
        util.toast("Anti-Barcode Disabled")
    end
end)

-- Vehicle Blacklist (Anti-Griefing)
menu.toggle(VehicleBlacklist, "Anti Griefing Vehicles", {"csantigriefingvehicles"}, "Will explode the vehicle if a player is in it", function(state)
    vehicleCheckEnabled = state
    if state then
        util.toast("Vehicle Check Enabled")
        vehicleCheck()
    else
        util.toast("Vehicle Check Disabled")
    end
end)

menu.divider(VehicleBlacklist, "Blacklisted Vehicles")
menu.readonly(VehicleBlacklist, "Oppressor MK I")
menu.readonly(VehicleBlacklist, "Oppressor MK II")
menu.readonly(VehicleBlacklist, "Deluxo")
menu.readonly(VehicleBlacklist, "Scramjet")
menu.readonly(VehicleBlacklist, "Vigilante")
menu.readonly(VehicleBlacklist, "Toreador")
menu.readonly(VehicleBlacklist, "Strikeforce")
menu.readonly(VehicleBlacklist, "Minitank")

-- Toxic Options
menu.divider(ToxicOptions, "Crashes")
menu.action(ToxicOptions, "Crash Random", {"cscrashrandom"}, "Crash a random player in the session", function()
    crashRandom()
end)

menu.divider(ToxicOptions, "Kicks")
menu.action(ToxicOptions, "Kick Everyone", {"cskickall"}, "Kick everyone in the session", function()
    kickEveryone()
end)

menu.action(ToxicOptions, "Kick Random", {"cskickrandom"}, "Kick a random player in the session", function()
    kickRandom()
end)

menu.action(ToxicOptions, "Kick Modders", {"cskickmodders"}, "Kick all modders in the session", function()
    kickModders()
end)

menu.action(ToxicOptions, "Kick Sessionhost", {"cskickhost"}, "Kick the session host", function()
    kickHost()
end)

-- Chat Options
menu.toggle(ChatOptions, "Kick Russian/Chinese Chat", {"kickruschi"}, "Detect Russian or Chinese characters in chat and kick the player", function(state)
    kickRussianChineseEnabled = state
    if state then
        kickRussianChineseChat()
    end
end)

menu.toggle(ChatOptions, "Anti IP Share", {"csantiipshare"}, "Detect IP addresses in chat and spam chat until the IP is gone and will kick the player", function(state)
    detect_ip_toggle = state
    if state then
        antiIPShare()
    end
end)


-- Vehicle Options
menu.divider(VehicleOptions, "Vehicle Options")
menu.action(VehicleOptions, "Spawn random vehicle", {"csspawnrandomvehicle"}, "Spawn a random vehicle", function()
    spawnRandomVehicle()
end)

-- Credits
menu.divider(Credits, "Credits")
menu.hyperlink(Credits, "CrackScript on Github!", "https://github.com/Cracky0001/CrackScript-Stand", "Open the Github page of CrackScript")
-- Developers (Credits)
menu.divider(Credits, "Developers")
-- Cracky
menu.action(Credits, "Cracky", {}, "Leading developer", function()
    util.toast("Cracky - Leading developer" .. shrugFace)
end)
-- xQueenyx
menu.action(Credits, "xQueenyx", {}, "Without you, everything wouldn't work the way it does right now.\nTHANK YOU FOR YOUR GENEROUS SUPPORT <3", function()
    util.toast("xQueenyx - Developer" .. shrugFace)
end)

-- Helpers (Credits)
menu.divider(Credits, "Helpers")
-- 1delay.
menu.action(Credits, "1delay.", {}, "Thank you for your support in testing and error detection", function()
    util.toast("1delay. - Helper" .. shrugFace)
end)
-- 44-69-6d-61
menu.action(Credits, "44-69-6d-61", {}, "Thank you for your great ideas", function()
    util.toast("44-69-6d-61 - Helper" .. shrugFace)
end)
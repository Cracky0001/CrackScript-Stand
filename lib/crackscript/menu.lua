-- Lua Scripts/lib/crackscript/menu.lua

util.require_natives("2944a", "g")

local functions = require("crackscript.libs.functions")

-- DebugPrint für Debugging
local function DebugPrint(msg)
    util.log("[CrackScript] " .. msg)
end

local rootMenu = menu.my_root()
menu.divider(rootMenu, "CrackScript v" .. versionNum)
DebugPrint("Main menu created")

local HostOptions = menu.list(rootMenu, "Host Options", {"cshostoptions"}, "Configure the host options")
DebugPrint("HostOptions menu created")

local Blocks = menu.list(HostOptions, "Blocks", {"csblocks"}, "Configure the block settings")
DebugPrint("Blocks menu created")

local ToxicOptions = menu.list(rootMenu, "Toxic Options", {"cstoxicoptions"}, "Configure the toxic options")
DebugPrint("ToxicOptions menu created")

local AntiGriefing = menu.list(rootMenu, "Anti-Griefing", {"csantigriefing"}, "Configure the anti-griefing settings")
DebugPrint("AntiGriefing menu created")

local VehicleBlacklist = menu.list(AntiGriefing, "Vehicle Blacklist", {"csvehicleblacklist"}, "Configure the vehicle blacklist")
DebugPrint("VehicleBlacklist menu created")

local ChatOptions = menu.list(rootMenu, "Chat Options", {"cschatoptions"}, "Configure the chat options")
DebugPrint("ChatOptions menu created")

local VehicleOptions = menu.list(rootMenu, "Vehicle Options", {"csvehicleoptions"}, "Configure the vehicle options")
DebugPrint("VehicleOptions menu created")

local miscOptions = menu.list(rootMenu, "Miscellaneous", {"csmiscellaneous"}, "Configure miscellaneous options")
DebugPrint("Miscellaneous menu created")

local Credits = menu.list(rootMenu, "Credits", {"cscredits"}, "Show the credits")
DebugPrint("Credits menu created")

-- Globale Variablen deklarieren
antiBarcodeEnabled = false
vehicleCheckEnabled = false
kickRussianChineseEnabled = false
detect_ip_toggle = false

shrugFace = "(ツ)" -- Shruggi

-- Anti-Barcode (Host Options)
menu.divider(Blocks, "Blocks")
menu.toggle_loop(Blocks, "Anti-Barcode", {"csantibarcode"}, "Will kick players with a barcode name", function() 
    functions.checkBarcodeName()
end, function ()
    util.toast("Anti-Barcode Disabled")
end)

-- Vehicle Blacklist (Anti-Griefing)
menu.toggle(VehicleBlacklist, "Anti Griefing Vehicles", {"csantigriefingvehicles"}, "Will explode the vehicle if a player is in it", function(on)
    vehicleCheckEnabled = on
    if on then
        util.toast("Vehicle Check Enabled")
        functions.vehicleCheck()
    else
        util.toast("Vehicle Check Disabled")
    end
end)

menu.toggle(VehicleBlacklist, "Global Chat Notifications", {"csglobalchatnotifications"}, "Will notify the whole session if a player is in a blacklisted vehicle", function(on)
    globalChatNotifications = on
    if on then
        util.toast("Global Chat Notifications Enabled")
    else
        util.toast("Global Chat Notifications Disabled")
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
    functions.crashRandom()
end)

menu.divider(ToxicOptions, "Kicks")
menu.action(ToxicOptions, "Kick Everyone", {"cskickall"}, "Kick everyone in the session", function()
    functions.kickEveryone()
end)

menu.action(ToxicOptions, "Kick Random", {"cskickrandom"}, "Kick a random player in the session", function()
    functions.kickRandom()
end)

menu.action(ToxicOptions, "Kick Modders", {"cskickmodders"}, "Kick all modders in the session", function()
    functions.kickModders()
end)

menu.action(ToxicOptions, "Kick Sessionhost", {"cskickhost"}, "Kick the session host", function()
    functions.kickHost()
end)

-- Chat Options
menu.toggle(ChatOptions, "Kick Russian/Chinese Chat", {"kickruschi"}, "Detect Russian or Chinese characters in chat and kick the player", function(on)
    kickRussianChineseEnabled = on
    if on then
        util.toast("Kick Russian/Chinese Chat Enabled")
        functions.kickRussianChineseChat()
    else
        util.toast("Kick Russian/Chinese Chat Disabled")
    end
end)

menu.toggle(ChatOptions, "Anti IP Share", {"csantiipshare"}, "Detect IP addresses in chat and spam chat until the IP is gone and will kick the player", function(on)
    detect_ip_toggle = on
    if on then
        util.toast("Anti IP Share Enabled")
        functions.antiIPShare()
    else
        util.toast("Anti IP Share Disabled")
    end
end)

menu.toggle(ChatOptions, "Anti-Begging", {"antibeggar"}, "Detects begging messages in chat and kicks the player", function(on)
    antiBeggingEnabled = on
    if on then
        util.toast("Anti-Begging Enabled")
        functions.antiBeggar()
    else
        util.toast("Anti-Begging Disabled")
    end
end)

-- Vehicle Options
menu.action(VehicleOptions, "Spawn random vehicle", {"csspawnrandomvehicle"}, "Spawn a random vehicle", function()
    functions.spawnRandomVehicle()
end)

menu.action(VehicleOptions, "Copy Vehicle", {"cscopyvehicle"}, "Copy the vehicle you are currently in", function()
    functions.copyVehicle()
end)

-- Miscellaneous
menu.toggle_loop(miscOptions, "Lock-On and Shoot Target", {"cslockonshoot"}, "Continuously lock on and shoot at the current target", function()
    functions.lockOnAndShoot()
end, function()
    util.toast("Lock-On and Shoot Disabled")
end)

-- Credits
menu.hyperlink(Credits, "CrackScript on Github!", "https://github.com/Cracky0001/CrackScript-Stand", "Open the Github page of CrackScript")
menu.divider(Credits, "Developers")
menu.action(Credits, "Cracky", {}, "Leading developer", function()
    util.toast("Cracky - Leading developer" .. shrugFace)
end)
menu.action(Credits, "xQueenyx", {}, "Without you, everything wouldn't work the way it does right now.\nTHANK YOU FOR YOUR GENEROUS SUPPORT <3", function()
    util.toast("xQueenyx - Developer" .. shrugFace)
end)
menu.divider(Credits, "Helpers")
menu.action(Credits, "1delay.", {}, "Thank you for your support in testing and error detection", function()
    util.toast("1delay. - Helper" .. shrugFace)
end)
menu.action(Credits, "44-69-6d-61", {}, "Thank you for your great ideas", function()
    util.toast("44-69-6d-61 - Helper" .. shrugFace)
end)

DebugPrint("Menu loaded successfully")

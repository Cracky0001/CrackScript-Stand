-- Lua Scripts/CrackScript.lua

-- Global Version
versionNum = "0.1.7"

util.ensure_package_is_installed("lua/auto-updater")
local auto_updater = require("auto-updater")

auto_updater.run_auto_update({
    source_url="https://raw.githubusercontent.com/Cracky0001/CrackScript-Stand/main/CrackScript.lua",
    script_relpath=SCRIPT_RELPATH,
    project_url="https://github.com/Cracky0001/CrackScript-Stand",
    branch="main",
    dependencies={
        "lib/crackscript/menu.lua",
        "lib/crackscript/libs/crackessentials.lua",
        "lib/crackscript/libs/functions.lua"
    }
})
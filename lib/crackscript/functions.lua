-- lib/crackscript/functions.lua
local functions = {}

functions.create_directory = function(path)
    if not filesystem.exists(path) then
        filesystem.mkdir(path)
    end
end

functions.log_debug = function(message, debug_file_path)
    local file = io.open(debug_file_path, "a")
    if file then
        file:write("[" .. os.date("%X") .. "] " .. message .. "\n")
        file:flush()
        file:close()
    end
end

functions.generate_blacklist = function(blacklist_file_path)
    local russian_characters = {
        "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П",
        "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я",
        "а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п",
        "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я"
    }

    local chinese_characters = {}
    for codepoint = 0x4E00, 0x9FFF do
        table.insert(chinese_characters, utf8.char(codepoint))
    end

    local file = io.open(blacklist_file_path, "w")
    if file then
        for _, char in ipairs(russian_characters) do
            file:write(char .. "\n")
        end
        for _, char in ipairs(chinese_characters) do
            file:write(char .. "\n")
        end
        file:flush()
        file:close()
    end
end

functions.load_blacklist = function(blacklist_file_path)
    local blacklist = {}
    local file = io.open(blacklist_file_path, "r")
    if file then
        for line in file:lines() do
            table.insert(blacklist, line)
        end
        file:close()
    end
    return blacklist
end

functions.generate_default_chatbot = function(chatbot_file_path)
    local default_data = [[
    {
      "triggers": [
        {
          "keywords": ["hello", "hi", "hey"],
          "responses": [
            "What do you want, %s?",
            "Yeah, what, %s?",
            "Skip the greetings, let's go, %s."
          ]
        },
        {
          "keywords": ["mission", "job", "heist"],
          "responses": [
            "Can you even handle it, %s?",
            "About time you proved useful, %s.",
            "Think you can manage without messing up, %s?"
          ]
        },
        {
          "keywords": ["car", "vehicle", "ride"],
          "responses": [
            "Your junk car again, %s?",
            "Learn to drive first, %s.",
            "Nice, but I've got something better, %s."
          ]
        },
        {
          "keywords": ["weapon", "gun", "firearm"],
          "responses": [
            "Got anything decent, %s?",
            "Your weapons are trash, %s.",
            "Get something worth using first, %s."
          ]
        },
        {
          "keywords": ["money", "cash", "dollar"],
          "responses": [
            "Broke as usual, %s?",
            "Learn how to make money, %s.",
            "Always begging, huh, %s?"
          ]
        },
        {
          "keywords": ["level", "rank"],
          "responses": [
            "Still that low, %s?",
            "Took you that long, %s?",
            "Pathetic level, %s."
          ]
        },
        {
          "keywords": ["gang war", "war"],
          "responses": [
            "You won't last, %s.",
            "War? You, %s?",
            "Let me handle this, %s."
          ]
        },
        {
          "keywords": ["fly", "helicopter", "plane"],
          "responses": [
            "You can't fly, %s.",
            "I'll take the controls, you sit down, %s.",
            "Don't crash into a wall, %s."
          ]
        },
        {
          "keywords": ["quick", "help", "support"],
          "responses": [
            "In trouble again, %s?",
            "Can't do anything alone, can you, %s?",
            "Crying for help already, %s?"
          ]
        },
        {
          "keywords": ["gta online", "gta v", "los santos"],
          "responses": [
            "Learn to play, %s.",
            "Hope you don't screw it up, %s.",
            "GTA and you? Hilarious, %s."
          ]
        }
      ]
    }
    ]]
    local file = io.open(chatbot_file_path, "w")
    if file then
        file:write(default_data)
        file:flush()
        file:close()
    end
end

functions.load_chatbot = function(chatbot_file_path)
    local file = io.open(chatbot_file_path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        
        local chatbot_data = { triggers = {} }
        local triggers = content:match('"triggers"%s*:%s*%[(.-)%]%s*}')
        for trigger_block in triggers:gmatch('{(.-)}') do
            local trigger = { keywords = {}, responses = {} }
            for keyword in trigger_block:match('"keywords"%s*:%s*%[(.-)%]'):gmatch('"(.-)"') do
                table.insert(trigger.keywords, keyword)
            end
            for response in trigger_block:match('"responses"%s*:%s*%[(.-)%]'):gmatch('"(.-)"') do
                table.insert(trigger.responses, response)
            end
            table.insert(chatbot_data.triggers, trigger)
        end
        return chatbot_data
    end
    return {}
end

functions.contains_prohibited_characters = function(message, blacklist)
    for _, pattern in ipairs(blacklist) do
        if message:match(pattern) then
            return true
        end
    end
    return false
end

functions.contains_ip = function(message)
    local ip_pattern = "%d+%.%d+%.%d+%.%d+"
    return message:match(ip_pattern) ~= nil
end

functions.int_to_ip = function(ip)
    local b1 = bit.rshift(bit.band(ip, 0xFF000000), 24)
    local b2 = bit.rshift(bit.band(ip, 0x00FF0000), 16)
    local b3 = bit.rshift(bit.band(ip, 0x0000FF00), 8)
    local b4 = bit.band(ip, 0x000000FF)
    return string.format("%d.%d.%d.%d", b1, b2, b3, b4)
end

return functions

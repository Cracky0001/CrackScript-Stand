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
    local b1 = math.floor(ip / 16777216) % 256
    local b2 = math.floor(ip / 65536) % 256
    local b3 = math.floor(ip / 256) % 256
    local b4 = ip % 256
    return string.format("%d.%d.%d.%d", b1, b2, b3, b4)
end

functions.is_barcode_name = function(name)
    return name:match("^[Il1|]+$")
end

functions.should_exclude_player = function(pid, exclude_friends, exclude_org, exclude_crew, exclude_strangers)
    if exclude_friends and players.is_friend(pid) then
        return true
    end

    if exclude_org and players.get_boss(pid) == players.get_boss(players.user()) then
        return true
    end

    if exclude_crew and players.get_crew(pid) == players.get_crew(players.user()) then
        return true
    end

    if exclude_strangers and not players.is_friend(pid) and players.get_boss(pid) ~= players.get_boss(players.user()) and players.get_crew(pid) ~= players.get_crew(players.user()) then
        return true
    end

    return false
end

return functions

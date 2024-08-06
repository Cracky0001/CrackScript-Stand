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

functions.log_chat_to_file = function(file_path, player_name, message)
    local file = io.open(file_path, "a")
    if file then
        file:write("[" .. os.date("%d.%m.%Y %X") .. "] " .. player_name .. ": " .. message .. "\n")
        file:flush()
        file:close()
    end
end

return functions

function copyVehicle()
    local player_id = players.user() 
    local player_name = players.get_name(player_id)  
    menu.trigger_commands("copyvehicle " .. player_name)
end

-- ^Übergangsweise^
-- mache ich mit natives später
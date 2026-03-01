// obj_enemy_spawner - Create Event
maxEnemies = 5; // Limit enemies at once
spawnRateLow = 120; // Min frames between spawns (2 seconds)
spawnRateHigh = 300; // Max frames between spawns (5 seconds)
alarm[0] = 180; // Start spawning after 3 seconds

// Minimum distance from player to spawn
min_spawn_distance = 300; // 300 pixels from player
// obj_enemy_spawner - Alarm 0 Event
// Only spawn if player exists and we haven't reached max enemies
if (instance_exists(obj_enemy) && instance_number(obj_enemy) >= maxEnemies) {
    alarm[0] = irandom_range(spawnRateLow, spawnRateHigh);
    exit;
}

if (instance_exists(obj_player)) {
    var player_x = obj_player.x;
    var player_y = obj_player.y;
    
    var attempts = 0;
    var found_spot = false;
    
    // Try to find a valid spawn location
    while (!found_spot && attempts < 10) {
        var spawn_x = random(room_width);
        var spawn_y = random(room_height - 100); // Don't spawn too high
        
        // Check distance from player
        var dist = point_distance(spawn_x, spawn_y, player_x, player_y);
        
        // Check if spawn point is not in a wall
        if (dist > min_spawn_distance && place_empty(spawn_x, spawn_y)) {
            // Spawn enemy on "Instances" layer (default GameMaker layer)
            var new_enemy = instance_create_layer(spawn_x, spawn_y, "Instances", obj_enemy);
            
            // Initialize enemy
            with (new_enemy) {
                // Add any initial values here if needed
                hspd = 0;
                vspd = 0;
            }
            
            found_spot = true;
            show_debug_message("Enemy spawned at: " + string(spawn_x) + ", " + string(spawn_y));
        }
        attempts++;
    }
}

// Set next alarm
alarm[0] = irandom_range(spawnRateLow, spawnRateHigh);
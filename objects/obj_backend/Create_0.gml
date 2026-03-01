// Global XP and Level variables
globalvar level, xp, points;
level = 1;
xp = 0;
points = 0; // This will store XP collected during levels

// Tier system (1-5: Tier 1, 6-10: Tier 2, 11-15: Tier 3)
globalvar current_tier;
current_tier = 1;

// XP required for next level
globalvar xp_to_next_level;
xp_to_next_level = 100; // Base XP needed for level 2

// Level-up animation variables
globalvar level_up_timer;
level_up_timer = 0;

// Save/Load functions
function save_game() {
    var save_data = {
        level: global.level,
        tier: global.current_tier,
        xp: global.xp,
        xp_to_next_level: global.xp_to_next_level
    };
    
    var save_string = json_stringify(save_data);
    var buffer = buffer_create(string_length(save_string), buffer_fixed, 1);
    buffer_write(buffer, buffer_string, save_string);
    buffer_save_async(buffer, "savegame.dat", 0, buffer_get_size(buffer));
    buffer_delete(buffer);
    
    show_debug_message("Game saved!");
}

function load_game() {
    if (file_exists("savegame.dat")) {
        var buffer = buffer_load("savegame.dat");
        var save_string = buffer_read(buffer, buffer_string);
        buffer_delete(buffer);
        
        var save_data = json_parse(save_string);
        
        global.level = save_data.level;
        global.current_tier = save_data.tier;
        global.xp = save_data.xp;
        global.xp_to_next_level = save_data.xp_to_next_level;
        
        show_debug_message("Game loaded!");
        show_debug_message("Level: " + string(global.level) + ", Tier: " + string(global.current_tier));
    }
}
// Automatic level transition system
if (room == Room15) {
    // Boss level
    if (!instance_exists(obj_boss)) {
        // Boss defeated
        if (instance_exists(obj_player)) {
            // Show victory message after a delay
            if (!variable_instance_exists(id, "transition_timer")) {
                transition_timer = 0;
                show_message("Boss Defeated! Congratulations!");
            }
            transition_timer++;
            if (transition_timer > 60) { // Wait 1 second
                room_goto(rm_victory);
            }
        }
    }
} else {
    // Regular levels
    // Transition when all enemies defeated and reached goal
    var enemies_left = instance_number(obj_enemy) + instance_number(obj_boss);
    
    if (enemies_left <= 0) {
        // Check if player reached the end area
        if (place_meeting(obj_player.x, obj_player.y, obj_level_exit)) {
            // Alternative: if (obj_player.x > room_width - 100) {
            show_message("Level Complete!");
            room_goto_next();
        }
    }
}
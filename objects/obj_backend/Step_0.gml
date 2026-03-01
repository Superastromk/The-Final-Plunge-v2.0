// Check if player has enough XP to level up
if (xp >= xp_to_next_level) {
    // Level up!
    xp -= xp_to_next_level; // Remove the XP used to level up
    
    // Increase level
    level++;
    
    // Calculate new XP required for next level (exponential growth)
    // From the tutorial: level * 100 would be linear, let's make it exponential for better progression
    xp_to_next_level = round(100 * power(1.2, level - 1));
    
    // Check if we need to change tier
    var new_tier = ceil(level / 5); // 1-5: Tier 1, 6-10: Tier 2, 11-15: Tier 3
    
    if (new_tier != current_tier) {
        current_tier = new_tier;
        show_message("TIER UPGRADE! You are now Tier " + string(current_tier) + "!");
        
        // Update player stats and sprite
        if (instance_exists(obj_player)) {
            obj_player.update_tier_stats();
        }
    } else {
        show_message("Level Up! Level " + string(level));
    }
    
    // Start level up animation timer (2 seconds)
    global.level_up_timer = 120;
    
    // Save game after level up
    save_game();
}

// Decrease level up timer
if (level_up_timer > 0) {
    level_up_timer--;
}
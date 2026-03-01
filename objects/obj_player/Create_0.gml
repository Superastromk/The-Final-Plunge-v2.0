// Add this function to your create event
function set_player_sprite() {
    // Determine which tier sprite set to use based on current_tier
    var base_sprite = "";
    
    // Map your sprite names here - adjust these to match your actual sprite names
    switch(current_tier) {
        case 1:
            // Tier 1 sprites (Levels 1-5)
            base_sprite = "spr_tier1_"; // Adjust prefix as needed
            break;
        case 2:
            // Tier 2 sprites (Levels 6-10)
            base_sprite = "spr_tier2_"; // Adjust prefix as needed
            break;
        case 3:
            // Tier 3 sprites (Levels 11-15)
            base_sprite = "spr_tier3_"; // Adjust prefix as needed
            break;
    }
    
    // Return the full sprite name based on current state
    // Your sprite names should follow pattern like: spr_tier1_idle, spr_tier1_walk, etc.
    switch(player_state) {
        case "idle":
            return asset_get_index(base_sprite + "idle");
        case "walk":
            return asset_get_index(base_sprite + "walk");
        case "jump":
            return asset_get_index(base_sprite + "jump");
        case "attack":
            return asset_get_index(base_sprite + "attack");
        default:
            return asset_get_index(base_sprite + "idle"); // Default to idle
    }
}

// In your create event, after your existing code, add:
// Store sprite names for easier management (optional but helpful)
// Example sprite naming convention:
// spr_tier1_idle, spr_tier1_walk, spr_tier1_jump, spr_tier1_attack
// spr_tier2_idle, spr_tier2_walk, spr_tier2_jump, spr_tier2_attack
// spr_tier3_idle, spr_tier3_walk, spr_tier3_jump, spr_tier3_attack

// Set initial sprite
sprite_index = set_player_sprite();
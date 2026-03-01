// ===== ANIMATION AND SPRITE MANAGEMENT =====

// Set sprite based on player state and tier
var new_sprite = set_player_sprite();

// Only change sprite if it's different (optimization from [stackoverflow.com](https://stackoverflow.com/questions/79495419/sprite-not-updating-correctly-in-gms2))
if (sprite_index != new_sprite) {
    sprite_index = new_sprite;
    // Reset animation when changing states
    image_index = 0;
}

// Handle animation speed and frame control based on state
switch(player_state) {
    case "walk":
        image_speed = 0.5; // Play walk animation at normal speed
        break;
        
    case "jump":
        image_speed = 0; // Freeze jump animation
        
        // Set specific frames based on vertical velocity
        // Use two frames: 0 for going up, 1 for going down
        if (vspd < 0) {
            image_index = 0; // Frame 0: jumping up
        } else {
            image_index = 1; // Frame 1: falling down
        }
        break;
        
    case "idle":
        image_speed = 0; // Freeze idle animation
        image_index = 0; // Keep on first frame
        break;
        
    case "attack":
        image_speed = 1; // Play attack animation at normal speed
        // Attack animation will play through its frames
        // When attack finishes, state will change back automatically
        break;
}

// Update facing direction
image_xscale = facing;

// ===== HURT/INVINCIBILITY STATE =====
if (invincible > 0) {
    invincible--;
    
    // Flash effect when hurt
    if (invincible mod 10 < 5) {
        image_alpha = 0.5;
    } else {
        image_alpha = 1;
    }
    
    // Force hurt animation if not attacking
    if (invincible > 0 && !attack_active) {
        var hurt_sprite = asset_get_index("spr_tier" + string(current_tier) + "_hurt");
        if (hurt_sprite != -1) { // Check if hurt sprite exists
            sprite_index = hurt_sprite;
            image_speed = 1;
        }
    }
} else {
    image_alpha = 1;
}

// ===== STATE TRANSITION LOGIC =====
// Update state based on conditions (after sprite setting)

// If we're not attacking, update state based on movement and ground
if (!attack_active) {
    if (!on_ground) {
        player_state = "jump";
    } else if (hspd != 0) {
        player_state = "walk";
    } else {
        player_state = "idle";
    }
}

// Attack animation completion check
if (attack_active) {
    // Check if attack animation has finished
    // This depends on how many frames your attack animation has
    // Example: if attack has 4 frames, when image_index >= 4, it's done
    if (image_index >= image_number - 1) { // When last frame of attack is reached
        attack_active = false;
        // State will be updated next frame based on conditions
    }
}
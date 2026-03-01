// obj_player - Create Event (FIXED)
// =================================

// === Player Stats ===
max_health = 100;
current_health = 100;
attack_power = 10;
defense = 5;
move_speed = 4;
jump_power = 12;
facing = 1; // 1 = right, -1 = left

// === Leveling System ===
xp = 0;
current_level = 1;
current_tier = 1; // 1-5: Tier 1, 6-10: Tier 2, 11-15: Tier 3

// === Physics ===
grav = 0.8;
hspd = 0;
vspd = 0;
on_ground = false;

// === Jump Control (Mario 64 Style) ===
jump_held = false;
jump_timer = 0;
coyote_time = 5; // Frames after leaving ground you can still jump
coyote_timer = 0;
jump_buffer = 5; // Frames to buffer jump input
jump_buffer_timer = 0;
max_air_jumps = 0; // Set to 1 for double jump, 0 for no double jump

// === Animation States ===
player_state = "idle"; // idle, walk, jump, fall, attack, hurt
image_speed = 1;
image_index = 0;

// === Combat System ===
invincible = 0;
attack_cooldown = 0;
attack_active = false;
attack_duration = 15; // Frames for attack animation
attack_timer = 0; // Timer for attack duration

// === Collectibles ===
has_sword = false;
has_armor = false;
sword_level = 1;
armor_level = 1;

// === Global Variable Initialization ===
// Ensure global variables exist
if (!variable_global_exists("current_tier")) {
    global.current_tier = 1;
}
if (!variable_global_exists("xp")) {
    global.xp = 0;
}

// === Tier Update Function ===
function update_tier_stats() {
    switch (global.current_tier) {
        case 1:
            max_health = 100;
            attack_power = 10;
            defense = 5;
            move_speed = 4;
            jump_power = 12;
            break;
        case 2:
            max_health = 150;
            attack_power = 15;
            defense = 8;
            move_speed = 5;
            jump_power = 14;
            break;
        case 3:
            max_health = 200;
            attack_power = 20;
            defense = 12;
            move_speed = 6;
            jump_power = 16;
            break;
    }
    // Heal to full when tier changes
    current_health = max_health;
    update_sprite();
}

// === Sprite Update Function ===
function update_sprite() {
    // Verify sprite naming convention
    // Expected: spr_tier1_idle, spr_tier1_walk, spr_tier1_jump, spr_tier1_attack, spr_tier1_hurt
    //          spr_tier2_idle, spr_tier2_walk, etc.
    
    var sprite_name = "";
    
    switch (current_tier) {
        case 1:
            sprite_name = "spr_tier1_";
            break;
        case 2:
            sprite_name = "spr_tier2_";
            break;
        case 3:
            sprite_name = "spr_tier3_";
            break;
    }
    
    switch (player_state) {
        case "idle":
            sprite_name += "idle";
            break;
        case "walk":
            sprite_name += "walk";
            break;
        case "jump":
            sprite_name += "jump";
            break;
        case "fall":
            sprite_name += "jump"; // Use jump sprite for falling too
            break;
        case "attack":
            sprite_name += "attack";
            break;
        case "hurt":
            sprite_name += "hurt";
            break;
    }
    
    // Check if sprite exists before using it
    var new_sprite = asset_get_index(sprite_name);
    if (new_sprite != -1) {
        sprite_index = new_sprite;
    } else {
        // Fallback: use a default sprite if named sprite doesn't exist
        sprite_index = asset_get_index("spr_player");
    }
    
    // Set image speed based on state
    switch (player_state) {
        case "walk":
            image_speed = 0.5; // Play walk animation at half speed
            break;
        case "idle":
            image_speed = 0;
            image_index = 0; // Freeze on first frame
            break;
        case "jump":
        case "fall":
        case "attack":
        case "hurt":
            image_speed = 0; // Freeze jump/fall/attack animations
            break;
    }
}

// === Initialize ===
// Call tier stats update
update_tier_stats();

// Set initial sprite
update_sprite();
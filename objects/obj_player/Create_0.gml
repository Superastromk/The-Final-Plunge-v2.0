// Player Stats
max_health = 100;
current_health = 100;
attack_power = 10;
defense = 5;
move_speed = 4;
jump_power = 12;
facing = 1; // 1 = right, -1 = left

// Leveling/Tier System
xp = 0;
current_level = 1;
current_tier = 1;

// Physics
grav = 0.8;
hspd = 0;
vspd = 0;
on_ground = false;

// Jump Mechanics
jump_held = false;
jump_timer = 0;
coyote_time = 5;
coyote_timer = 0;
jump_buffer = 5;
jump_buffer_timer = 0;
max_air_jumps = 0;

// Animation Management
player_state = "idle";
image_speed = 1;
image_index = 0;

// Combat System
invincible = 0;
attack_cooldown = 0;
attack_active = false;
attack_duration = 15;
attack_timer = 0;

// Collectibles
has_sword = false;
has_armor = false;
sword_level = 1;
armor_level = 1;

// Global Variables Check
if (!variable_global_exists("current_tier")) {
    global.current_tier = 1;
}
if (!variable_global_exists("xp")) {
    global.xp = 0;
}

// Functions
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
    current_health = max_health;
    update_sprite();
}

function update_sprite() {
    var sprite_name = "";
    switch (current_tier) {
        case 1: sprite_name = "spr_tier1_"; break;
        case 2: sprite_name = "spr_tier2_"; break;
        case 3: sprite_name = "spr_tier3_"; break;
    }
    
    switch (player_state) {
        case "idle": sprite_name += "idle"; break;
        case "walk": sprite_name += "walk"; break;
        case "jump": sprite_name += "jump"; break;
        case "fall": sprite_name += "jump"; break;
        case "attack": sprite_name += "attack"; break;
        case "hurt": sprite_name += "hurt"; break;
    }

    var new_sprite = asset_get_index(sprite_name);
    if (new_sprite != -1) {
        sprite_index = new_sprite;
    } else {
        sprite_index = asset_get_index("spr_player");
    }

    switch (player_state) {
        case "walk": image_speed = 0.5; break;
        case "idle": case "jump": case "fall": case "attack": case "hurt":
            image_speed = 0; 
            image_index = 0;
            break;
    }
}

update_tier_stats();
update_sprite();
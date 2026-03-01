// obj_player - Step Event (COMPLETE FIXED VERSION)
// Input Setup
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));
var key_up_held = keyboard_check(vk_up) || keyboard_check(vk_space) || keyboard_check(ord("W"));
var key_attack = keyboard_check_pressed(vk_control);

// Invincibility
if (invincible > 0) {
    invincible--;
    if (invincible == 0) {
        if (player_state == "hurt") {
            if (on_ground) {
                player_state = "idle";
            } else {
                player_state = "fall";
            }
            update_sprite();
        }
    }
}

// Attack
if (key_attack && attack_cooldown <= 0 && !attack_active) {
    attack_active = true;
    attack_cooldown = 30;
    attack_duration = 15;
    player_state = "attack";
    update_sprite();
}

// Attack duration
if (attack_active) {
    attack_duration--;
    if (attack_duration <= 0) {
        attack_active = false;
        if (on_ground) {
            player_state = "idle";
        } else {
            player_state = "fall";
        }
        update_sprite();
    }
}

// Skip movement if attacking
if (attack_active) {
    vspd += grav;
    
    // Simple vertical collision
    if (place_meeting(x, y + vspd, obj_wall)) {
        while (!place_meeting(x, y + sign(vspd), obj_wall)) {
            y += sign(vspd);
        }
        if (vspd > 0) {
            on_ground = true;
            player_state = "idle";
            update_sprite();
        }
        vspd = 0;
    } else {
        y += vspd;
        on_ground = false;
    }
    
    // Horizontal movement during attack (slower)
    if (key_right) {
        facing = 1;
        hspd = move_speed * 0.5;
    } else if (key_left) {
        facing = -1;
        hspd = -move_speed * 0.5;
    } else {
        hspd = 0;
    }
    
    // Horizontal collision
    if (place_meeting(x + hspd, y, obj_wall)) {
        while (!place_meeting(x + sign(hspd), y, obj_wall)) {
            x += sign(hspd);
        }
        hspd = 0;
    }
    x += hspd;
    
    image_xscale = facing;
    exit;
}

// Hurt state
if (invincible > 0 && invincible > 10) {
    if (player_state != "hurt") {
        player_state = "hurt";
        update_sprite();
    }
    
    // Knockback
    if (invincible > 15) {
        if (facing > 0) {
            hspd = -2;
        } else {
            hspd = 2;
        }
    }
    
    // Physics
    vspd += grav;
    
    // Collision
    if (place_meeting(x, y + vspd, obj_wall)) {
        while (!place_meeting(x, y + sign(vspd), obj_wall)) {
            y += sign(vspd);
        }
        if (vspd > 0) {
            on_ground = true;
        }
        vspd = 0;
    } else {
        y += vspd;
        on_ground = false;
    }
    
    if (place_meeting(x + hspd, y, obj_wall)) {
        while (!place_meeting(x + sign(hspd), y, obj_wall)) {
            x += sign(hspd);
        }
        hspd = 0;
    }
    x += hspd;
    
    image_xscale = facing;
    exit;
}

// ===== MOVEMENT & PHYSICS =====
var move_h = (key_right - key_left);

if (move_h != 0) {
    hspd = lerp(hspd, move_h * move_speed, 0.2);
    facing = move_h;
    
    if (on_ground && player_state != "walk") {
        player_state = "walk";
        update_sprite();
    }
} else {
    hspd = lerp(hspd, 0, 0.3);
    
    if (on_ground && player_state == "walk") {
        player_state = "idle";
        update_sprite();
    }
}

// ===== JUMP LOGIC (Mario 64 Style) =====
// Coyote time
if (on_ground) {
    coyote_timer = coyote_time;
} else {
    coyote_timer--;
}

// Jump buffer
if (key_up) {
    jump_buffer_timer = jump_buffer;
} else {
    jump_buffer_timer--;
}

// Check if can jump
var can_jump = (coyote_timer > 0 && key_up) || (jump_buffer_timer > 0 && on_ground);

if (can_jump) {
    vspd = -jump_power;
    on_ground = false;
    jump_timer = 0;
    jump_held = true;
    
    coyote_timer = 0;
    jump_buffer_timer = 0;
    
    player_state = "jump";
    update_sprite();
}

// Variable jump height
if (jump_held && vspd < 0) {
    jump_timer++;
    
    if (!key_up_held || jump_timer > 15) {
        vspd *= 0.5;
        jump_held = false;
    }
}

// Gravity
if (!on_ground) {
    vspd += grav;
    
    if (vspd < 0 && player_state != "jump" && player_state != "attack") {
        player_state = "jump";
        update_sprite();
    } else if (vspd > 0 && player_state != "fall" && player_state != "attack") {
        player_state = "fall";
        update_sprite();
    }
}

// ===== COLLISION =====
// Horizontal
if (place_meeting(x + hspd, y, obj_wall)) {
    while (!place_meeting(x + sign(hspd), y, obj_wall)) {
        x += sign(hspd);
    }
    hspd = 0;
} else {
    x += hspd;
}

// Vertical
if (place_meeting(x, y + vspd, obj_wall)) {
    while (!place_meeting(x, y + sign(vspd), obj_wall)) {
        y += sign(vspd);
    }
    
    if (vspd > 0) {
        on_ground = true;
        coyote_timer = coyote_time;
        
        if (player_state != "hurt" && player_state != "attack") {
            if (hspd != 0) {
                player_state = "walk";
            } else {
                player_state = "idle";
            }
            update_sprite();
        }
    } else {
        on_ground = false;
    }
    
    vspd = 0;
} else {
    y += vspd;
    on_ground = false;
}

image_xscale = facing;

// ===== XP COLLECTION =====
var xp_orb = instance_place(x, y, obj_xp_orb);
if (xp_orb != noone) {
    global.xp += xp_orb.xp_amount;
    xp += xp_orb.xp_amount;
    
    // Visual feedback
    show_debug_message("Collected " + string(xp_orb.xp_amount) + " XP!");
    
    // Create pickup effect
    instance_create_layer(x, y, "Effects", obj_xp_pickup_effect);
    
    instance_destroy(xp_orb);
}

// ===== TIER UPDATES =====
if (global.current_tier != current_tier) {
    current_tier = global.current_tier;
    update_tier_stats();
}
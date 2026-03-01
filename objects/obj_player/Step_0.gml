// obj_player - Step Event (COMPLETELY FIXED AND ORGANIZED)

// ===== INPUT SETUP =====
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));
var key_up_held = keyboard_check(vk_up) || keyboard_check(vk_space) || keyboard_check(ord("W"));
var key_attack = keyboard_check_pressed(vk_control);

// ===== INVINCIBILITY & HURT STATE =====
if (invincible > 0) {
    invincible--;
    
    // Apply hurt state logic
    if (invincible > 10 && player_state != "hurt") {
        player_state = "hurt";
        update_sprite();
        
        // Knockback (only for first few frames of hurt)
        if (invincible > 15) {
            if (facing > 0) {
                hspd = -2;
            } else {
                hspd = 2;
            }
        }
    }
    
    // When invincibility ends
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

// ===== ATTACK SYSTEM =====
if (key_attack && attack_cooldown <= 0 && !attack_active) {
    attack_active = true;
    attack_cooldown = 30;
    attack_duration = 15;
    player_state = "attack";
    update_sprite();
    
    // Create attack hitbox and check for enemies
    var attack_x = x + (facing * 30); // 30 pixels in front of player
    var attack_y = y;
    
    // Check for enemies in attack range
    var enemies = ds_list_create();
    collision_circle_list(attack_x, attack_y, 32, obj_enemy, false, true, enemies, false);
    collision_circle_list(attack_x, attack_y, 32, obj_boss, false, true, enemies, false);
    
    for (var i = 0; i < ds_list_size(enemies); i++) {
        var enemy = enemies[| i];
        // Apply damage
        enemy.current_health -= attack_power;
        
        // Knockback
        enemy.hspd = facing * 4;
        enemy.vspd = -3;
        
        // Check if enemy dies
        if (enemy.current_health <= 0) {
            // Give XP
            xp += 25;
            global.xp += 25;
            
            // Spawn XP orbs (optional)
            instance_create_layer(enemy.x, enemy.y, "Items", obj_xp_orb);
            
            instance_destroy(enemy);
        }
    }
    ds_list_destroy(enemies);
}

// Decrease attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

// ===== ATTACK DURATION =====
if (attack_active) {
    attack_duration--;
    
    // End attack
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

// ===== MOVE EXITS =====
// Skip rest of movement if attacking or in hurt state (but still apply gravity)
if (attack_active) {
    // Apply gravity
    vspd += grav;
    
    // Simple collision during attack
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
    
    // Update sprite and flip
    image_xscale = facing;
    exit; // Skip the rest of the step event
}

// ===== NORMAL MOVEMENT =====
// Only process normal movement if not attacking or in hurt state
if (invincible <= 10) {
    // Horizontal movement
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
    // Coyote time - allows jumping shortly after leaving ground
    if (on_ground) {
        coyote_timer = coyote_time;
    } else {
        coyote_timer--;
    }
    
    // Jump buffer - allows pressing jump slightly before landing
    if (key_up) {
        jump_buffer_timer = jump_buffer;
    } else {
        jump_buffer_timer--;
    }
    
    // Check if we can jump
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
    
    // Variable jump height - release early to jump lower
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
    
    // ===== COLLISION DETECTION =====
    // Horizontal collision
    if (place_meeting(x + hspd, y, obj_wall)) {
        // Move to the edge of the wall (fixes sliding issue)
        while (!place_meeting(x + sign(hspd), y, obj_wall)) {
            x += sign(hspd);
        }
        hspd = 0; // Stop movement when hitting wall
    } else {
        x += hspd;
    }
    
    // Vertical collision
    if (place_meeting(x, y + vspd, obj_wall)) {
        // Move to the edge of the wall
        while (!place_meeting(x, y + sign(vspd), obj_wall)) {
            y += sign(vspd);
        }
        
        if (vspd > 0) {
            // Just landed
            on_ground = true;
            coyote_timer = coyote_time;
            
            // Update state if not hurt or attacking
            if (player_state != "hurt" && player_state != "attack") {
                if (hspd != 0) {
                    player_state = "walk";
                } else {
                    player_state = "idle";
                }
                update_sprite();
            }
        } else {
            // Hit ceiling
            on_ground = false;
        }
        vspd = 0;
    } else {
        y += vspd;
        on_ground = false;
    }
    
    // Prevent getting stuck in walls (emergency fix)
    if (place_meeting(x, y, obj_wall)) {
        // Try to move out of wall
        if (place_meeting(x + 2, y, obj_wall) && !place_meeting(x - 2, y, obj_wall)) {
            x -= 2;
        } else if (place_meeting(x - 2, y, obj_wall) && !place_meeting(x + 2, y, obj_wall)) {
            x += 2;
        } else if (place_meeting(x, y + 2, obj_wall)) {
            y -= 2;
        } else if (place_meeting(x, y - 2, obj_wall)) {
            y += 2;
        }
    }
    
    // Update sprite flip
    image_xscale = facing;
}

// ===== XP COLLECTION =====
var xp_orb = instance_place(x, y, obj_xp_orb);
if (xp_orb != noone) {
    global.xp += xp_orb.xp_amount;
    xp += xp_orb.xp_amount;
    
    // Create pickup effect
    instance_create_layer(x, y, "Effects", obj_xp_pickup_effect);
    
    instance_destroy(xp_orb);
}

// ===== TIER UPDATES =====
if (global.current_tier != current_tier) {
    current_tier = global.current_tier;
    update_tier_stats();
}
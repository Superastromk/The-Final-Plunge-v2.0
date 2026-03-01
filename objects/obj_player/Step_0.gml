// Input
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));
var key_up_held = keyboard_check(vk_up) || keyboard_check(vk_space) || keyboard_check(ord("W"));
var key_attack = keyboard_check_pressed(vk_control);

// Invincibility / Hurt
if (invincible > 0) {
    invincible--;
    if (invincible > 10 && player_state != "hurt") {
        player_state = "hurt";
        update_sprite();
        var kb_dir = (facing > 0 ? -1 : 1);
        hspd = lerp(hspd, kb_dir * 2, 0.2);
    }
    if (invincible == 0 && player_state == "hurt") {
        if (on_ground) {
            player_state = "idle";
        } else {
            player_state = "fall";
        }
        update_sprite();
    }
    vspd += grav;
    y += vspd;
    if (place_meeting(x, y + vspd, obj_wall)) {
        while (!place_meeting(x, y + sign(vspd), obj_wall)) {
            y += sign(vspd);
        }
        vspd = 0;
        on_ground = true;
    }
    image_xscale = facing;
    exit;
}

// Attack
if (key_attack && attack_cooldown <= 0 && !attack_active) {
    attack_active = true;
    attack_cooldown = 30;
    attack_duration = 15;
    player_state = "attack";
    update_sprite();
    // Add actual attack logic here if needed...
}

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

if (attack_cooldown > 0) attack_cooldown -= 1;

// Resume normal movement only if not in hurt/attack state
if (!attack_active && invincible <= 10) {
    // Horizontal Movement
    var move_h = key_right - key_left;
    if (move_h != 0) {
        hspd = lerp(hspd, move_h * move_speed, 0.2);
        facing = move_h;
        if (on_ground && player_state == "idle") {
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

    // Gravity
    if (!on_ground) {
        vspd += grav;
        if (vspd < 0 && player_state != "jump" && player_state != "attack" && player_state != "hurt") {
            player_state = "jump";
            update_sprite();
        } else if (vspd >= 0 && player_state == "jump") {
            player_state = "fall";
            update_sprite();
        }
    }

    // Jump Logic (Variable Height + Coyote Time + Buffer)
    if (on_ground) coyote_timer = coyote_time;
    else coyote_timer -= 1;

    if (key_up) jump_buffer_timer = jump_buffer;
    else jump_buffer_timer -= 1;

    var can_jump = (coyote_timer > 0 && key_up) || (jump_buffer_timer > 0 && on_ground);

    if (can_jump) {
        vspd = -jump_power;
        on_ground = false;
        jump_timer = 0;
        jump_held = true;
        coyote_timer = 0;
        jump_buffer_timer = 0;
        if (player_state != "attack" && player_state != "hurt") {
            player_state = "jump";
            update_sprite();
        }
    }

    if (jump_held && vspd < 0) {
        jump_timer++;
        if (!key_up_held || jump_timer > 15) {
            vspd *= 0.5;
            jump_held = false;
        }
    }

    // Horizontal Collision
    if (place_meeting(x + hspd, y, obj_wall)) {
        while (!place_meeting(x + sign(hspd), y, obj_wall)) {
            x += sign(hspd);
        }
        hspd = 0;
    } else {
        x += hspd;
    }

    // Vertical Collision
    if (place_meeting(x, y + vspd, obj_wall)) {
        while (!place_meeting(x, y + sign(vspd), obj_wall)) {
            y += sign(vspd);
        }

        if (vspd > 0) {
            on_ground = true;
            if (player_state != "hurt" && player_state != "attack") {
                if (abs(hspd) > 0.1) player_state = "walk";
                else player_state = "idle";
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

    // Fix Stuck Inside Walls
    if (place_meeting(x, y, obj_wall)) {
        if (place_meeting(x + 2, y, obj_wall)) x -= 2;
        else if (place_meeting(x - 2, y, obj_wall)) x += 2;
        else if (place_meeting(x, y + 2, obj_wall)) y -= 2;
        else if (place_meeting(x, y - 2, obj_wall)) y += 2;
    }

    image_xscale = facing;
}

// XP Collection
var xp_orb = instance_place(x, y, obj_xp_orb);
if (xp_orb != noone) {
    global.xp += xp_orb.xp_amount;
    xp += xp_orb.xp_amount;
    instance_destroy(xp_orb);
}

// Tier Updates
if (global.current_tier != current_tier) {
    current_tier = global.current_tier;
    update_tier_stats();
}
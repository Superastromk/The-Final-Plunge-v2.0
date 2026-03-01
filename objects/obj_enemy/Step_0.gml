// obj_enemy - Step Event (FIXED - Proper platformer movement)
// Apply gravity
vspd += grav;

// ===== ENEMY BEHAVIOR =====
if (instance_exists(obj_player)) {
    var dist = point_distance(x, y, obj_player.x, obj_player.y);
    
    // If player is close enough, chase them
    if (dist < playerDetectionRadius) {
        // Move toward player
        var dir = point_direction(x, y, obj_player.x, obj_player.y);
        
        // Only move if not too close (maintain minimum distance)
        if (dist > min_distance_from_player) {
            hspd = lengthdir_x(move_speed, dir);
            enemy_state = "walk";
        } else {
            // Stop moving if too close
            hspd = lerp(hspd, 0, 0.1);
            enemy_state = "idle";
        }
    } else {
        // Patrol when player is far away
        patrol_movement();
    }
} else {
    // Patrol when no player exists
    patrol_movement();
}

// ===== PATROL MOVEMENT FUNCTION =====
function patrol_movement() {
    idle_timer--;
    
    if (idle_timer <= 0) {
        if (enemy_state == "idle") {
            // Start moving
            enemy_state = "walk";
            patrol_direction = choose(-1, 1); // Choose new direction
            hspd = patrol_direction * move_speed;
            idle_timer = 60 + irandom(60); // 1-2 seconds of walking
        } else {
            // Stop moving
            enemy_state = "idle";
            hspd = 0;
            idle_timer = 60 + irandom(60); // 1-2 seconds of idle
        }
    }
}

// ===== HORIZONTAL COLLISION =====
if (place_meeting(x + hspd, y, obj_wall)) {
    // Check if we can move a little bit
    while (!place_meeting(x + sign(hspd), y, obj_wall)) {
        x += sign(hspd);
    }
    // Hit wall, change patrol direction
    if (enemy_state == "walk") {
        patrol_direction *= -1;
        hspd = patrol_direction * move_speed;
    } else {
        hspd = 0;
    }
} else {
    x += hspd;
}

// ===== VERTICAL COLLISION =====
if (place_meeting(x, y + vspd, obj_wall)) {
    while (!place_meeting(x, y + sign(vspd), obj_wall)) {
        y += sign(vspd);
    }
    if (vspd > 0) {
        on_ground = true;
        vspd = 0;
    } else {
        // Hit ceiling
        vspd = 0;
    }
} else {
    y += vspd;
    on_ground = false;
}

// ===== UPDATE SPRITE BASED ON STATE =====
// This assumes you have sprites named: spr_enemy_idle, spr_enemy_walk, etc.
// You'll need to create these sprites for each tier if needed
var sprite_name = "spr_enemy_" + enemy_state;
var new_sprite = asset_get_index(sprite_name);
if (new_sprite != -1) {
    sprite_index = new_sprite;
}

// Flip sprite based on direction
if (enemy_state == "walk") {
    image_xscale = sign(hspd);
}
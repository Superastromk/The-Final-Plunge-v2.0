// obj_xp_orb - Step Event

// Bobbing animation (floating up and down)
bobbing += 0.1;
y = ystart + sin(bobbing) * 3;

// Glow pulse effect
glow_timer += 0.1;

// Check for collision with player
if (place_meeting(x, y, obj_player)) {
    var player = instance_place(x, y, obj_player);
    if (player != noone) {
        // Add XP to global system
        global.xp += xp_amount;
        
        // Also add to player's local XP
        player.xp += xp_amount;
        
        // Show debug message
        show_debug_message("Collected " + string(xp_amount) + " XP!");
        
        // Destroy this orb
        instance_destroy();
    }
}
//draw player
invincible = 27;
if (invincible mod 10>5){
	draw_self();
}

//health bar

draw_healthbar(x-20, y-30, x+20, y-25, health, c_black, c_red, c_green, 0 ,true, true);
// 1. Change this line to the new function name
gpu_set_blendmode(bm_add); 

// 2. Draw your player/orb effect
if (invincible mod 10 > 5) {
    draw_self();
}

// 3. Reset the blend mode back to normal (VERY IMPORTANT)
gpu_set_blendmode(bm_normal); 

// 4. Draw the health bar
draw_healthbar(x-20, y-30, x+20, y-25, health, c_black, c_red, c_green, 0, true, true);
// obj_player - Draw Event (temporary debug)
draw_self(); // This draws your sprite

// Add debug drawing
draw_set_color(c_red);
draw_rectangle(x-20, y-20, x+20, y+20, false); // Draw a red box around player
draw_set_color(c_white);
draw_text(x, y-50, "PLAYER"); // Label
draw_text(x, y-65, "HP: " + string(current_health));
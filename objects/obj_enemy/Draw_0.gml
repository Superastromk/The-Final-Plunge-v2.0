// obj_enemy - Draw Event
// Draw the enemy
draw_self();

// Optional: Draw detection radius (for debugging)
if (debug_mode) {
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_circle(x, y, playerDetectionRadius, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Draw health bar above enemy
var bar_width = 30;
var bar_height = 4;
var bar_x = x - bar_width/2;
var bar_y = y - 20;

// Background
draw_set_color(c_black);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

// Health fill
draw_set_color(c_red);
var health_percent = current_health / max_health;
draw_rectangle(bar_x, bar_y, bar_x + (bar_width * health_percent), bar_y + bar_height, false);

draw_set_color(c_white);
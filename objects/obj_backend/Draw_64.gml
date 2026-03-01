// 1. Fixed Division by Zero/Missing Variable check
var xp_needed = max(1, global.xp_to_next_level); 

// 2. Fixed Draw Alpha reset (Best practice to start with 1)
draw_set_alpha(1); 
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Level and Tier
draw_set_color(c_white);
draw_text(20, 20, "Level: " + string(global.level));
draw_text(20, 40, "Tier: " + string(global.current_tier));

// XP Bar
var bar_x = 20;
var bar_y = 60;
var bar_width = 200;
var bar_height = 20;

// 3. Calculation fix: Clamp the fill percentage so it doesn't go off-screen
var fill_percent = clamp(global.xp / xp_needed, 0, 1);
var fill_width = fill_percent * bar_width;

// Draw XP bar background
draw_set_color(c_dkgray);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

// Draw XP bar fill
// 4. Logic Fix: Added 'default' case so the bar isn't invisible if Tier is 0 or 4+
switch(global.current_tier) {
    case 1:  draw_set_color(c_lime);   break;
    case 2:  draw_set_color(c_yellow); break;
    case 3:  draw_set_color(c_red);    break;
    default: draw_set_color(c_white);  break; 
}

// 5. Visual Fix: Only draw fill if fill_width > 0 (prevents 1px artifacting)
if (fill_width > 0) {
    draw_rectangle(bar_x, bar_y, bar_x + fill_width, bar_y + bar_height, false);
}

// 6. Syntax/Logical Fix: Border must be 'outline' (true), otherwise it covers the fill
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true); 

// Draw XP text
draw_set_color(c_white);
// 7. Alignment Fix: Centering text vertically relative to the bar
draw_text(bar_x + bar_width + 10, bar_y + (bar_height/2) - (string_height("M")/2), string(global.xp) + " / " + string(global.xp_to_next_level));

// Use the global prefix consistently
if (global.level_up_timer > 0) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.8);
    draw_text(20, 100, "LEVEL UP!");
    draw_set_alpha(1);
}

draw_set_color(c_white);
// obj_xp_orb - Draw Event

// Calculate glow parameters
var glow_size = 1 + 0.2 * sin(glow_timer);
var glow_alpha = 0.3 + 0.2 * sin(glow_timer);

// Draw glow effect WITHOUT blend mode (to avoid error)
// Instead, just draw with alpha
draw_set_color(c_yellow);
draw_set_alpha(glow_alpha);
draw_circle(x, y, 16 * glow_size, false);
draw_set_alpha(1); // Reset alpha

// Draw the orb itself (NO ROTATION - set angle to 0)
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, 1);

// Optional: Add a small text showing XP value for testing
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_center);
draw_text(x, y-25, string(xp_amount));
draw_set_halign(fa_left);
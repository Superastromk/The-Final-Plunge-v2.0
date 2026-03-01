draw_self();

// Blink on hit
if (invincible mod 10 > 5) {
    draw_sprite_ext(sprite_index, -1, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

// Health bar (optional)
draw_healthbar(x - 20, y - 30, x + 20, y - 25, current_health, c_black, c_red, c_green, 0, true, true);
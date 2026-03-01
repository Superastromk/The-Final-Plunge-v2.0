// This helps you see what's happening
if (debug_mode) {
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    
    draw_text(10, 100, "Player State: " + player_state);
    draw_text(10, 120, "on_ground: " + string(on_ground));
    draw_text(10, 140, "vspd: " + string(vspd));
    draw_text(10, 160, "Tier: " + string(current_tier));
    draw_text(10, 180, "XP: " + string(xp));
    draw_text(10, 200, "Cooldown: " + string(attack_cooldown));
    draw_text(10, 220, "Invincible: " + string(invincible));
}
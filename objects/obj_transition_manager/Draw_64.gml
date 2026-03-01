// obj_transition_manager - Draw GUI Event
if (transitioning && fade_alpha > 0) {
    draw_set_colour(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
    draw_set_alpha(1);
}
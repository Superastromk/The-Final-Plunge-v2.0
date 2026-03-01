// obj_transition_manager - Step Event
if (transitioning) {
    if (fade_alpha < 1) {
        // Fade out
        fade_alpha += 0.05;
        if (fade_alpha >= 1) {
            // Switch room when fully faded
            if (target_room != -1) {
                room_goto(target_room);
            } else {
                room_goto_next();
            }
        }
    }
}

// Check for transition triggers (put in your main controller)
// This would be called when you want to transition
/*
if (should_transition) {
    transitioning = true;
    target_room = rm_victory; // or room_goto_next(), etc.
}
*/
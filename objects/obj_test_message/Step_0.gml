if (message_timer > 0) {
    message_timer--;
} else {
    // Show test message
    show_message("TEST XP SYSTEM!\n\nCollect the golden orbs to gain XP.\nYou will level up at 100 XP.\nPress SPACE to jump, CONTROL to attack (if you have sword).");
    instance_destroy();
}
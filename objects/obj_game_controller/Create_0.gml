// obj_game_controller - Create Event
// Make this object persistent across rooms
persistent = true;

// Store initial room for restarts
if (!variable_global_exists("room_title")) {
    global.room_title = rm_title;
}
if (!variable_global_exists("room_victory")) {
    global.room_victory = rm_victory;
}
if (!variable_global_exists("room_gameover")) {
    global.room_gameover = rm_gameover;
}
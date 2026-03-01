if (room == Room15) {
    //boss level! check if boss is dead
    if (!instance_exists(obj_boss)) {
        show_message("Congratulations! You escaped the abyss!")
        room_goto(rm_victory); // Go to your victory/ending room
    }
} else {
    //regular level - go to next room
    room_goto_next();
}
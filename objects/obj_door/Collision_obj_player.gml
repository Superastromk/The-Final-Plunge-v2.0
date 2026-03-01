if (room == Room5) {
	//boss level! check if boss is ded
	if (!instance_exists(obj_boss)) {
		show_message("Congratulations! You escaped the abyss!")
		room_goto(room_tittle);
	}
} else {
	//regular level - go to next room
	room_goto_next();
}
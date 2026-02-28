state_timer--;

switch(state) {
	case "idle":
		if (state_timer <= 0) {
			state_timer = 120;
			state = choose("move", "attack");
		}
	break;
	case "move":
		var dir = point_direction(x, y, obj_player.x, obj_player.y);
		hspd = lengthdir_x(move_speed, dir);
		vspd = lengthdir_y(move_speed/2, dir);
		
		if (point_distance(x,y, obj_player.x, obj_player.y) < 50){
			state = "attack";
			state_timer = 90;
}
break;
	case "attack":
		if(state_timer <=0) {
			state = "idle";
			state_timer = 60;
		}
		break;
}
if (health <=250 && phase =1){
	phase =2;
	move_speed =3;
	show_message("He's mad!");
}

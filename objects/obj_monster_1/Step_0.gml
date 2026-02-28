//simple bot ai
if (distance_to_object(obj_player) < detect_range) {
	var dir = point_direction(x,y,obj_player.x, obj_player.y);
	hspd = lengthdir_x(move_speed, dir);
} else {
	if (place_meeting(x+hspd, y, obj_wall)){
		hspd *=-1;
	}
}

//gravity
if (!place_meeting(x, y+1, obj_wall)){
	vspd +=grav;
}

//move
if (place_meeting(x +hspd, y, obj_wall)) {
    while (!place_meeting(x + sign(hspd),y, obj_wall)) {
        x += sign(hspd);
    }
    hspd = 0;
}
x += hspd;

if (place_meeting(x, y +vspd, obj_wall)) {
    while (!place_meeting(x, y +sign(vspd), obj_wall)) {
        y += sign(vspd);
    }
    vspd = 0;
} else {
    y += vspd;
}

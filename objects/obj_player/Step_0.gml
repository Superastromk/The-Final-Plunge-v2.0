//movement
var move = (keyboard_check(vk_right) - keyboard_check(vk_left));
gspd = move * move_speed;

//jumps
if (keyboard_check_pressed(vk_space) && on_ground) {
	vspd = -jump_power;
	on_ground = false;
}

//sword attack
if(has_sword && keyboard_check_pressed(vk_control) && attack_cooldown <=0){
	instance_create_layer(x + facing*32, y, "Instances", obj_attack);
	attack_cooldown = 30;
}

//gravity
if(!on_ground) vspd +=grav;

//collision horizontally
if (place_meeting(x+hspd, y, obj_wall)){
	while (!place_meeting(x, y +vspd, obj_wall)){
		y += sign(hspd)
	}
	hspd = 0;
}
x+=hspd; 

//collision vertically
if (place_meeting(x, y+vspd, obj_wall)){
	while(!place_meeting(x,y+sign(vspd), obj_wall)){
		y += vspd;
	}
	if (vspd > 0) on_ground = true;
	vspd = 0;
} else {
	y+= vspd;
	on_ground = false;
}

//face direction
if (hspd != 0) facing = sign(hspd);

//cooldown
if (attack_cooldown > 0) attack_cooldown--;
if (invincible > 0) invincible --;

//check if dead
if (health <=0){
	room_restart();
}

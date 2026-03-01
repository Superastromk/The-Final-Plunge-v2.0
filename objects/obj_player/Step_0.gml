//movement inputs
var move_input = (keyboard_check(vk_right) - keyboard_check(vk_left));
var is_on_floor = place_meeting(x,y+1, obj_wall);

if(move_input != 0){
	hspd = lerp(hspd, move_input*move_speed, 0.2);
	facing = sign(move_input);
	player_state = "walk";
} else {
	hspd = lerp(hspd, 0, 0.3);
	if(is_on_floor && !attack_active){
		player_state = "idle";
	}
}

if(keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))){
	if(is_on_floor) {
		vspd = -jump_power;
		air_jumps = max_air_jumps;
		player_state = "jump";
	
	}else if (air_jumps >0){
		vspd = -jump_power*0.8
		air_jumps--;
		player_state = "jump";
	}
}

if(!is_on_floor) {
	vspd +=grav;
	if(keyboard_check(vk_down) && vspd >0){
		vspd +=2;
	}
}

//attacks
if (has_sword && keyboard_check_pressed(vk_control) && attack_cooldown <= 0 && !attack_active){
	attack_active = true;
	attack_timer = attack_duration;
	attack_cooldown = 30;
	var attack_x = x + (facing * 40);
	var attack_y = y;
	var enemies = ds_list_create();
	collision_circle_list(attack_x, attack_y, 32, obj_enemy, false, true, enemies, false);
	for (var i=0; i<ds_list_size(enemies); i++){
		var enemy = enemies[| i];
		var damage_dealt = attack_power - enemy.defense;
		damage_Dealt = max(1, damage_dealt);
		enemy.current_health -= damage_dealt;
		
		enemy.hspd = facing*5;
		enemy.vspd = -3;
		
		if(enemy.current_health <=0) {
			xp += xp_reward_base * enemy.xp_multiplier;
			instance_destroy(enemy);
			check_level_up();
		}
	}
	ds_list_destroy(enemies);
}

//update attack timings
if(attack_active){
	attack_timer--;
	if(attack_timer <=0){
		attack_active = false;
	}
	player_state = "attack";
}

//collision detection
//horizontal rn
if (place_meeting(x+hspd, y, obj_wall)){
	while(!place_meeting(x+sign(hspd), y, obj_wall)){
		x+=sign(hspd);
		}
	hspd =0;
	}
x += hspd;

//vertical now
if (place_meeting(x,y+vspd,obj_wall)){
	while (!place_meeting(x, y+ sign(vspd), obj_wall)){
		y+=sign(vspd)
	}
	if (vspd>0){
		on_ground =true;
		air_jumps = max_air_jumps;
	}
	vspd = 0;
}else{
	y+=vspd;
	on_ground=false;
}

//animation and state management

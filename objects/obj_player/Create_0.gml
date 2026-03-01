//stats
max_health = 100;
current_health =100;
attack_power = 10;
defense =5;
has_sword = false;
has_armor = false;
move_speed = 4;
jump_power = 12;
facing = 1;
//FYI: 1 = EAST, -1 = WEST

//levels
current_level = -1;
current_tier = 1; //tier 1 = lvl1-5, tier 2 = lvl 6-10, tier 3 = lvl 11-15

//experience
xp =0 ;
xp_to_next_level = 100;
xp_reward_base =10;

//combat
attack_cooldown = 0;
invincible = 0;
attack_active = false;
attack_duration = 15;
attack_timer = 0;

//physics
grav=0.8;
hspd = 0;
vspd = 0;
on_ground = false;
air_jumps = 0;
max_air_jumps =1;

//animations
player_state = "idle";

//tiers
function update_tiers_stats(){
	switch (current_tier){
		case 1:
			max_health = 100;
			attack_power = 10;
			defense = 5;
			move_speed  =4;
			jump_power = 12;
			break;
		case 2:
			max_health = 150;
			attack_power = 15;
			defense =8;
			move_speed = 5;
			jump_power =14;
			break;
		case 3:
			max_health =20;
			attack_power = 20;
			defense =12;
			move_speed = 6;
			jump_power = 16;
			break;
	
	}
	current_health = min(current_health, max_health);
}
sprite_index = spr_player_tier1;
image_speed = 0.5;

function set_player_sprite(){
	var base


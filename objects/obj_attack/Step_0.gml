duration--;
if (duration <=0) instance_destroy();

//check if hit or not
var enemies = ds_list_create();
collision_circle_list(x,y,32,obj_enemy, false, true, enemies, false);
for (var i = 0; i<ds_list_size(enemies); i++){
	var enemy = enemies[| i];
	if(!ds_list_find_index(hit_list, enemy)){
		ds_list_add(hit_list, enemy);
		enemy.health -= damage;
		enemy.hspd = sign(enemy.x - x) * 4;
		enemy.vspd = -4;
	
	if(enemy.health <= 0) instance_destroy(enemy);
	}
}
ds_list_destroy(enemies);

// In the attack state in Step Event
if (attack_active) {
    attack_duration--;
    
    // Only check collision, don't move during attack
    if (attack_duration <= 0) {
        attack_active = false;
        if (on_ground) {
            player_state = "idle";
        } else {
            player_state = "fall";
        }
        update_sprite();
    }
    
    // Apply gravity during attack
    vspd += grav;
    
    // Keep checking collision during attack
    if (place_meeting(x, y + vspd, obj_wall)) {
        while (!place_meeting(x, y + sign(vspd), obj_wall)) {
            y += sign(vspd);
        }
        if (vspd > 0) {
            on_ground = true;
            player_state = "idle";
            update_sprite();
        }
        vspd = 0;
    } else {
        y += vspd;
        on_ground = false;
    }
    
    // Update sprite and flip
    image_xscale = facing;
    exit;
}
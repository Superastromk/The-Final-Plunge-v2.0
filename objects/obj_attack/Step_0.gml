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
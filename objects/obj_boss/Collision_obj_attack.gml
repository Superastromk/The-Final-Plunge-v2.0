health -= other_damage;
other.duration = 0; //destroy the attack

if (health <= 0) {
	instance_destroy();
	show_message("Boss defeated! You can now leave the ABYSS!");
	//spawn next door
	instance_create_layer(x, y, "Instance", obj_door)
}
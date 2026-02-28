if (object_index = obj_sword) {
	other.has_sword = true;
	show_message("You found a sword! Press CTRL to attack.");
} else if (object.index = obj_armor) {
	other.has_armor = true;
	show_message("You found armor! You'll now take less damage.");
}
instance_destroy();
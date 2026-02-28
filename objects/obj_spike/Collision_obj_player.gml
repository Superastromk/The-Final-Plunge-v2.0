if (other.invincible <= 0) {
	other.health -= 10;
	other.invincible = 60; // 1 second of god mode, op fr fr so sigma
	
	//Knockback
	other.vspd = -8;
	other.hspd = other.facing * -4;
}
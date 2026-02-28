//draw player
if (invincible mod 10>5){
	draw_self();
}

//health bar
draw_healthbar(x-20, y-30, x+20, y-25, health, c_black, c_red, c_green, 0 ,true, true);
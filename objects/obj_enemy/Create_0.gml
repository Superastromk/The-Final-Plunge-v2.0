// obj_enemy - Create Event (FIXED - No spawning code!)
// Basic stats
max_health = 20;
current_health = max_health;
attack_power = 5;
defense = 2;
move_speed = 2;
grav = 0.8;
hspd = 0;
vspd = 0;
on_ground = false;

// Behavior
playerDetectionRadius = 200; // How close player needs to be for enemy to notice
min_distance_from_player = 80; // Minimum distance to keep from player

// Movement
idle_timer = 0;
patrol_direction = choose(-1, 1); // Start moving left or right

// Animation states
enemy_state = "idle";
image_speed = 0.5;
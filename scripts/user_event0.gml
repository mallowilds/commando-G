// ITEM INIT
// Called whenever an item is added to Commando's inventory or needs to perform a stat update.


switch new_item_id {
    
    case 5: // Paul's Goat Hoof
    case 6: // Energy Drink
        update_horizontal_movement();
        break;
    
    case 13: // Soldier's Syringe
        update_attack_speed();
        break;
    
    case 14: // Mocha
        update_attack_speed();
        update_horizontal_movement();
        break;
    
    case 17: // Tough Times
        knockback_adj = knockback_adj_base - (0.1 * item_grid[17][IG_NUM_HELD]);
        break;
    
    case 21: // Hopoo Feather
        max_djumps = max_djumps_base + item_grid[21][IG_NUM_HELD];
        break;
        
    case 29: // Rusty Jetpack
        update_vertical_movement();
        break;
    
    case 38: // H3AD-5T V2
        update_vertical_movement();
        break;
    
}


#define update_attack_speed
    
    // Soldier's Syringe, Mocha
    attack_speed = 1
                 + (2 * item_grid[13][IG_NUM_HELD]) // Soldier's Syringe
                 + (1 * item_grid[14][IG_NUM_HELD]); // Mocha
    
    return;
    
#define update_horizontal_movement
    
    // Paul's Goat Hoof, Mocha
    move_speed = (1 * item_grid[5][IG_NUM_HELD]) // Paul's Goat Hoof
               + (0.5 * item_grid[14][IG_NUM_HELD]); // Mocha
    
    walk_anim_speed = walk_anim_speed_base + (0.01 * move_speed);
    dash_anim_speed = dash_anim_speed_base + (0.01 * move_speed) + (0.015 * item_grid[6][IG_NUM_HELD]); // energy drink
    
    walk_speed = walk_speed_base + (1 * move_speed);
    walk_accel = walk_accel_base + (0.08 * move_speed);
    dash_speed = dash_speed_base + (0.8 * move_speed) + (1 * item_grid[6][IG_NUM_HELD]); // energy drink
    initial_dash_speed = initial_dash_speed_base + (1 * move_speed) + (1.5 * item_grid[6][IG_NUM_HELD]); // energy drink
    
    max_jump_hsp = max_jump_hsp_base + (1 * move_speed);
    air_max_speed = air_max_speed_base + (0.5 * move_speed);
    
    return;

#define update_vertical_movement
    
    var jump_speed_add = clamp((1 * item_grid[29][IG_NUM_HELD]) + (4 * item_grid[38][IG_NUM_HELD]), 0, 5); // Rusty Jetpack, H3AD-5T V2
    jump_speed = jump_speed_base + jump_speed_add; 
    // short_hop_speed = base_short_hop_speed; // actually let's not
    djump_speed = djump_speed_base + (0.5 * item_grid[29][IG_NUM_HELD]); // Rusty Jetpack
    walljump_vsp = walljump_vsp_base + (1 * item_grid[29][IG_NUM_HELD]); // Rusty Jetpack
    
    max_fall = max_fall_base - (0.5 * item_grid[29][IG_NUM_HELD]); // Rusty Jetpack
    fast_fall = fast_fall_base + (6 * item_grid[38][IG_NUM_HELD]); // H3AD-5T V2
    gravity_speed = gravity_speed_base - (0.05 * (item_grid[29][IG_NUM_HELD] > 0)); // Rusty Jetpack
    
    return;
// ITEM INIT
// Called whenever an item is added to Commando's inventory or needs to perform a stat update.


switch new_item_id {
    
    case 5: // Paul's Goat Hoof
    case 6: // Energy Drink
    case 7: // Arcane Blades
        update_horizontal_movement();
        break;
    
    case 10: // Lens Maker's Glasses
    case 11: // Rusty Knife
    case 12: // Taser
        critical_active = 1;
        break;
    
    case 8: // Hermit Scarf
        dodge_duration_add = 2 * item_grid[8][IG_NUM_HELD];
        break;
    
    case 13: // Soldier's Syringe
        update_attack_speed();
        break;
    
    case 14: // Mocha
        update_attack_speed();
        update_horizontal_movement();
        break;
    
    case 16: // Gasoline
    case 18: // Kjaro's Band
        enable_ignition_tank();
        break;
    
    case 17: // Tough Times
        knockback_adj = knockback_adj_base - (0.1 * item_grid[17][IG_NUM_HELD]);
        break;
    
    case 21: // Hopoo Feather
        max_djumps = max_djumps_base + item_grid[21][IG_NUM_HELD];
        break;
    
    case 22: // Guardian Heart
        heart_barrier_max = 2 + 2 * item_grid[22][IG_NUM_HELD];
        break;
        
    case 24: // Harvester's Scythe
        critical_active = 1;
        break;
        
    case 26: // Predatory Instincts
        critical_active = 1;
        update_attack_speed();
        break;
    
    case 29: // Rusty Jetpack
        update_vertical_movement();
        break;
        
    case 32: // Fireman's Boots
        enable_ignition_tank();
        break;
    
    case 38: // H3AD-5T V2
        update_vertical_movement();
        break;
    
}


#define update_attack_speed
    
    attack_speed = 1
                 + (2 * item_grid[13][IG_NUM_HELD]) // Soldier's Syringe
                 + (item_grid[14][IG_NUM_HELD]) // Mocha
                 + ((instincts_timer > 0) ? (2 + item_grid[26][IG_NUM_HELD]) : 0); // Predatory Instincts
    
    return;
    
#define update_horizontal_movement
    
    move_speed = (1 * item_grid[5][IG_NUM_HELD]) // Paul's Goat Hoof
               + (get_player_damage(player) >= 100 ? 1.5 * item_grid[7][IG_NUM_HELD] : 0) // Arcane Blades
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
    
#define enable_ignition_tank
    if (item_grid[25][IG_RARITY] == RTY_VOID) {
        item_grid[@ 25][@ IG_RARITY] = RTY_UNCOMMON;
        var itp = item_grid[25][IG_TYPE]
        for (var i = 0; i < 3; i++) array_push(rnd_index_store[RTY_UNCOMMON][itp], 25);
        type_values[@ RTY_UNCOMMON][@ itp] = type_values[RTY_UNCOMMON][itp] + 3*type_weights[RTY_UNCOMMON][itp];
        uncommons_remaining += 3;
    }
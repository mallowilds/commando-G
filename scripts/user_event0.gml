// ITEM INIT
// Called whenever an item is added to Commando's inventory or needs to perform a stat update.

// Switch statement uses hard-coded IDs since RCF constants aren't real constants on dev builds.
switch new_item_id {
    
    case 1: // Warbanner
        update_horizontal_movement();
        update_attack_speed();
        break;
    
    case 5: // Paul's Goat Hoof
    case 6: // Energy Drink
    case 7: // Arcane Blades
        update_horizontal_movement();
        break;
    
    case 8: // Hermit Scarf
        dodge_duration_add = SCARF_FRAMES_BASE + SCARF_FRAMES_SCALE*item_grid[8][IG_NUM_HELD];
        break;
    
    case 10: // Lens Maker's Glasses
    case 11: // Tri-Tip Dagger
    case 12: // Taser
        critical_active = 1;
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
        knockback_adj = knockback_adj_base + TTIMES_KBADJ_SCALE*item_grid[17][IG_NUM_HELD];
        break;
    
    case 20: // Ukelele
        ustrong_index = (item_grid[20][IG_NUM_HELD] > 0) ? AT_USTRONG_2 : AT_USTRONG;
        break;
    
    case 21: // Hopoo Feather
        max_djumps = max_djumps_base + item_grid[21][IG_NUM_HELD];
        break;
    
    case 22: // Guardian Heart
        heart_barrier_max = HEART_BARRIER_BASE + HEART_BARRIER_SCALE*item_grid[22][IG_NUM_HELD];
        break;
    
    case 23: // Locked Jewel
        update_horizontal_movement();
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
        fireboots_lockout = 0;
        break;
    
    case 37: // Photon Jetpack
        pjetpack_fuel_max = PJETPACK_FUEL_MAX_BASE + PJETPACK_FUEL_MAX_SCALE*item_grid[37][IG_NUM_HELD];
        break;
    
    case 38: // H3AD-5T V2
        update_vertical_movement();
        break;
    
    case 39: // Hardlight Afterburner
        set_num_hitboxes(AT_FSPECIAL, 1);
        break;
    
    case 40: // Laser Scope
        // Manually disables the default crit hitboxes and enables the buffed ones.
        // Not sure there's a more elegant way to handle this efficiently, unfortunately
        // TODO: set up handling for deactivating the laser scope (for the sake of training mode)
        
        // DTilt
        set_num_hitboxes(AT_DTILT, 3);
        set_hitbox_value(AT_DTILT, 2, HG_WINDOW, 0);
        
        critical_active = 1;
        
        print_debug("scope'd!");
        
        break;
    
    case 42: // Aegis
        aegis_ratio = AEGIS_RATIO_BASE + AEGIS_RATIO_SCALE*item_grid[42][IG_NUM_HELD]
        break;
        
    case 50: // Energy Cell
        update_attack_speed();
        break;
    
    case noone: // Debug
        update_attack_speed();
        update_horizontal_movement();
        update_vertical_movement();
        critical_active = 1;
        break;
    
}


#define update_attack_speed
    
    attack_speed = 1
                 + ((commando_warbanner_strength > 0) ? (WARBANNER_ASPEED_BASE + WARBANNER_ASPEED_SCALE*commando_warbanner_strength) : 0) // Warbanner
                 + (SYRINGE_ASPEED_SCALE * item_grid[ITEM_SYRINGE][IG_NUM_HELD]) // Soldier's Syringe
                 + (MOCHA_ASPEED_SCALE * item_grid[ITEM_MOCHA][IG_NUM_HELD]) // Mocha
                 + ((instincts_timer > 0) ? (INSTINCTS_ASPEED_BASE + INSTINCTS_ASPEED_SCALE*item_grid[ITEM_INSTINCTS][IG_NUM_HELD]) : 0) // Predatory Instincts
                 + ((item_grid[ITEM_CELL][IG_NUM_HELD] > 0) ? floor(get_player_damage(player) / (CELL_THRESHOLD_BASE + CELL_THRESHOLD_SCALE*item_grid[ITEM_CELL][IG_NUM_HELD])) : 0); // Energy Cell
    
    return;
    
#define update_horizontal_movement
    
    move_speed = ((commando_warbanner_strength > 0) ? (WARBANNER_SPEED_BASE + WARBANNER_SPEED_SCALE*commando_warbanner_strength) : 0) // Warbanner
               + (HOOF_SPEED_SCALE * item_grid[ITEM_HOOF][IG_NUM_HELD]) // Paul's Goat Hoof
               + (get_player_damage(player) >= BLADES_THRESHOLD ? BLADES_SPEED_SCALE * item_grid[ITEM_BLADES][IG_NUM_HELD] : 0) // Arcane Blades
               + (MOCHA_SPEED_SCALE * item_grid[ITEM_MOCHA][IG_NUM_HELD]) // Mocha
               + ((jewel_barrier_timer > 0) ? JEWEL_SPEED_SCALE * item_grid[ITEM_JEWEL][IG_NUM_HELD] : 0) // Locked Jewel
    
    walk_anim_speed = walk_anim_speed_base + (MSPEED_WALK_ANIM_SCALE * move_speed);
    dash_anim_speed = dash_anim_speed_base + (MSPEED_DASH_ANIM_SCALE * move_speed) + (EDRINK_DASH_ANIM_SCALE * item_grid[ITEM_EDRINK][IG_NUM_HELD]);
    
    walk_speed = walk_speed_base + (MSPEED_WALK_SPEED_SCALE * move_speed);
    walk_accel = walk_accel_base + (MSPEED_WALK_ACCEL_SCALE * move_speed);
    dash_speed = dash_speed_base + (MSPEED_DASH_SPEED_SCALE * move_speed) + (EDRINK_DASH_SPEED_SCALE * item_grid[ITEM_EDRINK][IG_NUM_HELD]);
    initial_dash_speed = initial_dash_speed_base + (MSPEED_IDASH_SPEED_SCALE * move_speed) + (EDRINK_IDASH_SPEED_SCALE * item_grid[ITEM_EDRINK][IG_NUM_HELD]);
    moonwalk_accel = moonwalk_accel_base + (MSPEED_MOONWALK_ACCEL_SCALE * move_speed) + (EDRINK_MOONWALK_ACCEL_SCALE * item_grid[ITEM_EDRINK][IG_NUM_HELD]);
    
    max_jump_hsp = max_jump_hsp_base + (MSPEED_MAX_JUMP_HSP_SCALE * move_speed);
    air_max_speed = air_max_speed_base + (MSPEED_AIR_MAX_HSP_SCALE * move_speed);
    
    set_window_value(AT_FSPECIAL, 2, AG_WINDOW_HSPEED, FSPEC_GROUND_HSP_BASE + (FSPEC_GROUND_HSP_SCALE * move_speed));
    set_window_value(AT_FSPECIAL_AIR, 2, AG_WINDOW_HSPEED, FSPEC_AIR_HSP_BASE + (FSPEC_AIR_HSP_SCALE * move_speed));
    set_window_value(AT_FSPECIAL_AIR, 2, AG_WINDOW_VSPEED, FSPEC_AIR_VSP_BASE + (FSPEC_AIR_VSP_SCALE * move_speed));
    
    return;

#define update_vertical_movement
    
    jump_speed = jump_speed_base + clamp((RJETPACK_JUMP_SCALE * item_grid[ITEM_RJETPACK][IG_NUM_HELD]) + (HEADSET_JUMP_SCALE * item_grid[ITEM_HEADSET][IG_NUM_HELD]), 0, MAX_JUMP_MOD);
    // short_hop_speed = base_short_hop_speed; // actually let's not
    djump_speed = djump_speed_base + (RJETPACK_DJUMP_SCALE * item_grid[ITEM_RJETPACK][IG_NUM_HELD]); // Rusty Jetpack
    walljump_vsp = walljump_vsp_base + (RJETPACK_WJUMP_SCALE * item_grid[ITEM_RJETPACK][IG_NUM_HELD]); // Rusty Jetpack
    
    max_fall = max_fall_base + (RJETPACK_MAX_FALL_SCALE * item_grid[ITEM_RJETPACK][IG_NUM_HELD]); // Rusty Jetpack
    fast_fall = fast_fall_base + (HEADSET_FAST_FALL_SCALE * item_grid[ITEM_HEADSET][IG_NUM_HELD]); // H3AD-5T V2
    gravity_speed = gravity_speed_base - (RJETPACK_GRAV_SPEED_BASE * (item_grid[ITEM_RJETPACK][IG_NUM_HELD] > 0)); // Rusty Jetpack
    
    return;


#define enable_ignition_tank
    if (item_grid[ITEM_IGNITION][IG_RARITY] == RTY_VOID) {
        item_grid[@ ITEM_IGNITION][@ IG_RARITY] = RTY_UNCOMMON;
        var itp = item_grid[ITEM_IGNITION][IG_TYPE]
        for (var i = 0; i < 3; i++) array_push(rnd_index_store[RTY_UNCOMMON][itp], ITEM_IGNITION);
        type_values[@ RTY_UNCOMMON][@ itp] = type_values[RTY_UNCOMMON][itp] + 3*type_weights[RTY_UNCOMMON][itp];
        uncommons_remaining += 3;
    }
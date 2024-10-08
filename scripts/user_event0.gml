// ITEM INIT
// Called whenever an item is added to Commando's inventory or needs to perform a stat update.

var is_valid_index = (new_item_id == clamp(new_item_id, 0, array_length(item_grid)-1));

// If new_item_id does not represent a valid item, perform failsafe updates and exit
// (Alternatively, if new_item_id == noone, this can be used as a manual refresh for general stats)
if (!is_valid_index) {
    if (new_item_id != noone) {
        print_debug("user_event0 error: bad new_item_id value "  + string(new_item_id) + " for user_event(0) call. Using failsafe updates");
    }
    update_attack_speed();
    update_horizontal_movement();
    update_vertical_movement();
    assess_critical_active();
    exit;
}

// Crit items (assumes they're properly tagged)
if (item_grid[new_item_id][IG_TYPE] == ITP_CRITICAL || item_grid[new_item_id][IG_TYPE2] == ITP_CRITICAL) {
    if (item_grid[new_item_id][IG_NUM_HELD] > 0) critical_active = 1;
    else assess_critical_active();
}

// Switch statement uses hard-coded IDs since RCF constants aren't real constants on dev builds.
switch new_item_id {
    
    case 1: // Warbanner
        if (item_grid[1][IG_NUM_HELD] == 0) warbanner_obj = noone; // this will prompt the warbanner to clean itself up
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
    
    case 13: // Soldier's Syringe
        update_attack_speed();
        break;
    
    case 14: // Mocha
        update_attack_speed();
        update_horizontal_movement();
        break;
    
    case 17: // Tough Times
        knockback_adj = (item_grid[17][IG_NUM_HELD] > 0) ? power(TTIMES_KBADJ_EXP_SET, item_grid[17][IG_NUM_HELD]) : knockback_adj_base;
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
        
    case 25: // Ignition Tank
        if (!ignition_odds_applied) {
            buff_synergy_odds(ITP_BURNING, ITEM_IGNITION);
            ignition_odds_applied = true;
        }
        break;
    
    case 26: // Predatory Instincts
        update_attack_speed();
        break;
    
    case 29: // Rusty Jetpack
        update_vertical_movement();
        break;
        
    case 32: // Fireman's Boots
        fireboots_lockout = 0;
        break;
    
    case 37: // Photon Jetpack
        pjetpack_fuel_max = PJETPACK_FUEL_MAX_BASE + PJETPACK_FUEL_MAX_SCALE*item_grid[37][IG_NUM_HELD];
        break;
    
    case 38: // H3AD-5T V2
        update_vertical_movement();
        break;
    
    case 39: // Hardlight Afterburner
        set_num_hitboxes(AT_FSPECIAL, (item_grid[39][IG_NUM_HELD] > 0)); // enable fspec hitbox if afterburner is present
        break;
    
    case 40: // Laser Scope
        // Manually disables the default crit hitboxes and enables the buffed ones.
        // Not sure there's a more elegant way to handle this efficiently, unfortunately
        
        if (item_grid[40][IG_NUM_HELD] > 0) {
            // DTilt
            set_num_hitboxes(AT_DTILT, 3);
            set_hitbox_value(AT_DTILT, 2, HG_WINDOW, 0);
        }
        
        else { // TODO: ensure this works
            reset_num_hitboxes(AT_DTILT);
            reset_hitbox_value(AT_DTILT, 2, HG_WINDOW);
        }
        
        break;
    
    case 42: // Aegis
        aegis_ratio = AEGIS_RATIO_BASE + AEGIS_RATIO_SCALE*item_grid[42][IG_NUM_HELD]
        if (!aegis_odds_applied) {
            buff_synergy_odds(ITP_HEALING, ITEM_AEGIS);
            aegis_odds_applied = true;
        }
        break;
        
    case 43: // Brilliant Behemoth
        if (!behemoth_odds_applied) {
            buff_synergy_odds(ITP_EXPLOSIVE, ITEM_BEHEMOTH);
            behemoth_odds_applied = true;
        }
        break;
    
    case 49: // Filial Imprinting
        if (filial_num_spawned < item_grid[49][IG_NUM_HELD]) {
            var critter = instance_create(x-((54+6*filial_num_spawned)*spr_dir), y-60, "obj_article3");
            critter.state = 40;
            critter.spawn_num = item_grid[49][IG_NUM_HELD];
        }
        filial_num_spawned = item_grid[49][IG_NUM_HELD];
        update_attack_speed();
        update_horizontal_movement();
        break;
    
    case 50: // Energy Cell
        update_attack_speed();
        break;
    
}



#define assess_critical_active

    critical_active = false;
        var i = 0;
        while (!critical_active && i < array_length(item_grid)) {
            if (item_grid[i][IG_TYPE] == ITP_CRITICAL && item_grid[i][IG_NUM_HELD] > 0) critical_active = true;
            i++;
        }
    
    return;

#define update_attack_speed
    
    attack_speed = 1
                 + ((commando_warbanner_strength > 0) ? (WARBANNER_ASPEED_BASE + WARBANNER_ASPEED_SCALE*commando_warbanner_strength) : 0) // Warbanner
                 + (SYRINGE_ASPEED_SCALE * item_grid[ITEM_SYRINGE][IG_NUM_HELD]) // Soldier's Syringe
                 + (MOCHA_ASPEED_SCALE * item_grid[ITEM_MOCHA][IG_NUM_HELD]) // Mocha
                 + ((instincts_timer > 0) ? (INSTINCTS_ASPEED_BASE + INSTINCTS_ASPEED_SCALE*item_grid[ITEM_INSTINCTS][IG_NUM_HELD]) : 0) // Predatory Instincts
                 + ((filial_aspeed_timer > 0) ? FILIAL_ASPEED_STACKS : 0) // Filial Imprinting
                 + ((item_grid[ITEM_CELL][IG_NUM_HELD] > 0) ? floor(get_player_damage(player) / (CELL_THRESHOLD_BASE + CELL_THRESHOLD_SCALE*item_grid[ITEM_CELL][IG_NUM_HELD])) : 0); // Energy Cell
    
    return;
    
#define update_horizontal_movement
    
    move_speed = ((commando_warbanner_strength > 0) ? (WARBANNER_SPEED_BASE + WARBANNER_SPEED_SCALE*commando_warbanner_strength) : 0) // Warbanner
               + (HOOF_SPEED_SCALE * item_grid[ITEM_HOOF][IG_NUM_HELD]) // Paul's Goat Hoof
               + (get_player_damage(player) >= BLADES_THRESHOLD ? BLADES_SPEED_SCALE * item_grid[ITEM_BLADES][IG_NUM_HELD] : 0) // Arcane Blades
               + (MOCHA_SPEED_SCALE * item_grid[ITEM_MOCHA][IG_NUM_HELD]) // Mocha
               + ((jewel_barrier_timer > 0) ? JEWEL_SPEED_SCALE * item_grid[ITEM_JEWEL][IG_NUM_HELD] : 0) // Locked Jewel
               + ((filial_speed_timer > 0) ? FILIAL_SPEED_STACKS : 0) // Filial Imprinting
    
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
    
#define set_taunt_indices
    utaunt_index = (item_grid[ITEM_UKELELE][IG_NUM_HELD] > 0) ? AT_TAUNT_2 : AT_TAUNT;
    ntaunt_index = (item_grid[ITEM_WARBANNER][IG_NUM_HELD] > 0) ? AT_EXTRA_1 : utaunt_index;
    // dtaunt is constant and set in init.gml

// source_id is the id of the item doing the buffing, which is excluded.
// rare items are excluded on account of items like Dios existing.
#define buff_synergy_odds(item_type, source_id)
    for (var rty = RTY_COMMON; rty <= RTY_UNCOMMON; rty++) {
        var arr_len = array_length(p_item_ids[rty]);
        for (var i = 0; i < arr_len; i++) {
            var iid = p_item_ids[rty][i];
            var type1 = item_grid[iid][IG_TYPE];
            var type2 = item_grid[iid][IG_TYPE2];
            if ((type1 == item_type || type2 == item_type) && iid != source_id && p_item_values[@ rty][@ i] < SYNERGY_BUFFED_VALUE) {
                var quantity = p_item_remaining[rty][i];
                p_item_values[@ rty][@ i] = SYNERGY_BUFFED_VALUE;
                p_item_weights[@ rty][@ i] = quantity * SYNERGY_BUFFED_VALUE;
            }
        }
    }
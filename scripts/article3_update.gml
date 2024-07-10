
// article3_update - runs every frame the article exists
// Miscellaneous objects

/*STATE LIST

- Default (-1): Failed initialization

FIREMAN'S BOOTS ~ FIRE
- 00: Initialization
- 01: Idle
- 02: Despawn

MONSTER TOOTH ~ ORB
- 10: Initialization
- 11: Flying out
- 12: Idle
- 13: Approaching target

GRANTED ITEM (flying towards player)
precondition: rarity = (0, 1, 2)
- 20: Initialization
- 21: Rising
- 22: Homing
- 23: Despawn

WARBANNER
- 30: Initialization
- 31: Spawning
- 32: Active/Idle
- 33: Despawn

FILIAL IMPRINTING ~ critter
precondition: upon spawning, spawn_num = item_grid[ITEM_FILIAL][IG_NUM_HELD]
- 40: Initialization
- 41: Spawning / Warping to player
- 42: Idle ~ standing
- 43: Idle ~ wandering
- 44: Chasing ~ running
- 45: Chasing ~ jumping
- 46: Dropping buff
- 47: Taunt
- 48: Despawn

FILIIAL IMPRINTING ~ buff
- 40: Initialization
- 41: Move speed buff
- 42: Attack speed buff
- 43: Healing

*/



switch state {
    
    
    //#region Fireman's Boots ~ Fire
    case 00:
        sprite_index = asset_get("fire_grnd1");
        mask_index = sprite_get("item_firetile_mask");
        state = 01;
        state_timer = 0;
        do_hitbox = false;
        break;
        
    case 01:
        image_index += 0.3;
        if (state_timer > 20) {
            state = 02;
            state_timer = 0;
            sprite_index = asset_get("fire_grnd1_leave");
            image_index = 0;
        }
        with oPlayer {
            if (player != other.player && !burned && place_meeting(x, y, other)) {
                burned = true;
                burnt_id = other.player_id;
                burn_timer = 150 - 30*other.player_id.FIREBOOTS_DAMAGE;
                burned_color = 0;
                other.player_id.enemy_burnID = self;
                other.player_id.other_burned = true;
                init_shader();
                sound_play(asset_get("sfx_burnapplied"));
            }
        }
        break;
        
    case 02:
        image_index += 0.3
        if (image_index >= 6) {
            instance_destroy();
            exit;
        }
        break;
        
    //#endregion
    
    //#region Monster Tooth
    case 10:
        sprite_index = sprite_get("item_tooth_orb");
        mask_index = sprite_get("item_tooth_orb");
        state = 11;
        state_timer = 0;
        orb_target = noone;
        orb_consumed = false;
        orb_healed = [];
        break;
        
    case 11:
        image_index += 0.3;
        vsp += 0.6;
        if (!free) {
            state = 12;
            state_timer = 0;
        }
        
        var min_distance = -1;
        if (state_timer > 8) with (oPlayer) {
            var distance = point_distance(x, y, other.x, other.y);
            if (state_cat != SC_HITSTUN && distance < 20 && (min_distance == -1 || distance < min_distance)) {
                min_distance = distance;
                other.orb_target = self;
                other.state = 13;
                other.state_timer = 0;
            }
        }
        
        break;
        
    case 12:
        if (hsp > 0) hsp = clamp(hsp - 0.6, 0, hsp);
        else if (hsp < 0) hsp = clamp(hsp + 0.6, hsp, 0);
        vsp = (state_timer > 6 ? sin(state_timer*pi/30) : -6 + state_timer);
        
        if (state_timer > 300) {
            spawn_lfx(sprite_get("vfx_item_tooth_despawn"), x, y, 8, 1, 1, 0, 0);
            instance_destroy();
            exit;
        }
        
        var min_distance = -1;
        with (oPlayer) {
            var distance = point_distance(x, y, other.x, other.y);
            if (!clone && distance < 70 && (min_distance == -1 || distance < min_distance)) {
                min_distance = distance;
                other.orb_target = self;
                other.state = 13;
                other.state_timer = 0;
            }
        }
        
        break;
    
    case 13:
        if (!instance_exists(orb_target)) {
            orb_target = noone;
            state = 11;
            state_timer = 0;
        }
        
        can_be_grounded = false;
        ignores_walls = true;
        dir = point_direction(x, y, orb_target.x, orb_target.y-orb_target.char_height/2);
        hsp = lengthdir_x(10, dir);
        vsp = lengthdir_y(10, dir);
        
        with oPlayer {
            if (place_meeting(x, y, other)) {
                take_damage(player, other.player, -2);
                if ("aegis_barrier" in self && "item_grid" in self) aegis_barrier += aegis_ratio * item_grid[42][IG_NUM_HELD] * 2;
                other.orb_consumed = true;
                array_push(other.orb_healed, self);
            }
        }
        
        if (orb_consumed) {
            
            for (i = 0; i < array_length(orb_healed); i++) {
                var seed = (get_player_damage(orb_healed[i].player) * orb_healed[i].player * 233) % 100;
                var _x = orb_healed[i].x;
                var _y = orb_healed[i].y;
                var _h = orb_healed[i].char_height;
                var _hvar = (_h < 10) ? 0 : _h-10;
                spawn_lfx(sprite_get("vfx_item_u_heal"), _x-45+random_func_2(seed+1, 30, false), _y-_h+random_func_2(seed+2, _hvar, false), 39+random_func_2(seed+3, 7, true), 1, 1, 0, -1);
			    spawn_lfx(sprite_get("vfx_item_u_heal"), _x-15+random_func_2(seed+4, 30, false), _y-_h+random_func_2(seed+5, _hvar, false), 39+random_func_2(seed+5, 7, true), 1, 1, 0, -1);
			    spawn_lfx(sprite_get("vfx_item_u_heal"), _x+15+random_func_2(seed+7, 30, false), _y-_h+random_func_2(seed+8, _hvar, false), 39+random_func_2(seed+9, 7, true), 1, 1, 0, -1);
            }
            
            sound_play(asset_get("mfx_timertick_holy"));
            spawn_lfx(sprite_get("vfx_item_tooth_despawn"), x, y, 8, 1, 1, 0, 0);
            instance_destroy();
            exit;
        }
        
        break;
    
    //#endregion
    
    //#region Granted Item
    case 20:
    	switch rarity {
    		case 2:
    			sprite_index = sprite_get("vfx_item_orb_r");
    			break;
    		case 1:
    			sprite_index = sprite_get("vfx_item_orb_u");
    			break;
    		default:
    			sprite_index = sprite_get("vfx_item_orb_c");
    			break;
    	}
        
        mask_index = sprite_get("null");
        ignores_walls = 1;
        can_be_grounded = 0;
        vsp = -10 + (1.5*rarity);
        state = 21;
        state_timer = 0;
        break;
       
    // rise
    case 21:
        vsp += 0.4 - (rarity/10);
        if (vsp >= -1 + (rarity/2)) {
        	vel = abs(vsp);
        	dir = 90;
        	state = 22;
        	state_timer = 0;
        }
        break;
    
    // home in
    case 22:
    	var target_x = player_id.x;
    	var target_y = player_id.y - floor(player_id.char_height/2);
    	var target_dist = point_distance(x, y, target_x, target_y);
    	var target_dir = point_direction(x, y, target_x, target_y);
    	var max_turn = max((100-target_dist)/3, 6+state_timer/2);
    	
    	vel += 0.6;
    	
    	if (target_dist > max(vel, 10)) {
	    	if (target_dir < dir) target_dir += 360;
	    	if (target_dir - dir < 180) dir = clamp(dir + max_turn, 0, target_dir);
	    	else dir = clamp(dir - max_turn, target_dir-360, target_dir); 
	    	if (dir < 0) dir += 360;
	    	if (dir > 360) dir -= 360;
	    	
	    	hsp = lengthdir_x(vel, dir);
	    	vsp = lengthdir_y(vel, dir);
    	} else {
    		state = 23;
    		state_timer = 0;
    		sprite_index = sprite_get("null");
    		player_id.grant_rarity = rarity;
    		user_event(1);
    	}
    	
    	break;
    
    // despawn
    case 23:
        instance_destroy();
        exit;
        
    //#endregion
    
    
    //#region Warbanner
    
    // init
    case 30:
    	sprite_index = sprite_get("item_temp_warbanner_spawn");
    	image_index = 0;
    	spr_dir = 1; // temp
    	radius_y_offset = -54;
    	
    	warbanner_strength = player_id.item_grid[player_id.ITEM_WARBANNER][player_id.IG_NUM_HELD];
    	warbanner_max_radius = player_id.WARBANNER_RADIUS_BASE + warbanner_strength * player_id.WARBANNER_RADIUS_SCALE;
    	warbanner_radius = 0;
    	warbanner_radius_speed = warbanner_max_radius / 20;
    	
    	state = 31;
    	state_timer = 0;
    	break;
    
    // spawn
    case 31:
    	image_index += 0.33;
    	if (image_index >= 3) {
    		sprite_index = sprite_get("item_temp_warbanner_idle");
    		image_index = 0;
    		state = 32;
    		state_timer = 0;
    	}
	
	// idle
	case 32:
	
		if (state == 32) image_index += 0.1;
		warbanner_radius = clamp(warbanner_radius+warbanner_radius_speed, warbanner_radius, warbanner_max_radius);
		
		with oPlayer if (get_player_team(player) == get_player_team(other.player)) {
			
			if (point_distance(x, y-(char_height/2), other.x, other.y+(other.radius_y_offset)) <= other.warbanner_radius) {
				if (commando_warbanner_owner != other.player && commando_warbanner_strength < other.warbanner_strength) {
					commando_warbanner_strength = other.warbanner_strength;
					commando_warbanner_owner = other.player;
					commando_warbanner_updated = 1;
				}
			} else if (commando_warbanner_owner == other.player) {
				commando_warbanner_strength = 0;
				commando_warbanner_owner = noone;
				commando_warbanner_updated = 1;
			}
		}
		
		if (player_id.was_parried || player_id.state == PS_RESPAWN || player_id.state == PS_DEAD || player_id.warbanner_obj != self) {
			state = 33;
			state_timer = 0;
			sprite_index = sprite_get("item_temp_warbanner_despawn");
		}
		
		break;
		
	// despawn
	case 33:
		image_index = state_timer/3;
		warbanner_radius = clamp(warbanner_radius-3*warbanner_radius_speed, 0, warbanner_radius);
		
		// This is temp handling for removing the buff, needs to be polished up later. Use the same point_distance check as above. (move to a function?)
		if (image_index >= 4) {
			with oPlayer if (commando_warbanner_owner == other.player) {
				commando_warbanner_strength = 0;
				commando_warbanner_owner = noone;
				commando_warbanner_updated = 1;
			}
			instance_destroy();
			exit;
		}
		break;
	
    //#endregion
    
    //#region Filial Imprinting ~ critter
    
    // Init
    case 40:
    
    	sprite_index = sprite_get("item_sucker_idle");
    	image_index = 0;
    	
    	buffspawn_timer = 0;
    	idle_statechange_threshold = 60; // changes at random
    	
    	ignores_walls = false;
    	can_be_grounded = true;
    	
    	stage_center_x = get_stage_data(SD_X_POS) + floor(get_stage_data(SD_WIDTH)/2);
    	chase_variance = random_func_2(player*spawn_num, player_id.FILIAL_CHASE_VARIANCE, true);
    	
    	state = 41;
    	state_timer = 0;
    	break;
    
    // Spawning / Warping to player
    case 41:
    	filial_status_update();
    	vsp += 0.4;
    	image_index += 0.15;
    	
    	if (!free) {
    		state = 42;
    		state_timer = 0;
    	}
    	else if (state_timer > 30 && !is_ground_below(150)) {
    		state = 45;
    		state_timer = 0;
    		if (x_outside_stage_width(player_id.x)) face_target(stage_center_x);
    		else face_target(player_id.x);
    	}
    	break;

	// Idle ~ standing
	case 42:
		filial_status_update();
		hsp = 0;
		vsp += 0.4;
		image_index += 0.15;
		if (state_timer == 1) idle_statechange_threshold = 60 + random_func_2(player*spawn_num, 90, true);
		
		if (!x_outside_stage_width(player_id.x) && abs(x-player_id.x) > player_id.FILIAL_CHASE_RANGE+chase_variance) {
			state = 44;
			state_timer = 0;
		}
		else if (state_timer >= idle_statechange_threshold) {
			spr_dir = 2*random_func_2(player*spawn_num, 2, true) - 1;
			state = 43;
			state_timer = 0;
		}
    	break;

	// Idle ~ wandering
	case 43:
		filial_status_update();
		hsp = 1.5*spr_dir;
		vsp += 0.4;
		image_index += 0.15;
		if (state_timer == 1) idle_statechange_threshold = 20 + random_func_2(player*spawn_num, 40, true);
		
		if (!x_outside_stage_width(player_id.x) && abs(x-player_id.x) > player_id.FILIAL_CHASE_RANGE+chase_variance) {
			state = 44;
			state_timer = 0;
		}
		else if (state_timer >= idle_statechange_threshold) {
			spr_dir = 2*random_func_2(player*spawn_num, 2, true) - 1;
			state = 42;
			state_timer = 0;
		}
    	break;

	// Chasing ~ running
	case 44:
		filial_status_update();
		face_target(player_id.x);
		hsp = 2*spr_dir;
		vsp += 0.4;
		image_index += 0.15;
		
		if (x_outside_stage_width(player_id.x) || abs(x-player_id.x) <= player_id.FILIAL_ENDCHASE_RANGE+chase_variance) {
			state = 42;
			state_timer = 0;
			chase_variance = random_func_2(player*spawn_num, player_id.FILIAL_CHASE_VARIANCE, true);
		}
		
    	break;

	// Chasing ~ jumping
	case 45:
		filial_status_update();
    	break;

	// Dropping buff
	case 46:
		filial_status_update();
    	break;

	// Taunt
	case 47:
		filial_status_update();
    	break;

	// Despawn
	case 48:
		instance_destroy();
		exit;
    	break;
    
    //#endregion
    
    //#region Failed initialization
    default:
        print_debug("Error: article 3 was not properly initialized")
        instance_destroy();
        exit;
    //#endregion
    
}


// Make time progress
state_timer++;


#define filial_status_update
	if (player_id.item_grid[player_id.ITEM_FILIAL][player_id.IG_NUM_HELD] < spawn_num) {
		player_id.filial_num_spawned--;
		state = 48;
		state_timer = 0;
		exit;
	}
	if (point_distance(x, y, player_id.x, player_id.y) > player_id.FILIAL_WARP_RADIUS) {
		x = player_id.x-(60*player_id.spr_dir);
		y = player_id.y-60;
		// spawn vfx
		state = 41;
		state_timer = 0;
	}
	buffspawn_timer++;

#define is_ground_below(distance)
	var ground_collision = collision_line(x, y, x, y+distance, asset_get("par_block"), false, false);
	var plat_collision = collision_line(x, y, x, y+distance, asset_get("par_jumpthrough"), false, false);
	return ground_collision || plat_collision;

#define x_outside_stage_width(_x)
	if (player_id.is_playtest) return false;
	return (_x < get_stage_data(SD_X_POS) || (get_stage_data(SD_X_POS)+get_stage_data(SD_WIDTH)) < _x);

#define face_target(target_x)
	if (target_x < x) spr_dir = -1;
	else spr_dir = 1;

#define spawn_lfx(in_sprite, _x, _y, in_lifetime, in_spr_dir, in_foreground, in_hsp, in_vsp)
var new_lfx = {
    lfx_x : _x,
    lfx_y : _y,
    lfx_sprite_index : in_sprite,
    lfx_max_lifetime : in_lifetime,
    lfx_lifetime : 0,
    lfx_spr_dir : in_spr_dir,
    lfx_foreground : in_foreground,
    lfx_hsp : in_hsp,
    lfx_vsp : in_vsp,
};
ds_list_add(player_id.lfx_list, new_lfx);
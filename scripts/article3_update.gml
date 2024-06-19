
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
        var fire = self;
        with oPlayer if (player != other.player && !burned) {
            with hurtboxID if (place_meeting(x, y, fire)) {
                fire.do_hitbox = true;
            }
        }
        if (do_hitbox) {
            do_hitbox = false;
            create_hitbox(AT_EXTRA_1, 1, x, y-17);
        }
        break
        
    case 02:
        image_index += 0.3
        if (image_index >= 6) {
            instance_destroy();
            exit;
        }
        with oPlayer {
            if (player != other.player && !burned && place_meeting(x, y, other)) {
                other.do_hitbox = true;
            }
        }
        if (do_hitbox) {
            do_hitbox = false;
            create_hitbox(AT_EXTRA_1, 1, x, y-17);
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
        vsp = -10;
        state = 21;
        state_timer = 0;
        break;
       
    // rise
    case 21:
        vsp += 0.4;
        if (vsp >= -1) {
        	vel = abs(vsp);
        	dir = 90;
        	state = 22;
        	state_timer = 0;
        }
        break;
    
    // home
    case 22:
    	var target_x = player_id.x;
    	var target_y = player_id.y - floor(player_id.char_height/2);
    	var target_dist = point_distance(x, y, target_x, target_y);
    	var target_dir = point_direction(x, y, target_x, target_y);
    	
    	vel += 0.6;
    	
    	if (target_dist > max(vel, 30)) {
	    	if (target_dir < dir) target_dir += 360;
	    	if (target_dir - dir < 180) dir = clamp(dir + 8, 0, target_dir);
	    	else dir = clamp(dir - 8, target_dir-360, target_dir); 
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
    
    
    //#region Failed initialization
    default:
        print_debug("Error: article 3 was not properly initialized")
        instance_destroy();
        exit;
    //#endregion
    
}


// Make time progress
state_timer++;

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
// B Reverse for the specials
if (attack == AT_NSPECIAL || attack == AT_FSPECIAL || attack == AT_DSPECIAL || attack == AT_USPECIAL){
    trigger_b_reverse();
}
// window length of the current window of the attack
var window_length = get_window_value(attack, window, AG_WINDOW_LENGTH);

attempt_behemoth_explosion();

prev_attack = attack;

// specific attack behaviour
switch(attack) {
	
	//#region Standard normals
	
    case AT_JAB:

        // clear attack so jab2 doesn't automatically happen
    	if (window == 1 && window_timer == 1) {
			clear_button_buffer(PC_ATTACK_PRESSED);
			//death_message_pick = death_messages[random_func_2( 0, array_length(death_messages), 1 )] //debug
		}
        break;
        
    case AT_FTILT:
        //a
        break;
        
    case AT_UTILT:
        //a
        break;
        
    case AT_DATTACK:
    	if (window == 1 && window_timer == 1) {
        	hsp += spr_dir * (move_speed * DATTACK_SPEED_SCALE + item_grid[ITEM_EDRINK][IG_NUM_HELD] * DATTACK_EDRINK_SCALE);
        }
        else if (window == 1 && window_timer == window_length-3) {
            sound_play(s_roll)
        }
        else if (window == 3 && window_timer == 10) {
        	can_jump = (window_timer > 6 && has_hit);
        	if (window_timer == 10) {
	            sound_play(asset_get("sfx_land"))
	            spawn_base_dust(x, y, "land", spr_dir)
        	}
        }
        break;
        
    case AT_NAIR:
        //a
        break;
        
    case AT_FAIR:
        if window == 2 {
        	var holding = (attack_down || left_stick_down || right_stick_down);
        	if (holding) strong_charge++;
			if (!holding || window_timer == 29) {
				sound_stop(s_reload)
            	sound_play(s_shotty, 0, noone, 3, .95)
				window = 3 
				window_timer = 0;
			}
		}
        break;
	
    case AT_DAIR:
        //a
        break;
        
    case AT_UAIR:
        //a
        break;
    
    case AT_FSTRONG: 
        if window == 2 && window_timer == window_length-1 {
            sound_stop(s_reload)
            sound_play(s_shotty, 0, noone, 3, .95)
        }
        break;
    
    //#endregion
    
    
    //#region Crit normals (DTilt)
    
    case AT_DTILT:
        if (window == 1 && window_timer == window_length - 1) {
            sound_play(s_dag_swing)
        }
        if (do_ignite_hbox && !hitpause) {
        	create_hitbox(AT_DTILT, 4, x, y); // melee hitbox, position doesn't matter
        	do_ignite_hbox = false;
        }
        //mods bring out the
        down_down = true
        break;
        
    //#endregion
    
    
    //#region Attack Speed scaling attacks
    
    //#region Back Air
    case AT_BAIR:
        if (window == 1 && window_timer == 1) {
    		num_loops = attack_speed - 1;
    		loops_done = 0;
    		loop_cancelled = false;
    		set_attack_value(attack, AG_CATEGORY, 1);
    		set_attack_value(attack, AG_NUM_WINDOWS, 5);
    		
    		// yep.
    		clear_button_buffer(PC_ATTACK_PRESSED);
    		clear_button_buffer(PC_STRONG_PRESSED);
    		clear_button_buffer(PC_LEFT_STRONG_PRESSED);
    		clear_button_buffer(PC_RIGHT_STRONG_PRESSED);
    		clear_button_buffer(PC_UP_STRONG_PRESSED);
    		clear_button_buffer(PC_DOWN_STRONG_PRESSED);
    		clear_button_buffer(PC_LEFT_STICK_PRESSED);
    		clear_button_buffer(PC_RIGHT_STICK_PRESSED);
    		clear_button_buffer(PC_UP_STICK_PRESSED);
    		clear_button_buffer(PC_DOWN_STICK_PRESSED);
    	}
    	
    	// Loop handling
    	var aerial_pressed = attack_pressed || is_attack_pressed(DIR_ANY) || left_strong_pressed || right_strong_pressed || down_strong_pressed || up_strong_pressed || is_strong_pressed(DIR_ANY); // thank you dan
    	if (window >= 2 && aerial_pressed) loop_cancelled = true;
    	if (window == 2 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH) && 0 >= num_loops) {
    		window = 3;
    		window_timer = 999; // jump to window 4
    	}
    	if (window == 3 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH)) {
    		num_loops--;
    		if (num_loops > 0 && !loop_cancelled) {
    			attack_end();
	    		window = 2;
	    		window_timer = 999; // jump to window 3
    		}
    		sound_play(get_window_value(attack, window, AG_WINDOW_SFX)); // differs based on if a loop occurred
    	}
    	
    	// Landing hitbox handling
    	if (window == 2 && window_timer == 1) set_attack_value(attack, AG_CATEGORY, 2);
        else if (window == 4 && window_timer == 1) set_attack_value(attack, AG_CATEGORY, 1);
        
        if (!free && window < 5 && get_attack_value(attack, AG_CATEGORY) == 2) {
        	set_attack_value(attack, AG_NUM_WINDOWS, 7);
        	destroy_hitboxes();
        	window = 5;
    		window_timer = 999; // jump to window 6
    		sound_play(asset_get("sfx_swipe_medium2"));
        }
        
        break;
    //#endregion
    
    //#region Down Strong
    case AT_DSTRONG:
    	if (window == 1 && window_timer == 1) {
    		num_loops = attack_speed - 1;
    		loops_done = 0;
    		loop_cancelled = false;
    	}
    	var strong_pressed = left_strong_pressed || right_strong_pressed || down_strong_pressed || up_strong_pressed || is_strong_pressed(DIR_ANY); // thank you dan
    	if (window >= 2 && strong_pressed) loop_cancelled = true;
    	if (window == 3 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH) && 0 >= num_loops) {
    		window = 4;
    		window_timer = 999; // jump to window 5
    	}
    	if (window == 4 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH)) {
    		num_loops--;
    		if (num_loops > 0 && !loop_cancelled) {
    			attack_end();
	    		window = 3;
	    		window_timer = 999; // jump to window 4
    		}
    		sound_play(get_window_value(attack, window, AG_WINDOW_SFX)); // differs based on if a loop occurred
    	}
    	
    	if window == 2 && window_timer == 5 {
            spawn_base_dust(x, y, "land", spr_dir)
        }
        if (window == 3 || window == 4 || window == 5) && window_timer == 5 {
            spawn_base_dust(x + 30 * spr_dir, y, "dash", -spr_dir)
            spawn_base_dust(x - 30 * spr_dir, y, "dash", spr_dir)
        }
    	break;
    //#endregion
    
    //#region Neutral Special
    case AT_NSPECIAL:
        move_cooldown[AT_NSPECIAL] = 36;

        if window != 1 && window != 5{ hud_offset = 30 }
        switch window {
            case 1: //startup HSP lerp - feel free to change if theres a more natural way to halt HSP before the first acive frame.
            	if (window_timer == 1) sound_play(asset_get("sfx_forsburn_cape_swipe"));
                hsp = lerp(hsp, 0, .1)
                vsp = lerp(vsp, 0, .1)
                num_loops = attack_speed - 1;
                if (window_timer == window_length) {
                	if (0 >= num_loops) {
                		window = 2;
		    			window_timer = 999; // jump to window 3
		    			sound_play(s_gunh);
                	}
		    		else sound_play(s_gunf);
		    	}
                break;
            case 2: //multihit windows
            	if (window_timer == window_length && !hitpause) {
            		num_loops--;
                	if (0 < num_loops) {
                		window = 1;
		    			window_timer = 999; // jump to window 2
		    			sound_play(s_gunf);
		    			attack_end();
                	}
		    		else sound_play(s_gunh);
		    	}
		    	hsp = 0;
                vsp = 0;
                can_fast_fall = 0
                can_move = 0
                if (window_timer == 1 && !hitpause) spawn_base_dust(x, y, "dash", spr_dir)
		    	break;
            case 3:
                hsp = 0;
                vsp = 0;
                can_fast_fall = 0
                can_move = 0
                if (window_timer == 1 && !hitpause) spawn_base_dust(x, y, "dash_start", spr_dir)
                break;
            case 4: //final window stuff
                can_fast_fall = 0
                can_move = 0
                if window_timer < 8 {
                    hsp = 0
                    vsp = 0
                    hud_offset = 30
                }
                break;
        }
        //a
        break;
    //#endregion
        
    //#endregion
    
	
	//#region Forward Special
	
    case AT_FSPECIAL:
        if (free) {
            if vsp > 5 vsp = 5 
            if hsp > (7*spr_dir) hsp = (7*spr_dir)
        }
        if window != 1 {
            can_jump = true
            can_attack = true
            can_strong = true
        }
        move_cooldown[AT_FSPECIAL] = 50;
        break;
    case AT_FSPECIAL_AIR:
    	if (window == 1) {
    		vsp = 0;
    		hsp *= 0.9;
    	}
        else {
            can_jump = true
            can_attack = true
            can_strong = true
        }
        
        if (window == 2) {
        	if (window_timer == 1 && !hitpause) fspec_air_uses--;
        	hsp -= 0.15 * spr_dir;
        	vsp += 0.075;
        } else {
        	if (hsp > air_max_speed) hsp -= 0.6;
        	else if (hsp < air_max_speed*-1) hsp += 0.6;
        	else if (hsp > 3) hsp -= 0.3;
        	else if (hsp < -3) hsp += 0.3;
        	vsp += 0.3;
        }
        
        can_move = (window == 3);
        
        break;
    
    //#endregion
    
    
    //#region Down Special
    
    case AT_DSPECIAL:
        can_fast_fall = false;
        can_move = false;
        if (window != 3) {
            hsp = lerp(hsp, 0, .1)
            if vsp > 0 vsp = lerp(vsp, 0, .3)
        }
        else if (window_timer == 1) {
        	if (instance_exists(chest_obj)) {
        		if (chest_obj.state == 01) {
        			chest_obj.state = 10;
        			chest_obj.state_timer = 0;
        		}
        		else if (chest_obj.state == 02) {
        			chest_obj.state = 20;
        			chest_obj.state_timer = 0;
        		}
        	}
        	else chest_obj = instance_create(x, y-20, "obj_article1");
        }
        break;
    case AT_DSPECIAL_2:
    	if (window == 1 && window_timer == 1) {
			if (chest_obj.state == 12) { // Large chest
				chest_obj.state = 13;
				chest_obj.state_timer = 0;
				dspec_cooldown_hits = DSPEC_SCHEST_CD_HITS;
			}
			else if (chest_obj.state == 22) { // Large chest
				chest_obj.state = 23;
				chest_obj.state_timer = 0;
				dspec_cooldown_hits = DSPEC_LCHEST_CD_HITS;
			}
			
			if (item_grid[ITEM_JEWEL][IG_NUM_HELD] > 0) {
				jewel_barrier = JEWEL_BARRIER_SCALE * item_grid[ITEM_JEWEL][IG_NUM_HELD];
				jewel_barrier_timer = JEWEL_DURATION;
				new_item_id = ITEM_JEWEL;
				user_event(0); // for ms buff
			}
    		var window_length = (chest_obj.state < 20) ? 8 : 28;
    		set_window_value(attack, window, AG_WINDOW_LENGTH, window_length)
    		set_window_value(attack, window, AG_WINDOW_SFX_FRAME, window_length-1);
    		hsp = 0;
    		spr_dir = (x < chest_obj.x) ? 1 : -1;
    	}
    	if (window < 3) {
    		can_move = false;
    		vsp = 0;
    	}
    	break;
    
    //#endregion	
	
	
	//#region Up Special
	
    case AT_USPECIAL:
        //a
        break;
    
    //#endregion
    
    
    //#region Taunts
    
    // Default
    case AT_TAUNT:
		if (window == 1 && window_timer == 1) {
			new_item_id = noone;
			user_event(0); // stat refresh
		}
		
		//#region DEBUG: enable debug var
		if (get_match_setting(SET_PRACTICE) && special_pressed && attack_pressed) {
			clear_button_buffer(PC_SPECIAL_PRESSED);
			clear_button_buffer(PC_SHIELD_PRESSED);
			debug_display_opened = !debug_display_opened;
		}
		//#endregion
		
		if (window == 1 && window_timer == window_length && item_grid[ITEM_WARBANNER][IG_NUM_HELD] > 0) {
			
			warbanner_obj = instance_create(x, y, "obj_article3");
			warbanner_obj.state = 30;
			
		}
		
    	break;
    
    // Training mode utility
    case AT_EXTRA_3:
    	attack_invince = true;
    	if (window == 1 && window_timer == 1) clear_button_buffer(PC_TAUNT_PRESSED);
    	
    	if (window == 2) {
    		if (taunt_pressed) {
	    		window = 3;
	    		window_timer = 0;
	    		if (tmu_state != TMU_INACTIVE) {
    				tmu_state = TMU_ITEM_CLOSING;
    				tmu_timer = 0;
    			}
    		}
    		else if (window_timer == window_length) {
    			window_timer = 0;
    			if (tmu_state == TMU_INACTIVE) {
    				tmu_state = TMU_OPENING;
    				tmu_timer = 0;
    			}
    		}
    	}
    	
    	if (tmu_state != TMU_INACTIVE) user_event(3)
    	break;
    
    //#endregion
    
}

// Defines

// Not currently configured for removing items or altering the probability set!!!
#define set_debug_item(item_id, quantity)
	new_item_id = item_id;
	while (item_grid[item_id][IG_NUM_HELD] < quantity) {
		force_grant_item = true;
		user_event(1);
	}
	while (item_grid[item_id][IG_NUM_HELD] > quantity) {
		force_remove_item = true;
		user_event(1);
	}

#define attempt_behemoth_explosion
if (do_behemoth_hbox && hit_player_obj.hitstop < hit_player_obj.hitstop_full * (1-BEHEMOTH_AWAIT_MULT)) {
	var _x = floor(hit_player_obj.x);
	var _y = floor(hit_player_obj.y - (hit_player_obj.char_height*0.7));
	var hbox = create_hitbox(AT_EXTRA_1, 1, _x, _y);
	hbox.spr_dir = 1;
	hbox.kb_value = hbox_stored_bkb;
	hbox.kb_scale = hbox_stored_kbg;
	hbox.kb_angle = hbox_stored_angle;
	hbox.hitpause = hbox_stored_bhp * BEHEMOTH_HITPAUSE_MULT;
	hbox.hitpause_growth = hbox_stored_hps * BEHEMOTH_HITPAUSE_MULT;
	hbox.do_not_hit = hbox_stored_lockout;
	do_behemoth_hbox = false;
	behemoth_hfx = spawn_hit_fx(_x, _y, HFX_ELL_BOOM_BIG);
	behemoth_hfx.depth = hit_player_obj.depth+1;
	behemoth_hfx_hitstop = 0; // to be overwritten shortly
}

#define sound_window_play //basically a shortcut to avoid repeating if statements over and over
/// sound_window_play(_window, _timer, _sound, _looping = false, _panning = noone, _volume = 1, _pitch = 1)
var _window = argument[0], _timer = argument[1], _sound = argument[2];
var _looping = argument_count > 3 ? argument[3] : false;
var _panning = argument_count > 4 ? argument[4] : noone;
var _volume = argument_count > 5 ? argument[5] : 1;
var _pitch = argument_count > 6 ? argument[6] : 1;
if window == _window && window_timer == _timer {
    sound_play(_sound,_looping,_panning,_volume,_pitch)
}



#define spawn_base_dust // written by supersonic
/// spawn_base_dust(x, y, name, dir = 0)
var dlen; //dust_length value
var dfx; //dust_fx value
var dfg; //fg_sprite value
var dfa = 0; //draw_angle value
var dust_color = 0;
var x = argument[0], y = argument[1], name = argument[2];
var dir = argument_count > 3 ? argument[3] : 0;

switch (name) {
	default: 
	case "dash_start":dlen = 21; dfx = 3; dfg = 2626; break;
	case "dash": dlen = 16; dfx = 4; dfg = 2656; break;
	case "jump": dlen = 12; dfx = 11; dfg = 2646; break;
	case "doublejump": 
	case "djump": dlen = 21; dfx = 2; dfg = 2624; break;
	case "walk": dlen = 12; dfx = 5; dfg = 2628; break;
	case "land": dlen = 24; dfx = 0; dfg = 2620; break;
	case "walljump": dlen = 24; dfx = 0; dfg = 2629; dfa = dir != 0 ? -90*dir : -90*spr_dir; break;
	case "n_wavedash": dlen = 24; dfx = 0; dfg = 2620; dust_color = 1; break;
	case "wavedash": dlen = 16; dfx = 4; dfg = 2656; dust_color = 1; break;
}
var newdust = spawn_dust_fx(x,y,asset_get("empty_sprite"),dlen);
if newdust == noone return noone;
newdust.dust_fx = dfx; //set the fx id
if dfg != -1 newdust.fg_sprite = dfg; //set the foreground sprite
newdust.dust_color = dust_color; //set the dust color
if dir != 0 newdust.spr_dir = dir; //set the spr_dir
newdust.draw_angle = dfa;
return newdust;

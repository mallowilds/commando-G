// B Reverse for the specials
if (attack == AT_NSPECIAL || attack == AT_FSPECIAL || attack == AT_DSPECIAL || attack == AT_USPECIAL){
    trigger_b_reverse();
}
// window length of the current window of the attack
var window_length = get_window_value(attack, window, AG_WINDOW_LENGTH);

// specific attack behaviour
switch(attack) {
    case AT_JAB:
        // clear attack so jab2 doesn't automatically happen
    	if (window == 1 && window_timer == 1) {
    		clear_button_buffer(PC_ATTACK_PRESSED);
    	}
        break;
    case AT_FTILT:
        //a
        break;
    case AT_DTILT:
        if window == 1 && window_timer == window_length - 1 {
            sound_play(s_dag_swing)
        }
        //mods bring out the
        down_down = true
        break;
    case AT_UTILT:
        //a
        break;
    case AT_DATTACK:
        //a
        break;
        
    case AT_NAIR:
        //a
        break;
    case AT_FAIR:
        //a
        break;
    case AT_BAIR:
        //a
        break;
    case AT_DAIR:
        //a
        break;
    case AT_UAIR:
        //a
        break;
    
    case AT_NSPECIAL:
        /* hi shear
        the way it should work:
        Normally, it just shoots a single beam, which acts as a large disjointed hitbox (projectile). It should be segmented into 2 hitboxes, with the further one having reduced power.
            Attack Speed: Every stack of attack speed adds a multihit to it, using the 'multihit hold' window. The hits should be extremely fast and dont need to be segmented into 2 hitboxes, since they should just be weak and very low hitpause.
            Ancient Scepter: The beam will get larger, and the final hit will have more knockback, along with not having KB falloff. It will also have 3 or so frames reduced startup (if needed? just think it'd be cool)
            Laser Turbine: When you fill up the meter for Laser Turbine to activate, No matter your attack speed, it will be replaced with a single, large laser, that doesnt have falloff.

            SFX:
            Didnt wanna mess with the SFX in attack update since i figure you're gonna have to change a bunch anyway. 
                Whiff, window 1: swipe_medium1, if there is a multihit, s_gunf. If theres no multihit, go straight to s_gunf.
                Whiff, multihit windows: Use s_gunf with sfx_blow_weak hitsounds for each multihit window - Before the last hit, s_gunf should play.
        */

        if window != 1 && window != 5{ hud_offset = 30 }
        switch window {
            case 1: //startup HSP lerp - feel free to change if theres a more natural way to halt HSP before the first acive frame.
                hsp = lerp(hsp, 0, .1)
                vsp = lerp(vsp, 0, .1)
                break;
            case 2: //multihit windows
            case 3:
            case 4:
                hsp = 0;
                vsp = 0;
                can_fast_fall = 0
                can_move = 0
                if window_timer == 1 { spawn_base_dust(x, y, "dash", spr_dir)}
                break;
            case 5: //final window stuff
                if window_timer == 1 { spawn_base_dust(x, y, "dash_start", spr_dir)} //fyi, these might need to be changed to be spawned before the hitbox, idk how itll work with hitpause. if it looks fine it doesnt matter though
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
    case AT_FSPECIAL:
        //a
        break;
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
    	if (window == 3 && window_timer == 1) {
    		if (place_meeting(x, y, chest_obj)) {
    			if (chest_obj.state == 12) { // Large chest
    				chest_obj.state = 13;
    				chest_obj.state_timer = 0;
    				var iid = generate_item(SCHEST_C_WEIGHT, SCHEST_U_WEIGHT, SCHEST_R_WEIGHT);
					var popup = instance_create(x-172, y-90, "obj_article2");
					popup.item_id = iid;
					move_cooldown[AT_DSPECIAL] = 600;
    			}
    			else if (chest_obj.state == 22) { // Large chest
    				chest_obj.state = 23;
    				chest_obj.state_timer = 0;
    				var iid = generate_item(LCHEST_C_WEIGHT, LCHEST_U_WEIGHT, LCHEST_R_WEIGHT);
					var popup = instance_create(x-172, y-90, "obj_article2");
					popup.item_id = iid;
					move_cooldown[AT_DSPECIAL] = 900;
    			}
    		}
    	}
    case AT_USPECIAL:
        //a
        break;
    case AT_FSTRONG: 
        if window == 2 && window_timer == window_length-1 {
            sound_stop(s_reload)
            sound_play(s_shotty, 0, noone, 3, .95)
        }
        break;
    
}

// command grab code
if (instance_exists(grabbed_player_obj) && get_window_value(attack, window, AG_WINDOW_GRAB_OPPONENT)) {
	
	//first, drop the grabbed player if this is the last window of the attack, or if they somehow escaped hitstun.
	if (window >= get_attack_value(attack, AG_NUM_WINDOWS)) { grabbed_player_obj = noone; }
	else if (grabbed_player_obj.state != PS_HITSTUN && grabbed_player_obj.state != PS_HITSTUN_LAND) { grabbed_player_obj = noone; }
	
	else {
		//keep the grabbed player in hitstop until the grab is complete.
		grabbed_player_obj.hitstop = 2;
		grabbed_player_obj.hitpause = true;
		
		//if this is the first frame of a window, store the grabbed player's relative position.
		if (window_timer <= 1) {
			grabbed_player_relative_x = grabbed_player_obj.x - x;
			grabbed_player_relative_y = grabbed_player_obj.y - y;
		}
		
		// pull opponent to window's grab positions
		var pull_to_x = get_window_value(attack, window, AG_WINDOW_GRAB_POS_X) * spr_dir;
		var pull_to_y = get_window_value(attack, window, AG_WINDOW_GRAB_POS_Y);
			
		//using an easing function, smoothly pull the opponent into the grab over the duration of this window.
		grabbed_player_obj.x = x + ease_circOut( grabbed_player_relative_x, pull_to_x, window_timer, window_length);
		grabbed_player_obj.y = y + ease_circOut( grabbed_player_relative_y, pull_to_y, window_timer, window_length);
		
	}
	
} else if (instance_exists(grabbed_player_obj)) { //if grabbed player exists but attack no longer grabs
	grabbed_player_obj = noone;
}

// walljump code
if (get_window_value(attack,window,AG_WINDOW_CAN_WALLJUMP)) {
	can_wall_jump = true;
}

// cosmetic attack fx
switch(attack) {
    case AT_JAB:
    	//a
        break;
    case AT_FTILT:
        //a
        break;
    case AT_DTILT:
        //a
        break;
    case AT_UTILT:
        //a
        break;
    case AT_DATTACK:
        //a
        break;
        
    case AT_NAIR:
        //a
        break;
    case AT_FAIR:
        //a
        break;
    case AT_BAIR:
        //a
        break;
    case AT_DAIR:
        //a
        break;
    case AT_UAIR:
        //a
        break;
    
    case AT_NSPECIAL:
        //a
        break;
    case AT_FSPECIAL:
        //a
        break;
    case AT_DSPECIAL:
        //a
        break;
    case AT_USPECIAL:
        //a
        break;
    
    case AT_TAUNT:
		//a
    	break;
    case AT_DSTRONG: {
        if window == 2 && window_timer == 5 {
            spawn_base_dust(x, y, "land", spr_dir)
        }
        if (window == 3 || window == 4 || window == 5) && window_timer == 5 {
            spawn_base_dust(x + 30 * spr_dir, y, "dash", -spr_dir)
            spawn_base_dust(x - 30 * spr_dir, y, "dash", spr_dir)
        }
    }
    
}

// Defines
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

#define random_weighted_roll(seed, weight_array)
// Picks one index from a given array of weights.
// Each index's odds of being picked is (weight at index) / (total of weights in array)
// Uses random_func_2, so 0 <= seed <= 200.
var array_len = array_length(weight_array);
var total_weight = 0;
for (var i = 0; i < array_len; i++) {
	total_weight += weight_array[i];
}
// on each loop, check if rand_int is less than the sum of all previous weights
var rand_int = random_func_2(seed, total_weight, true);
for (var i = 0; i < array_len; i++) {
	if (rand_int < weight_array[i]) {
		// print_debug("In: " + string(weight_array) + ", Out: " + string(i));
		return i;
	}
	rand_int -= weight_array[i];
}


#define generate_item(common_weight, uncommon_weight, rare_weight)
// Set rarity
var rarity_weights = [common_weight, uncommon_weight, rare_weight]
if (uncommons_remaining <= 0) rarity_weights[1] = 0;
if (rares_remaining <= 0) rarity_weights[2] = 0;
var rarity = random_weighted_roll(item_seed, rarity_weights);
item_seed = (item_seed + 1) % 200;

// Attempt to generate a legendary item
var rnd_legendary = random_func_2(item_seed, 1, false);
item_seed = (item_seed + 1) % 200;
if (rnd_legendary <= LEGENDARY_ODDS && legendaries_remaining[rarity] > 0) {
	
	var num_items = array_length(rnd_legend_index_store[rarity]);
	var access_index = random_func_2(num_items, 1, false);
	item_seed = (item_seed + 1) % 200;
	var item_id = rnd_legend_index_store[rarity][access_index];
	
	legendaries_remaining[rarity]--;
	// Remove legendary from item pool
	for (var i = access_index; i < num_items-1; i++) {
		rnd_legend_index_store[@ rarity][@ i] = rnd_legend_index_store[rarity][i+1];
	}
	rnd_legend_index_store[@ rarity] = array_slice(rnd_legend_index_store[rarity], 0, num_items-1);
	
}

else {
	
	// Generate a standard item
	var item_type = random_weighted_roll(item_seed, type_values[rarity]);
	item_seed = (item_seed + 1) % 200;
	var num_items = array_length(rnd_index_store[rarity][item_type]);
	var access_index = random_func_2(item_seed, num_items, false);
	item_seed = (item_seed + 1) % 200;
	var item_id = rnd_index_store[rarity][item_type][access_index];
	
	// Update probability properties to account for new item
	type_values[@ rarity][@ item_type] -= type_weights[rarity][item_type]; // update weights
	if (rarity = RTY_UNCOMMON) uncommons_remaining--;
	// remove item instance from rnd_index_store
	if (rarity != RTY_COMMON) {
		for (var i = access_index; i < num_items-1; i++) {
			rnd_index_store[@ rarity][@ item_type][@ i] = rnd_index_store[rarity][item_type][i+1];
		}
		rnd_index_store[@ rarity][@ item_type] = array_slice(rnd_index_store[rarity][item_type], 0, num_items-1);
	}
	
}

// Apply item (or roll for a new one if a conflict occured)
var incompat_index = item_grid[item_id][IG_INCOMPATIBLE]
if (incompat_index == noone || item_grid[incompat_index][IG_NUM_HELD] == 0) {
	if (item_grid[item_id][IG_NUM_HELD] == 0) array_push(inventory_list, item_id);
	item_grid[@ item_id][@ IG_NUM_HELD] = item_grid[item_id][IG_NUM_HELD] + 1;
	new_item_id = item_id;
	if (rarity = RTY_RARE) rares_remaining--;
	user_event(0);
}
else item_id = generate_item(common_weight, uncommon_weight, rare_weight);

return item_id;

#define spawn_comp_hit_fx
//function takes in an array that contains smaller arrays with the vfx information
// list formatting: [ [x, y, delay_time, index, rotation, depth, force_dir], ..]
var fx_list = argument0;
vfx_created = false;

//temporary array
var temp_array = [{cur_timer: -1, max_timer: 0}];  //first value is an array that constains current and max timer, to detect when to spawn vfx and when to stop and be replaced
                            //later values are the fx
var player_dir = spr_dir;

//first take the arrays from the function, set them into objects, and store them in an array
for (var i=0;i < array_length(fx_list);i++) {
    //create new fx part tracker and add to temp array
    var new_fx_part = {
        x: fx_list[i][0],
        y: fx_list[i][1],
        delay_timer: fx_list[i][2],
        index: fx_list[i][3],
        rotation: fx_list[i][4],
        depth: fx_list[i][5],
        spr_dir: fx_list[i][6] == 0 ? player_dir : fx_list[i][6]
    };
    array_push(temp_array, new_fx_part);
    
    //change max timer if delay is bigger than it
    if (new_fx_part.delay_timer > temp_array[0].max_timer) {
        temp_array[0].max_timer = new_fx_part.delay_timer;
    }
}

//add temp array to final array
for (var e=0;e<array_length(comp_vfx_array);e++) {
    if (vfx_created) { //stop process if effect is created
        break;
    } 
    if (comp_vfx_array[e][0].cur_timer > comp_vfx_array[e][0].max_timer) { //replace finished effects
        comp_vfx_array[e] = temp_array;
        vfx_created = true;
    } else if (e == array_length(comp_vfx_array)-1) { //otherwise add it in the end of the array
        array_push(comp_vfx_array, temp_array);
        vfx_created = true;
    }
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

//a


// temp
if false || (state == PS_PARRY && state_timer == 0) {
	var iid = generate_item(40, 40, 100)
	//print_debug("Obtained " + item_grid[iid][IG_NAME] + " (ID " + string(iid) + ")");
}




// reset idle_air_looping if the character isn't in air idle anymore
if (!(state == PS_FIRST_JUMP || state == PS_IDLE_AIR)) {
	idle_air_looping = false;
	idle_air_platfalling = false;
}

// remove attack air limit once character lands, respawns, walljumps or is hit
if (attack_air_limit_ver) {
	if ((!free || state == PS_RESPAWN || state == PS_WALL_JUMP || state == PS_HITSTUN) && state_timer == 1) {
		for(var i=0;i<array_length(attack_air_limit);i++) {
			attack_air_limit[i] = false;
		}
		attack_air_limit_ver = false;
	}
}

//#region dodge_duration_add management

switch state {
	case PS_PARRY_START:
		dodge_duration_timer = 0;
		break;
	
	case PS_AIR_DODGE:
		if (state_timer == 0) dodge_duration_timer = 0;
	
	case PS_PARRY:
	case PS_ROLL_BACKWARD:
	case PS_ROLL_FORWARD:
		if (state_timer == 6 && dodge_duration_timer < dodge_duration_add) {
			dodge_duration_timer++;
			state_timer--;
			window_timer--;
		}
		break;
		
}


//#endregion

//#region Kill detection

if (num_recently_hit > 0) for (var i = 0; i < 20; i++) {
	if (recently_hit[i] != noone) {
		if (!instance_exists(recently_hit[i]) || recently_hit[i].state == PS_DEAD || recently_hit[i].state == PS_RESPAWN) {
			// Trigger on-kill effects
			brooch_barrier += 5 * item_grid[9][IG_NUM_HELD]; // Topaz Brooch
			recently_hit[i] = noone;
		}
		else if (recently_hit[i].state_cat != SC_HITSTUN) {
			recently_hit[i] = noone;
		}
	}
}

//#endregion

//#region Item timers/states

// Bustling Fungus
if (item_grid[4][IG_NUM_HELD] != 0) {
	if (state == PS_CROUCH){ 
		if (!bungus_active && bungus_timer > bungus_wait_time) {
			bungus_active = 1;
			bungus_timer = 0;
		}
		if (bungus_active && bungus_timer > floor(bungus_tick_time/item_grid[4][IG_NUM_HELD])) {
			bungus_timer = 0;
			do_healing(1);
		}
		bungus_timer++;
	}
	else {
		bungus_active = 0;
		bungus_timer = 0;
	}
}

// Guardian Heart
if (item_grid[22][IG_NUM_HELD] != 0) {
	if (heart_barrier_endangered && heart_barrier_timer > heart_barrier_endangered_time) {
		heart_barrier_endangered = 0;
		heart_barrier_timer = 0;
	}
	if (!heart_barrier_endangered && heart_barrier_timer > heart_barrier_tick_time && heart_barrier < heart_barrier_max) {
		heart_barrier++;
		heart_barrier_timer = 0;
	}
	heart_barrier_timer++;
}

//#endregion

//#region Damage management

if (old_damage != get_player_damage(player)) {
	
	// Barrier handling
	damage_taken = get_player_damage(player) - old_damage;
	if (damage_taken > 0) {
		jewel_barrier = do_barrier(damage_taken, jewel_barrier);
		heart_barrier = do_barrier(damage_taken, heart_barrier);
		aegis_barrier = do_barrier(damage_taken, aegis_barrier);
		brooch_barrier = do_barrier(damage_taken, brooch_barrier);
	}
	
	// Arcane Blades stat update
	if ((old_damage >= 100) != (get_player_damage(player) >= 100)) {
		new_item_id = 7;
		user_event(0);
	}
	
	old_damage = get_player_damage(player);
}

//#endregion

//#region Reset fractional damage on enemy death
with object_index {
    if (!clone && (state == PS_DEAD || state == PS_RESPAWN)) {
        u_mult_damage_buffer = 0;
    }
}
//#endregion

// character recoloring / applying shade values
// init_shader(); //unused for now
// composite vfx update
update_comp_hit_fx();



#define do_healing(amount)
// Helper function to ensure that Aegis is always accounted for.
take_damage(player, player, -amount);
aegis_barrier += aegis_ratio * item_grid[42][IG_NUM_HELD] * amount;

#define do_barrier(damage_taken, barrier_val)
// Applies a barrier to absorb damage taken. (Assumes damage_taken > 0)
// Returns the new value for the barrier.
if (damage_taken > barrier_val) {
	take_damage(player, player, -floor(barrier_val));
	barrier_val = barrier_val - floor(barrier_val);
} else {
	take_damage(player, player, -barrier_val);
	barrier_val -= damage_taken;
}
return barrier_val;

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
if (rnd_legendary <= legendary_odds && legendaries_remaining[rarity] > 0) {
	
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


#define update_comp_hit_fx
//function updates comp_vfx_array
if comp_vfx_array != null {
    for(var ao=0;ao<array_length(comp_vfx_array);ao++) {
        if (comp_vfx_array[ao][0].cur_timer > comp_vfx_array[ao][0].max_timer) { //if effect is over, skip
            continue;
        }//otherwise go on
        comp_vfx_array[ao][0].cur_timer += 1; //update effect timer
        var check_timer = comp_vfx_array[ao][0].cur_timer; //store in a var for easier access
        for (var ae=1; ae<array_length(comp_vfx_array[ao]);ae++) { //check effect timers
            if (check_timer == comp_vfx_array[ao][ae].delay_timer) { //if timer is the spawn time, spawn it
                var new_fx = spawn_hit_fx(comp_vfx_array[ao][ae].x,comp_vfx_array[ao][ae].y,comp_vfx_array[ao][ae].index);
                new_fx.draw_angle = comp_vfx_array[ao][ae].rotation;
                new_fx.depth = depth+1+comp_vfx_array[ao][ae].depth; //so it appears in front of hit players
                new_fx.spr_dir = comp_vfx_array[ao][ae].spr_dir; // set it's spr dir, in case it should face a specific direction
            }
        }
    }
}

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

//a


// Debug: spawn item on parry
// Note that this lets you break item limits in its current form depending on luck. As this is dev code, I'm not planning to fix it.
if (get_gameplay_time() % 10 == 11) || (state == PS_PARRY && state_timer == 0) {
	
	var rarity_weights = [1, 1, 100];
    if (uncommons_remaining <= 0) rarity_weights[1] = 0;
    if (rares_remaining <= 0) rarity_weights[2] = 0;
    grant_rarity = random_weighted_roll(item_seed, rarity_weights);
    item_seed = (item_seed + 1) % 200;
	
	var item = instance_create(get_stage_data(SD_X_POS) + floor(get_stage_data(SD_WIDTH)/2), get_stage_data(SD_Y_POS)-10, "obj_article3");
    item.state = 20;
    item.rarity = grant_rarity;
	
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


//#region DSpec cooldown management
if (dspec_cooldown_hits	> 0) move_cooldown[AT_DSPECIAL] = 2;
first_hit = has_hit;
//#endregion

//#region Lightweight particle management
// See also: pre_draw.gml, post_draw.gml
for (var i = 0; i < ds_list_size(lfx_list); i++) {
    var lfx = ds_list_find_value(lfx_list, i);
    lfx.lfx_lifetime++;
    lfx.lfx_x += lfx.lfx_hsp;
    lfx.lfx_y += lfx.lfx_vsp;
    if (lfx.lfx_lifetime >= lfx.lfx_max_lifetime) {
        ds_list_remove(lfx_list, lfx);
        i--;
    }
}
//#endregion


//#region Status management
// Since this spawns hitboxes, it should be above the hitbox update block
with oPlayer {
	
	if (state == PS_DEAD || state == PS_RESPAWN) {
		for (var i = 0; i < 7; i++) {
			commando_status_state[i] = 0;
			commando_status_counter[i] = 0;
			commando_status_owner[i] = noone;
		}
	}
	
	// Burn counter (effectively deprecated, retained as a debug utility)
	if (commando_status_owner[other.ST_BURNCOUNTER] == other.player && commando_status_state[other.ST_BURNCOUNTER] > 0) {
		print_debug("_")
		print_debug(burnt_id);
		print_debug(other);
		print_debug(burn_timer);
		if (burnt_id != other) {
			commando_status_state[other.ST_BURNCOUNTER] = 0;
			commando_status_counter[other.ST_BURNCOUNTER] = 0;
		}
	}
	
	// Bleed (state indicates damage ticks remaining)
	if (commando_status_owner[other.ST_BLEED] == other.player && commando_status_state[other.ST_BLEED] > 0) {
		commando_status_counter[other.ST_BLEED]++;
		if (commando_status_counter[other.ST_BLEED] >= other.BLEED_TICK_TIME) {
			commando_status_state[other.ST_BLEED]--;
			commando_status_counter[other.ST_BLEED] = 0;
			take_damage(player, other.player, 1);
			if (commando_status_state[other.ST_BLEED] <= 0) commando_status_owner[other.ST_BLEED] = noone;
		}
	}
	
	// Electric stun (state 1 is active, state 2 is lockout. Status counter counts down to allow external stun time setting)
	if (commando_status_owner[other.ST_STUN_ELECTRIC] == other.player && commando_status_state[other.ST_STUN_ELECTRIC] > 0) {
		commando_status_counter[other.ST_STUN_ELECTRIC]--;
		if (last_player != commando_status_owner[other.ST_STUN_ELECTRIC]) { // mirrored in hit_player
			commando_status_state[other.ST_STUN_ELECTRIC] = 0;
			commando_status_counter[other.ST_STUN_ELECTRIC] = 0;
			commando_status_owner[other.ST_STUN_ELECTRIC] = noone;
		}
		switch (commando_status_state[other.ST_STUN_ELECTRIC]) {
			case 1:
				if (commando_status_counter[other.ST_STUN_ELECTRIC] <= 0) {
					commando_status_state[other.ST_STUN_ELECTRIC] = 2;
					commando_status_counter[other.ST_STUN_ELECTRIC] = 0;
				}
				else hitstop++;;
				break;
			case 2:
				if (!hitpause) {
					commando_status_state[other.ST_STUN_ELECTRIC] = 0;
					commando_status_counter[other.ST_STUN_ELECTRIC] = 0;
					commando_status_owner[other.ST_STUN_ELECTRIC] = noone;
				}
				break;
		}
	}
	
	// The Ol' Lopper effect (state 1 is awaiting, state 2 is hitpause, state 3 is lockout)
	if (commando_status_owner[other.ST_LOPPER] == other.player && commando_status_state[other.ST_LOPPER] > 0) {
		if (!hitpause) commando_status_counter[other.ST_LOPPER]++;
		switch (commando_status_state[other.ST_LOPPER]) {
			case 1:
				if (commando_status_counter[other.ST_LOPPER] >= other.LOPPER_AWAIT_TIME) {
					commando_status_state[other.ST_LOPPER] = 2;
					commando_status_counter[other.ST_LOPPER] = 0;
					with (other) create_hitbox(AT_EXTRA_1, 2, other.x, other.y+floor(char_height/2));
				}
				break;
			case 2:
				if (!hitpause) {
					commando_status_state[other.ST_LOPPER] = 3;
					commando_status_counter[other.ST_LOPPER] = 0;
					// spawn despawn/endlag vfx
				}
				break;
			case 3:
				if (commando_status_counter[other.ST_LOPPER] >= other.LOPPER_LOCKOUT) {
					commando_status_state[other.ST_LOPPER] = 0;
					commando_status_counter[other.ST_LOPPER] = 0;
					commando_status_owner[other.ST_LOPPER] = noone;
				}
				break;
		}
	}
	
	// Shattering Justice effect (state is cheatily used to store the modified knockback_adj)
	if (commando_status_owner[other.ST_SHATTERED] == other.player && commando_status_state[other.ST_SHATTERED] > 0) {
		if (!hitpause) commando_status_counter[other.ST_SHATTERED]++;
		if (knockback_adj != commando_status_state[other.ST_SHATTERED]) { // If knockback_adj was changed externally, reapply the shred
			knockback_adj += other.SHATTERING_KB_SHRED;
			commando_status_state[other.ST_SHATTERED] = knockback_adj;
		}
		if (commando_status_counter[other.ST_SHATTERED] >= other.SHATTERING_DURATION) { // Reset upon finishing duration
			knockback_adj -= other.SHATTERING_KB_SHRED;
			commando_status_state[other.ST_SHATTERED] = 0;
			commando_status_counter[other.ST_SHATTERED] = 0;
			commando_status_owner[other.ST_SHATTERED] = noone;
		}
		print_debug("Timer: " + string(commando_status_counter[other.ST_SHATTERED]));
	}
	
	if (self != other) print_debug(knockback_adj);
	
}

//#endregion

//#region hitbox_update (for the sake of melee hitboxes)
with pHitBox if (player_id == other) {
	// Init
	if (hitbox_timer == 0) {
		with (other) {
			other.cmd_is_critical = get_hitbox_value(other.attack, other.hbox_num, HG_IS_CRITICAL);
			other.cmd_strong_finisher = get_hitbox_value(other.attack, other.hbox_num, HG_STRONG_FINISHER);
		}
		if (cmd_is_critical) {
			if (player_id.item_grid[player_id.ITEM_GLASSES][player_id.IG_NUM_HELD] > 0) { // Lens Maker's Glasses
				damage += player_id.GLASSES_DAMAGE_BASE + player_id.GLASSES_DAMAGE_SCALE * player_id.item_grid[player_id.ITEM_GLASSES][player_id.IG_NUM_HELD];
			}
		}
		if (cmd_strong_finisher) {
			if (player_id.item_grid[player_id.ITEM_ICEBAND][player_id.IG_NUM_HELD] > 0) { // Runald's Band
				kb_scale += player_id.ICEBAND_KBS_SCALE * player_id.item_grid[player_id.ITEM_ICEBAND][player_id.IG_NUM_HELD];
				hitpause += player_id.ICEBAND_HITPAUSE;
				extra_hitpause += player_id.ICEBAND_EXTRA_HITPAUSE;
			}
		}
		if (effect == 2 && player_id.item_grid[player_id.ITEM_IGNITION][player_id.IG_NUM_HELD] > 0) { // Ignition Tank
			kb_scale += player_id.IGNITION_KBS_SCALE * player_id.item_grid[player_id.ITEM_IGNITION][player_id.IG_NUM_HELD];
		}
	}
}
//#endregion

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

//#region Hit/kill detection

if (num_recently_hit > 0) for (var i = 0; i < 20; i++) {
	if (recently_hit[i] != noone) {
		
		// On kill and/or object ceases to exist
		if (!instance_exists(recently_hit[i]) || recently_hit[i].state == PS_DEAD || recently_hit[i].state == PS_RESPAWN) {
			brooch_barrier += BROOCH_BARRIER_SCALE * item_grid[9][IG_NUM_HELD]; // Topaz Brooch
			recently_hit[i] = noone;
		}
		
		// Opponent has left hitstun
		else if (recently_hit[i].state_cat != SC_HITSTUN) {
			recently_hit[i] = noone;
		}
		
		// Opponent is leaving hitpause
		else if (recently_hit[i].hitstop < 2) {
			// Monster Tooth
			if (tooth_awaiting_spawn[i] != -1) {
				var temp_angle = tooth_awaiting_spawn[i];
				for (var j = 0; j < item_grid[47][IG_NUM_HELD]; j++) {
					var orb = instance_create(recently_hit[i].x, recently_hit[i].y-4, "obj_article3");
					orb.state = 10;
					var orb_angle = temp_angle - 5 + random_func_2((player*j + 3*j)%200, 10, false);
					orb.hsp = lengthdir_x(7 + random_func_2((player*i + 7*j)%200, 5, false), orb_angle);
					orb.vsp = lengthdir_y(7 + random_func_2((player*j + 5*j)%200, 5, false), orb_angle);
				}
				tooth_awaiting_spawn[i] = -1;
			}
		}
		
	}
}

//#endregion

//#region Item timers/states

// Bustling Fungus
if (item_grid[4][IG_NUM_HELD] != 0) {
	var attack_crouching = (state == PS_ATTACK_GROUND) && (attack == AT_DTILT || attack == AT_DSPECIAL);
	if (state == PS_CROUCH || attack_crouching) { 
		if (!bungus_active && bungus_timer > BUNGUS_WAIT_TIME) {
			bungus_active = 1;
			bungus_timer = 0;
			bungus_vis_timer = 0;
		}
		if (bungus_active && bungus_timer > floor(BUNGUS_TICK_TIME/item_grid[4][IG_NUM_HELD])) {
			bungus_timer = 0;
			do_healing(1);
			spawn_lfx(sprite_get("vfx_item_u_heal"), x-45+random_func_2(player*1, 30, false), y-50+random_func_2(player*2, 40, false), 39+random_func_2(player*3, 7, true), 1, 1, 0, -1);
			spawn_lfx(sprite_get("vfx_item_u_heal"), x-15+random_func_2(player*4, 30, false), y-50+random_func_2(player*5, 40, false), 39+random_func_2(player*6, 7, true), 1, 1, 0, -1);
			spawn_lfx(sprite_get("vfx_item_u_heal"), x+15+random_func_2(player*7, 30, false), y-50+random_func_2(player*8, 40, false), 39+random_func_2(player*9, 7, true), 1, 1, 0, -1);
		}
		bungus_timer++;
		bungus_vis_x = x;
		bungus_vis_y = y;
	}
	else {
		if (bungus_active) bungus_vis_timer = 0;
		bungus_active = 0;
		bungus_timer = 0;
	}
	bungus_vis_timer++;
}

// Guardian Heart
if (item_grid[ITEM_HEART][IG_NUM_HELD] != 0) {
	
	if (heart_barrier_endangered && heart_barrier_timer > HEART_ENDANGERED_TIME) {
		heart_barrier_endangered = 0;
		heart_barrier_timer = 0;
	}
	if (!heart_barrier_endangered && heart_barrier_timer > HEART_TICK_TIME && heart_barrier < heart_barrier_max) {
		heart_barrier++;
		heart_barrier_timer = 0;
	}
	heart_barrier_timer++;
	
}

// Locked Jewel
if (jewel_barrier_timer > 0) {
	
	jewel_barrier_timer--;
	if (jewel_barrier_timer == 0) {
		jewel_barrier = 0;
		new_item_id = ITEM_JEWEL;
    	user_event(0); // refresh move speed
	}
	
}

// Predatory Instincts
if (instincts_timer > 0) {
	instincts_timer--;
	if (instincts_timer == 0) {
		new_item_id = 26;
		user_event(0); // refresh stats
	}
}

// Fireman's Boots
if (item_grid[32][IG_NUM_HELD] > 0) {
	if (fireboots_lockout <= 0) {
		fireboots_distance += abs (x - fireboots_prev_x);
		fireboots_prev_x = x;
		if (free) fireboots_distance = FIREBOOTS_THRESHOLD;
		if (!free && fireboots_distance >= FIREBOOTS_THRESHOLD) {
			var burnbox = instance_create(x, y, "obj_article3")
			burnbox.state = 00;
			fireboots_distance = 0;
		}
	}
	else if (state != PS_HITSTUN && state != PS_HITSTUN_LAND && !was_parried) fireboots_lockout--;
}

// Photon Jetpack
if (item_grid[37][IG_NUM_HELD] > 0) { 
	if (!free) {
		pjetpack_fuel = pjetpack_fuel_max;
		pjetpack_available = false;
	}
	else if ((state == PS_FIRST_JUMP || state == PS_DOUBLE_JUMP || state == PS_WALL_JUMP) && state_timer == 0) {
		pjetpack_available = false;
	}
	else if (free && vsp >= PJETPACK_THRESHOLD) {
		pjetpack_available = true;
	}

	if (jump_down && pjetpack_available && pjetpack_fuel > 0) {
		pjetpack_fuel--;
		vsp = clamp(vsp-gravity_speed-PJETPACK_ACCEL, PJETPACK_MAX_RISE, PJETPACK_MAX_FALL);
		if (get_gameplay_time() % 6 == 0) {
			spawn_lfx(asset_get("mech_dstrong_steam"), x, y-10, 10, 1, 0, 0, 0)
		}
		if (pjetpack_sound == noone) {
			pjetpack_sound = sound_play(asset_get("sfx_ell_hover"), true, noone, 0.4, 1.4);
		}
	}
	else if (pjetpack_sound != noone) {
		sound_stop(pjetpack_sound);
		pjetpack_sound = noone;
	}
	
	if (free) {
		pjetpack_hud_alpha = clamp(pjetpack_hud_alpha+0.1, pjetpack_hud_alpha, 1);
		pjetpack_vis_fuel = pjetpack_fuel
	} else {
		pjetpack_hud_alpha = clamp(pjetpack_hud_alpha-0.1, 0, pjetpack_hud_alpha);
	}
}

// H3AD-5T V2
if (item_grid[38][IG_NUM_HELD] > 0) { 
	h3ad_lockout_timer++;
	if (!free) h3ad_lockout_timer = 0;
	if ((state == PS_DOUBLE_JUMP || state == PS_WALL_JUMP) && state_timer == 0) h3ad_lockout_timer = 0;
	else if (h3ad_lockout_timer >= HEADSET_LOCKOUT_TIME && can_fast_fall && vsp < 0 && down_hard_pressed) {
		vsp = 0;
		do_a_fast_fall = true;
	}
	if (h3ad_was_fast_falling != fast_falling) {
		if (fast_falling) sound_play(asset_get("sfx_land_heavy"));
		h3ad_was_fast_falling = fast_falling;
	}
}

// Dio's Best Friend
if (dios_revive_timer > 0) {
	
	dios_revive_timer--;
	set_state(PS_HITSTUN);
	hitstop = 3;
	
	if (dios_revive_timer == DIOS_REVIVE_WAIT-1) {
		var res_fx = spawn_hit_fx(x, y, fx_item_res); // uses VFX object due to visible == false disabling drawing
		res_fx.spr_dir = 1;
	}
	
	if (dios_revive_timer == 0) {
		set_state(PS_IDLE_AIR);
		var respawn_damage = get_player_damage(player)
		if (respawn_damage != 0) take_damage(player, player, -respawn_damage)
		take_damage(player, player, dios_stored_damage);
		initial_invince = 1;
		invince_time = DIOS_INVINCE_TIME;
		visible = true;
		
		item_grid[@ 44][@ IG_NUM_HELD]--;
		item_grid[@ 45][@ IG_NUM_HELD]++; // spent dios
		if (item_grid[45][IG_NUM_HELD] == 1) array_push(inventory_list, 45);
		
		if (item_grid[44][IG_NUM_HELD] == 0) {
			var i = 0;
			var num_items = array_length(inventory_list)
			while (inventory_list[i] != 44) i++;
			while (i < num_items-1) {
				inventory_list[i] = inventory_list[i+1];
				i++;
			}
			inventory_list = array_slice(inventory_list, 0, num_items-1);
		}
		
	}
	
}

else if (dios_revive_timer > -30) {
	dios_revive_timer--;
	if (dios_revive_timer == -30) {
		var popup = instance_create(x-172, y-90, "obj_article2");
		popup.item_id = 45;
	}
}

// Wax Quail
if (item_grid[ITEM_QUAIL][IG_NUM_HELD] > 0) {
	var attack_dashing = (state == PS_ATTACK_GROUND || state == PS_ATTACK_AIR) && ((attack == AT_DATTACK && has_hit) || attack == AT_FSPECIAL);
	if (state == PS_DASH || attack_dashing) quail_do_boost = true;
	else if (state != PS_JUMPSQUAT && state != PS_FIRST_JUMP && state != PS_AIR_DODGE && state != PS_WAVELAND) quail_do_boost = false;
	
	if (quail_do_boost) {
		if (state == PS_FIRST_JUMP && state_timer == 0) {
			hsp = spr_dir * (max_jump_hsp + QUAIL_JUMP_BASE + QUAIL_JUMP_SCALE*item_grid[ITEM_QUAIL][IG_NUM_HELD]);
		}
		if (state == PS_WAVELAND && state_timer == 0) {
			var waveland_dir = round(hsp/abs(hsp))
			if (waveland_dir == spr_dir) {
				hsp += spr_dir * (QUAIL_WAVE_BASE + QUAIL_WAVE_SCALE*item_grid[ITEM_QUAIL][IG_NUM_HELD]);
			}
		}
	}
}


//#endregion

//#region Damage management (Barriers/state changes)

if (old_damage != get_player_damage(player)) {
	
	// Barrier handling
	var damage_taken = get_player_damage(player) - old_damage;
	if (damage_taken > 0) {
		jewel_barrier = do_barrier(damage_taken, jewel_barrier);
		heart_barrier = do_barrier(damage_taken, heart_barrier);
		aegis_barrier = do_barrier(damage_taken, aegis_barrier);
		brooch_barrier = do_barrier(damage_taken, brooch_barrier);
	}
	
	// Arcane Blades stat update
	if ((item_grid[ITEM_BLADES][IG_NUM_HELD] > 0) && ((old_damage >= 100) != (get_player_damage(player) >= 100))) {
		new_item_id = ITEM_BLADES;
		user_event(0);
	}
	
	// Energy Cell
	if (item_grid[ITEM_CELL][IG_NUM_HELD] > 0) {
		new_item_id = ITEM_CELL;
	    user_event(0);
	}
	
	old_damage = get_player_damage(player);
	
}

var barrier = floor(brooch_barrier + heart_barrier + jewel_barrier + aegis_barrier);

if (barrier > 0) {
	if (hud_barrier_fade_alpha < 0.8) hud_barrier_fade_alpha += 0.1;
} else {
	if (hud_barrier_fade_alpha > 0) hud_barrier_fade_alpha -= 0.1;
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
ds_list_add(lfx_list, new_lfx);


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
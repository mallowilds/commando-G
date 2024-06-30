//                           --hit stuff--                                    //

//#region DSpec cooldown handling
if (!first_hit || (my_hitboxID.type == 2 && ("is_fake_hit" not in my_hitboxID || !my_hitboxID.is_fake_hit) && (my_hitboxID.orig_player != player || my_hitboxID.attack != AT_EXTRA_1))) {
	if (dspec_cooldown_hits == 1) sound_play(s_cd)
	if (dspec_cooldown_hits > 0) dspec_cooldown_hits--;
}
//#endregion

//#region Strong handling
if (my_hitboxID.cmd_strong_finisher) {
	// Kjaro's Band
	if (item_grid[ITEM_FIREBAND][IG_NUM_HELD] > 0) {
		var band_damage = FIREBAND_DAMAGE_BASE + item_grid[ITEM_FIREBAND][IG_NUM_HELD] * FIREBAND_DAMAGE_SCALE;
		apply_burn(hit_player_obj, band_damage);
        // spawn vfx
	}
	
	// Runald's Band
	if (item_grid[ITEM_ICEBAND][IG_NUM_HELD] > 0) {
		sound_play(asset_get("sfx_ice_back_air"));
		// spawn vfx
	}
}
//#endregion

//#region Crit handling
if (critical_active && my_hitboxID.cmd_is_critical == 1) {
	// Play crit sound
	print_debug("crit!");
	sound_play(s_crit);
	
	if (item_grid[ITEM_SCYTHE][IG_NUM_HELD] > 0) {
		sound_play(s_critheal) //tie this to harvesters scythe when u get a chance 
		do_healing(floor(my_hitboxID.damage * (SCYTHE_HEAL_BASE + SCYTHE_HEAL_SCALE*item_grid[24][IG_NUM_HELD]))); // Harvester's Scythe
		spawn_lfx(sprite_get("vfx_item_u_heal"), x-45+random_func_2(player*1, 30, false), y-60+random_func_2(player*2, 50, false), 39+random_func_2(player*3, 7, true), 1, 1, 0, -1);
		spawn_lfx(sprite_get("vfx_item_u_heal"), x-15+random_func_2(player*4, 30, false), y-60+random_func_2(player*5, 50, false), 39+random_func_2(player*6, 7, true), 1, 1, 0, -1);
		spawn_lfx(sprite_get("vfx_item_u_heal"), x+15+random_func_2(player*7, 30, false), y-60+random_func_2(player*8, 50, false), 39+random_func_2(player*9, 7, true), 1, 1, 0, -1);
	}
	
	if (item_grid[ITEM_INSTINCTS][IG_NUM_HELD] > 0) {
		instincts_timer = INSTINCTS_DURATION;
		new_item_id = 26;
		user_event(0); // refresh stats
	}
	
	if (item_grid[ITEM_BLEEDDAGGER][IG_NUM_HELD] > 0) {
		var bleed_damage = BLEEDDAGGER_DAMAGE_BASE + item_grid[ITEM_BLEEDDAGGER][IG_NUM_HELD] * BLEEDDAGGER_DAMAGE_SCALE;
		hit_player_obj.commando_status_owner[ST_BLEED] = player;
		if (hit_player_obj.commando_status_state[ST_BLEED] < bleed_damage) hit_player_obj.commando_status_state[ST_BLEED] = bleed_damage;
		spawn_hit_fx(get_effect_offset_x(), get_effect_offset_y(), fx_crit_blood);
	}
	
	if (item_grid[ITEM_TASER][IG_NUM_HELD] > 0) {
		var stun_type = (hit_player_obj.commando_status_state[ST_STUN_ELECTRIC] == 0 && hit_player_obj.commando_status_state[ST_STUN_EXPLOSIVE] == 0) ? 1 : 2;
		hit_player_obj.commando_status_state[ST_STUN_ELECTRIC] = stun_type;
		hit_player_obj.commando_status_counter[ST_STUN_ELECTRIC] = TASER_STUN_BASE + item_grid[ITEM_TASER][IG_NUM_HELD] * TASER_STUN_SCALE;
		hit_player_obj.commando_status_owner[ST_STUN_ELECTRIC] = player;
		spawn_hit_fx(get_effect_offset_x(), get_effect_offset_y(), (stun_type == 1) ? fx_crit_shock_long : fx_crit_shock);
	}
	
	if (item_grid[ITEM_IGNITION][IG_NUM_HELD] > 0 && hit_player_obj.burned) {
		do_ignite_hbox = true;
	}
	
}

else if (hit_player_obj.commando_status_state[ST_STUN_ELECTRIC] != 0) {
	hit_player_obj.commando_status_state[ST_STUN_ELECTRIC] = 2;
	hit_player_obj.commando_status_counter[ST_STUN_ELECTRIC] = 0;
	hit_player_obj.commando_status_owner[ST_STUN_ELECTRIC] = player;
}
//#endregion

//#region Explosive handling
if (my_hitboxID.cmd_is_explosive == 1) {
	
	// Concussion Grenade
	if (item_grid[ITEM_STUNGRENADE][IG_NUM_HELD] > 0) {
		var stun_type = (hit_player_obj.commando_status_state[ST_STUN_ELECTRIC] == 0 && hit_player_obj.commando_status_state[ST_STUN_EXPLOSIVE] == 0) ? 1 : 2;
		hit_player_obj.commando_status_state[ST_STUN_EXPLOSIVE] = stun_type;
		hit_player_obj.commando_status_counter[ST_STUN_EXPLOSIVE] = STUNGRENADE_STUN_BASE + item_grid[ITEM_STUNGRENADE][IG_NUM_HELD] * STUNGRENADE_STUN_SCALE;
		hit_player_obj.commando_status_owner[ST_STUN_EXPLOSIVE] = player;
		sound_play(asset_get("sfx_mol_flash_explode"));
		// hfx
	}
	
	// Sticky Bomb
	if (item_grid[ITEM_STICKYBOMB][IG_NUM_HELD] > 0) {
		hit_player_obj.commando_status_state[ST_STICKY] = 1;
		hit_player_obj.commando_status_counter[ST_STICKY] = 0;
		hit_player_obj.commando_status_owner[ST_STICKY] = player;
		sound_play(asset_get("sfx_absa_cloud_placepop"));
		// hfx
	}
	
	// Gasoline
	if (item_grid[ITEM_GASOLINE][IG_NUM_HELD] > 0) {
		var gas_damage = GASOLINE_DAMAGE_BASE + item_grid[ITEM_GASOLINE][IG_NUM_HELD] * GASOLINE_DAMAGE_SCALE;
		apply_burn(hit_player_obj, gas_damage);
	}
	
}

else if (hit_player_obj.commando_status_state[ST_STUN_EXPLOSIVE] != 0) {
	hit_player_obj.commando_status_state[ST_STUN_EXPLOSIVE] = 2;
	hit_player_obj.commando_status_counter[ST_STUN_EXPLOSIVE] = 0;
	hit_player_obj.commando_status_owner[ST_STUN_EXPLOSIVE] = player;
}
//#endregion

//#region Ol' Lopper / Shattering Justice
if (get_player_damage(hit_player_obj.player) >= LOPPER_DAMAGE_THRESHOLD && hit_player_obj.orig_knock >= LOPPER_KB_THRESHOLD && item_grid[ITEM_LOPPER][IG_NUM_HELD] > 0) {
	if (hit_player_obj.commando_status_owner[ST_LOPPER] == noone) {
		hit_player_obj.commando_status_state[ST_LOPPER] = 1;
		hit_player_obj.commando_status_owner[ST_LOPPER] = player;
		hit_player_obj.commando_status_timer[ST_LOPPER] = 0;
	}
}

if (get_player_damage(hit_player_obj.player) >= SHATTERING_DAMAGE_THRESHOLD && item_grid[ITEM_SHATTERING][IG_NUM_HELD] > 0) {
	if (hit_player_obj.commando_status_owner[ST_SHATTERED] == noone) {
		hit_player_obj.knockback_adj += SHATTERING_KB_SHRED;
		hit_player_obj.commando_status_state[ST_SHATTERED] = hit_player_obj.knockback_adj;
		hit_player_obj.commando_status_owner[ST_SHATTERED] = player;
	}
	hit_player_obj.commando_status_timer[ST_SHATTERED] = 0; // duration is reapplied regardless
}
//#endregion

//#region Fractional damage / multiplier handling (crowbar, warbanner, headstompers)

// Crowbar handing (This also increases kb)
var crowbar_mult_add = 0;
if (get_player_damage(hit_player_obj.player) - my_hitboxID.damage <= 50 && item_grid[0][IG_NUM_HELD] > 0) {
	sound_play(s_cbar, 0, noone, 1, 0.95 + 0.1*random_func(player, 1, false));
	crowbar_mult_add = CROWBAR_MULT_BASE + CROWBAR_MULT_SCALE*item_grid[0][IG_NUM_HELD];
	hit_player_obj.orig_knock += CROWBAR_KB_ADD_SCALE * my_hitboxID.kb_scale * 0.12 * hit_player_obj.knockback_adj * item_grid[0][IG_NUM_HELD];
	// Note that this kb increase could result in scenarios where galaxies don't properly trigger. However, given that it only applies at low percents, this is unlikely to occur outside of practice mode.
}

// Warbanner handling
var warbanner_mult_add = 0;
if (commando_warbanner_strength > 0) warbanner_mult_add = WARBANNER_MULT_BASE + commando_warbanner_strength * WARBANNER_MULT_SCALE;

// Headstompers handling
var stompers_extra_damage = 0;
if (my_hitboxID.type == 1 && my_hitboxID.attack == AT_EXTRA_1 && 4 <= my_hitboxID.hbox_num && my_hitboxID.hbox_num <= 6) {
	stompers_extra_damage = STOMPERS_DAMAGE_SCALE * (item_grid[ITEM_STOMPERS][IG_NUM_HELD] - 1);
}

// Apply damage amps
var base_damage = my_hitboxID.damage + stompers_extra_damage;
var mult_damage_add = base_damage * (crowbar_mult_add + warbanner_mult_add) + stompers_extra_damage;
take_damage(hit_player_obj.player, player, floor(mult_damage_add));

// Buffer non-integer damage, apply buffer as needed
if (!hit_player_obj.clone) {
	hit_player_obj.u_mult_damage_buffer += mult_damage_add - floor(mult_damage_add);
	if (hit_player_obj.u_mult_damage_buffer >= 1) {
	    take_damage(hit_player_obj.player, player, floor(hit_player_obj.u_mult_damage_buffer));
	    hit_player_obj.u_mult_damage_buffer -= floor(hit_player_obj.u_mult_damage_buffer);
	}
}

//#endregion


//#region DSpec chest hitpause
if (my_hitboxID.attack == AT_DSPECIAL && my_hitboxID.orig_player == player && "owner_chest" in my_hitboxID) {
	my_hitboxID.owner_chest.hitstop = floor(hit_player_obj.hitstop);
	my_hitboxID.owner_chest.has_hit = true;
}
//#endregion

//#region Kill tracking

if (!hit_player_obj.clone && recently_hit[hit_player_obj.player-1] == noone) {
	recently_hit[hit_player_obj.player-1] = hit_player_obj;
	num_recently_hit++;
}

//#endregion

//#region Monster Tooth
if (item_grid[ITEM_MTOOTH][IG_NUM_HELD] > 0 && hit_player_obj.orig_knock >= 12) {
	tooth_awaiting_spawn[hit_player_obj.player-1] = point_direction(0, 0, hit_player_obj.hsp*-1, abs(hit_player_obj.vsp)*-1);
}
//#endregion

//#region Brilliant Behemoth/ATG

// Store knockback if appropriate
if (my_hitboxID.cmd_strong_finisher || my_hitboxID.cmd_behemoth_applied) {
	hbox_stored_damage = my_hitboxID.damage; // probably won't see use in practice
	hbox_stored_bkb = my_hitboxID.kb_value;
	hbox_stored_kbg = my_hitboxID.kb_scale;
	hbox_stored_angle = point_direction(0, 0, hit_player_obj.hsp, hit_player_obj.vsp); // as an aside, behemoth/atg hitboxes should have spr_dir fixed at 1
	hbox_stored_bhp = my_hitboxID.hitpause;
	hbox_stored_hps = my_hitboxID.hitpause_growth;
	hbox_stored_lockout = my_hitboxID.orig_lockout;
}

if (my_hitboxID.cmd_behemoth_applied && item_grid[ITEM_BEHEMOTH][IG_NUM_HELD] > 0) {
	do_behemoth_hbox = 1;
}

//#endregion


// hitbox lerp code
if (get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_HAS_LERP) == true) {
	if (my_hitboxID.type == 1) { //if physical, pull relative to player
		hit_player_obj.x = lerp(hit_player_obj.x, x + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_X)*spr_dir, get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
		hit_player_obj.y = lerp(hit_player_obj.y, y + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_Y), get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
	} else if (my_hitboxID.type == 2) { // otherwise pull relative to hitbox
		hit_player_obj.x = lerp(hit_player_obj.x, my_hitboxID.x + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_X)*spr_dir, get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
		hit_player_obj.y = lerp(hit_player_obj.y, my_hitboxID.y + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_Y), get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
	}
}

// command grab code
if (get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_HAS_GRAB) == true) {
	
	//Before grabbing the opponent, first make sure that:
	//-The player is in an attack animation
	//-The opponent is in hitstun
	//-The player did not get parried, and
	//-The opponent is not a Forsburn clone.

	if ((state == PS_ATTACK_GROUND || state == PS_ATTACK_AIR)
	  && (hit_player_obj.state == PS_HITSTUN || hit_player_obj.state == PS_HITSTUN_LAND)
    	  && was_parried == false
	  && hit_player_obj.clone == false) {
		
		//transition to the 'throw' part of the attack.
		if (get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_GRAB_WINDOW_GOTO) != -1) {
			destroy_hitboxes();
			attack_end();
			window = get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_GRAB_WINDOW_GOTO);
			window_timer = 0;
			old_hsp = get_window_value(my_hitboxID.attack, window, AG_WINDOW_HSPEED);
			old_vsp = get_window_value(my_hitboxID.attack, window, AG_WINDOW_VSPEED);
			
			if (get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_GRAB_WINDOWS_NUM) != -1) {
				set_attack_value(attack,AG_NUM_WINDOWS,get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_GRAB_WINDOWS_NUM));
			}
		}
		
		//if this attack hasn't grabbed a player yet, grab the player we just hit.
		if (!instance_exists(grabbed_player_obj)) { grabbed_player_obj = hit_player_obj; }
		
		//if this attack has already grabbed a different opponent, prioritize grabbing the closest opponent.
		else {
			var old_grab_distance = point_distance(x, y, grabbed_player_obj.x, grabbed_player_obj.y);
			var new_grab_distance = point_distance(x, y,     hit_player_obj.x,     hit_player_obj.y);
			if (new_grab_distance < old_grab_distance) { grabbed_player_obj = hit_player_obj; }
			// setting it in case of an attack that continues the current window
			grabbed_player_relative_x = grabbed_player_obj.x - x;
			grabbed_player_relative_y = grabbed_player_obj.y - y;
		}
	}
}

// break grab
if (get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_BREAKS_GRAB) == true && instance_exists(grabbed_player_obj)) {
	grabbed_player_obj = noone;
}

// multihit projectile code
if (get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_PROJECTILE_MULTIHIT) == true) {
	if (!my_hitboxID.proj_hitpause) {
		my_hitboxID.proj_old_hsp = my_hitboxID.hsp;
		my_hitboxID.proj_old_vsp = my_hitboxID.vsp;
		my_hitboxID.proj_old_img_spd = my_hitboxID.img_spd;
		my_hitboxID.proj_hitpause = true;
	}
	my_hitboxID.proj_hitstop = my_hitboxID.hitpause;
	my_hitboxID.hitbox_hit_player_count[hit_player_obj.player] += 1;
	my_hitboxID.hitbox_hit_player_timers[hit_player_obj.player] = 0;
}


//                          --hit gamefeel--                                  //

switch(my_hitboxID.attack) {
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
        
    case AT_FSTRONG:
    	var dir_fx = spawn_hit_fx(get_effect_offset_x(), get_effect_offset_y(), fx_blast);
    	dir_fx.draw_angle = 10 * spr_dir;
    	break;
    case AT_USTRONG:
    	//a
    	break;
    case AT_DSTRONG:
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
       
    case AT_EXTRA_1:
    	if (my_hitboxID.orig_player == player && my_hitboxID.hbox_num == 1) { // Brilliant Behemoth
    		behemoth_hfx_hitstop = max(0, hit_player_obj.hitstop);
    	}
    	break;
    
}


#define do_healing(amount)
// Helper function to ensure that Aegis is always accounted for.
take_damage(player, player, -amount);
aegis_barrier += aegis_ratio * item_grid[42][IG_NUM_HELD] * amount;

#define apply_burn(target_player_obj, burn_damage)
	var ticks = 150 - 30*burn_damage;
	if (!target_player_obj.burned || ticks < target_player_obj.burn_timer) target_player_obj.burn_timer = ticks; // don't reduce an existing burn
	target_player_obj.burned = true;
    target_player_obj.burnt_id = self;
    target_player_obj.burned_color = 0;
    enemy_burnID = target_player_obj;
    other_burned = true;
    with (target_player_obj) init_shader();
    sound_play(asset_get("sfx_burnapplied"));

#define get_effect_offset_x

return (hit_player_obj.x + my_hitboxID.x) * 0.5 + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_VISUAL_EFFECT_X_OFFSET) * spr_dir;

#define get_effect_offset_y

return (hit_player_obj.y + my_hitboxID.y)*0.5 + get_hitbox_value(my_hitboxID.attack,my_hitboxID.hbox_num,HG_VISUAL_EFFECT_Y_OFFSET) - 25;

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
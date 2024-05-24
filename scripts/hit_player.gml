//                           --hit stuff--                                    //


//#region Crit handling
if (critical_active && my_hitboxID.cmd_is_critical == 1) {
	// Play crit sound
	
}
//#endregion


//#region Crowbar handing
var crowbar_mult_add = 0;
if (get_player_damage(hit_player_obj.player) - my_hitboxID.damage <= 50 && item_grid[0][IG_NUM_HELD] > 0) {
	crowbar_mult_add = 0.5 * item_grid[0][IG_NUM_HELD];
	hit_player_obj.orig_knock += 10 * my_hitboxID.kb_scale * 0.12 * hit_player_obj.knockback_adj * item_grid[0][IG_NUM_HELD]; 
	sound_play(sound_get("cm_crowbar"), 0, noone, 1, 0.95 + 0.1*random_func(player, 1, false));
}
//#endregion

//#region Damage multipliers

// Base amp
var mult_damage_add = my_hitboxID.damage * (multiplier + crowbar_mult_add);
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

//#region Kill tracking

if (!hit_player_obj.clone && recently_hit[hit_player_obj.player-1] == noone) {
	recently_hit[hit_player_obj.player-1] = hit_player_obj;
	num_recently_hit++;
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

// this used to have vfx but it was a mess and I solved some of the initial
// problems on pohaku

// I'll redo it later with the improvements n new vfx
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
    	//a
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
    
}

#define get_effect_offset_x

return (hit_player_obj.x + x) * 0.5 + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_VISUAL_EFFECT_X_OFFSET) * spr_dir;

#define get_effect_offset_y

return (hit_player_obj.y + y)*0.5 + get_hitbox_value(my_hitboxID.attack,my_hitboxID.hbox_num,HG_VISUAL_EFFECT_Y_OFFSET) - 25;

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

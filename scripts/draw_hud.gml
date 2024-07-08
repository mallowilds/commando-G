

if ("inventory_list" not in self) exit;
if (!init_complete) exit;

var x_spacing = clamp(72 - 6 * array_length(inventory_list), 26, 44);
var y_spacing = 22;

var hud_x = temp_x - 10;
var hud_y = temp_y - 48 - (y_spacing * floor((array_length(inventory_list)-1)/8));

for (var i = 0; i < array_length(inventory_list); i++) {
	var iid = inventory_list[i]
	draw_sprite_ext(sprite_get("item"), iid, hud_x, hud_y+4, 2, 2, 0, c_white, 1);
	if (item_grid[iid][IG_NUM_HELD] > 1) draw_debug_text(hud_x, hud_y, string(item_grid[iid][IG_NUM_HELD]));
	hud_x += x_spacing;
	if (i % 8 == 7) {
		hud_x = temp_x - 10;
		hud_y += y_spacing;
	}
}

//#region Barrier indicator

var barrier = floor(brooch_barrier + heart_barrier + jewel_barrier + aegis_barrier);

if (barrier > 0 && get_local_setting(SET_HUD_SIZE) != 0) {
	
	draw_set_alpha(hud_barrier_fade_alpha);
	draw_sprite(sprite_get("hud_barrier_fade"), 0, temp_x+74, temp_y+8);
	draw_set_alpha(1);
	
    var in_col = make_color_rgb(255, 202, 94);
    var out_col = make_color_rgb(113, 88, 38);
    var bar_x_offset = 136 + (10 * string_length(string(get_player_damage(player))));
	var bar_y_offset = 6;
    
    draw_set_font(asset_get("medFont"));
    for (var i = -2; i < 3; i += 2) {
        for (var j = -2; j < 3; j += 2) {
            draw_text_color(temp_x+bar_x_offset+i, temp_y+bar_y_offset+j, string(barrier) + "%", out_col, out_col, out_col, out_col, 1);
        }
    }
    draw_text_color(temp_x+bar_x_offset, temp_y+bar_y_offset, string(barrier) + "%", in_col, in_col, in_col, in_col, 1);
    
}

//#endregion

//#region DSpec chest indicator

var on_screen_edge = (temp_x == 20) * 4;
var chest_available = move_cooldown[AT_DSPECIAL] <= 0 && !instance_exists(chest_obj)
draw_sprite_ext(sprite_get("dspec_hudcooldown_handle"), chest_available, temp_x-20+on_screen_edge, temp_y+6, 1, 1, 0, get_player_hud_color(player), 1);
draw_sprite_ext(sprite_get("dspec_hudcooldown"), chest_available, temp_x-30+on_screen_edge, temp_y+12, 1, 1, 0, c_white, 1);

if (dspec_cooldown_hits > 0) {
	draw_set_font(asset_get("fName"));
	var in_col = make_color_rgb(16, 16, 16);
	var str = string(dspec_cooldown_hits);
	for (var i = -2; i <= 2; i += 2) {
		for (var j = -2; j <= 2; j += 2) {
			draw_text_color(temp_x-14+i+on_screen_edge, temp_y+22+j, str, in_col, in_col, in_col, in_col, 1);
		}
	}
	var in_col = make_color_rgb(217, 132, 53);
	draw_text_color(temp_x-14+on_screen_edge, temp_y+22, str, in_col, in_col, in_col, in_col, 1);
}

//#endregion



//#region Training mode utility

if (tmu_state != TMU_INACTIVE) user_event(4);

//#endregion




//#region Item info display

if (debug_display_opened) {
	
	draw_set_alpha(0.4);
	draw_rectangle_color(54, 0, 906, 480, c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
	
	draw_debug_text(60, 466, "TAUNT+DIRECTION: Navigate | ATTACK+TAUNT: Taunt | ATTACK+SPECIAL: Exit")
	draw_debug_text(884, 466, "P" + string(player));
	
	// Item grid info
	if (debug_display_type == 0) {
	
		var debug_x = [60, 260, 360, 480, 600, 700, 900];
		var debug_y = 2;
		
		draw_debug_text(debug_x[0], debug_y, "Name");
		draw_debug_text(debug_x[1], debug_y, "Rarity");
		draw_debug_text(debug_x[2], debug_y, "Type");
		draw_debug_text(debug_x[3], debug_y, "Type 2");
		draw_debug_text(debug_x[4], debug_y, "# Held");
		draw_debug_text(debug_x[5], debug_y, "Incompatible");
		
		debug_y = 30;
		var start_index = debug_display_index;
		var end_index = start_index + debug_display_count;
		for (var ordered_id = start_index; ordered_id < end_index; ordered_id++) {
			
			var item_id = item_id_ordering[ordered_id];
			if (item_id != noone) {
				
				draw_debug_text(debug_x[0], debug_y, item_grid[item_id][IG_NAME]);
				
				var rarity = item_grid[item_id][IG_RARITY]
				if (rarity < 0) rarity_str = negative_rarity_names[-rarity];
				else var rarity_str = rarity_names[rarity];
				draw_debug_text(debug_x[1], debug_y, rarity_str);
				
				var itp = item_grid[item_id][IG_TYPE];
				if (itp < 0 || NUM_ITP_INDICES <= itp) {
					if (itp == -1) var itp_str = legendary_type_name;
					else if (itp == noone) var itp_str = "";
					else var itp_str = "Invalid";
				}
				else var itp_str = item_type_names[itp];
				draw_debug_text(debug_x[2], debug_y, itp_str);
				
				var itp = item_grid[item_id][IG_TYPE2];
				if (itp < 0 || NUM_ITP_INDICES <= itp) {
					if (itp == -1) var itp_str = legendary_type_name;
					else if (itp == noone) var itp_str = "...";
					else var itp_str = "Invalid";
				}
				else var itp_str = item_type_names[itp];
				draw_debug_text(debug_x[3], debug_y, itp_str);
				
				draw_debug_text(debug_x[4], debug_y, string(item_grid[item_id][IG_NUM_HELD]));
				
				var incompat_id = item_grid[item_id][IG_INCOMPATIBLE];
				if (incompat_id == noone) var incompat_str = "...";
				else var incompat_str = item_grid[incompat_id][IG_NAME];
				draw_debug_text(debug_x[5], debug_y, incompat_str);
				
			}
			debug_y += 18;
			
		}
	
	}
	
	// Probability info
	if (debug_display_type == 1) {
		
		draw_debug_text(600, 200, "Uncommons available: " + string(uncommon_pool_size));
		draw_debug_text(600, 220, "Rares remaining: " + string(rares_remaining));
		draw_debug_text(600, 240, "Common legendaries available: " + string(legendary_pool_size[RTY_COMMON]));
		draw_debug_text(600, 260, "Uncommon legendaries available: " + string(legendary_pool_size[RTY_UNCOMMON]));
		draw_debug_text(600, 280, "Rare legendaries available: " + string(legendary_pool_size[RTY_RARE]));
		
		var debug_x = [60, 260, 360, 440, 500];
		var debug_y = 2;
		
		draw_debug_text(debug_x[0], debug_y, "Name");
		draw_debug_text(debug_x[1], debug_y, "Rarity");
		draw_debug_text(debug_x[2], debug_y, "Remaining");
		draw_debug_text(debug_x[3], debug_y, "Weight");
		draw_debug_text(debug_x[4], debug_y, "Value");
		
		debug_y = 30;
		var start_index = debug_display_index;
		var end_index = start_index + debug_display_count;
		for (var ordered_id = start_index; ordered_id < end_index; ordered_id++) {
			
			var item_id = item_id_ordering[ordered_id];
			if (item_id != noone) {
				
				var itp = item_grid[item_id][IG_TYPE];
				var rarity = item_grid[item_id][IG_RARITY];
				var access_index = item_grid[item_id][IG_RANDOMIZER_INDEX];
				draw_debug_text(debug_x[0], debug_y, item_grid[item_id][IG_NAME]);
				
				var rarity = item_grid[item_id][IG_RARITY]
				if (rarity < 0) rarity_str = negative_rarity_names[-rarity];
				else var rarity_str = rarity_names[rarity];
				
				// Case: invalid rarity
				if (rarity < 0 || 2 < rarity) {
					draw_debug_text(debug_x[1], debug_y, rarity_str);
					draw_debug_text(debug_x[2], debug_y, "...");
					draw_debug_text(debug_x[3], debug_y, "...");
					draw_debug_text(debug_x[4], debug_y, "...");
				}
				
				// Case: legendary item
				else if (itp == ITP_LEGENDARY) {
					draw_debug_text(debug_x[1], debug_y, rarity_str + "_L");
					draw_debug_text(debug_x[2], debug_y, string(p_legendary_remaining[rarity][access_index]));
					draw_debug_text(debug_x[3], debug_y, string(p_legendary_available[rarity][access_index]));
					draw_debug_text(debug_x[4], debug_y, "...");
				}
				
				// Standard case
				else {
					draw_debug_text(debug_x[1], debug_y, rarity_str);
					draw_debug_text(debug_x[2], debug_y, string(p_item_remaining[rarity][access_index]));
					draw_debug_text(debug_x[3], debug_y, string(p_item_weights[rarity][access_index]));
					draw_debug_text(debug_x[4], debug_y, string(p_item_values[rarity][access_index]));
				}
			
			}
			debug_y += 18;
			
		}
		
	}
	
	// Stat info
	if (debug_display_type == 2) {
		
		// Stats (labels)
		var debug_x = 190;
		var debug_y = -44;
		
		draw_debug_text(debug_x, debug_y+60, "Walk anim speed: ");
		draw_debug_text(debug_x, debug_y+80, "Dash anim speed: ");
		
		draw_debug_text(debug_x, debug_y+120, "Walk speed: ");
		draw_debug_text(debug_x, debug_y+140, "Walk acceleration: ");
		draw_debug_text(debug_x, debug_y+160, "Initial dash speed: ");
		draw_debug_text(debug_x, debug_y+180, "Dash speed: ");
		draw_debug_text(debug_x, debug_y+200, "Moonwalk acceleration: ");
		
		draw_debug_text(debug_x, debug_y+240, "Max jump HSP: ");
		draw_debug_text(debug_x, debug_y+260, "Max airborne HSP: ");
		
		draw_debug_text(debug_x, debug_y+300, "Jump VSP: ");
		draw_debug_text(debug_x, debug_y+320, "Short hop VSP: ");
		draw_debug_text(debug_x, debug_y+340, "Wall jump VSP: ");
		draw_debug_text(debug_x, debug_y+360, "Max fall VSP: ");
		draw_debug_text(debug_x, debug_y+380, "Fast fall VSP: ");
		draw_debug_text(debug_x, debug_y+400, "Gravity: ");
		
		draw_debug_text(debug_x, debug_y+440, "Double jumps: ");
		draw_debug_text(debug_x, debug_y+460, "Extra dodge frames: ");
		draw_debug_text(debug_x, debug_y+480, "Weight value: ");
		
		// Stats (values)
		var debug_x = 360;
		
		draw_debug_text(debug_x, debug_y+60, string(walk_anim_speed));
		draw_debug_text(debug_x, debug_y+80, string(dash_anim_speed));
		
		draw_debug_text(debug_x, debug_y+120, string(walk_speed));
		draw_debug_text(debug_x, debug_y+140, string(walk_accel));
		draw_debug_text(debug_x, debug_y+160, string(initial_dash_speed));
		draw_debug_text(debug_x, debug_y+180, string(dash_speed));
		draw_debug_text(debug_x, debug_y+200, string(moonwalk_accel));
		
		draw_debug_text(debug_x, debug_y+240, string(max_jump_hsp));
		draw_debug_text(debug_x, debug_y+260, string(air_max_speed));
		
		draw_debug_text(debug_x, debug_y+300, string(jump_speed));
		draw_debug_text(debug_x, debug_y+320, string(short_hop_speed));
		draw_debug_text(debug_x, debug_y+340, string(walljump_vsp));
		draw_debug_text(debug_x, debug_y+360, string(max_fall));
		draw_debug_text(debug_x, debug_y+380, string(fast_fall));
		draw_debug_text(debug_x, debug_y+400, string(gravity_speed));
		
		draw_debug_text(debug_x, debug_y+440, string(max_djumps));
		draw_debug_text(debug_x, debug_y+460, string(dodge_duration_add));
		draw_debug_text(debug_x, debug_y+480, string(knockback_adj));
		
		// Commando properties
		var debug_x = 480;
		draw_debug_text(debug_x, 210, "Move speed stacks: " + string(move_speed));
		draw_debug_text(debug_x, 230, "Attack speed stacks: " + string(attack_speed));
		draw_debug_text(debug_x, 250, "Critical strike checks: " + (critical_active ? "Active" : "Inactive"));
		
	}
	
	// Item granter
	if (debug_display_type == 3) {
		
		var item_id = item_id_ordering[debug_display_index];
		if (item_id == noone) exit;
		
		var debug_x = 130;
		var debug_y = 220;
		draw_sprite_ext(sprite_get("item"), item_id, debug_x, debug_y, 2, 2, 0, c_white, 1);
		
		debug_x += 60;
		debug_y -= 10;
		draw_debug_text(debug_x, debug_y, item_grid[item_id][IG_NAME]);
		draw_debug_text(debug_x, debug_y+24, "TAUNT+SPECIAL: Add item");
		draw_debug_text(debug_x, debug_y+40, "TAUNT+SHIELD: Remove item");
		
		debug_x = 480;
		debug_y = 230;
		draw_debug_text(debug_x, debug_y, "Attacks are disabled while this panel is open.");
		
		draw_set_alpha(0.7);
		
		debug_x = 144;
		debug_y = 280;
		var temp_display_index = debug_display_index;
		for (var i = 1; i <= 3; i++) {
			temp_display_index++;
			if (temp_display_index >= array_length(item_id_ordering)) temp_display_index = 0;
			if (item_id_ordering[temp_display_index] == noone) temp_display_index++;
			draw_sprite(sprite_get("item"), item_id_ordering[temp_display_index], debug_x, debug_y);
			debug_y += 30;
		}
		
		debug_x = 144;
		debug_y = 190;
		var temp_display_index = debug_display_index;
		for (var i = 1; i <= 3; i++) {
			temp_display_index--;
			if (temp_display_index < 0) temp_display_index = array_length(item_id_ordering) - 1;
			if (item_id_ordering[temp_display_index] == noone) temp_display_index--;
			draw_sprite(sprite_get("item"), item_id_ordering[temp_display_index], debug_x, debug_y);
			debug_y -= 30;
		}
		
		draw_set_alpha(1);
		
	}
	
}
//#endregion


//#region Death Messages //This needs to be moved from here to a different file, and have the position adjusted. Ideally it'd still be centered on the camera, not to the stage, but idk how to do that.

draw_set_font( font_get("_rfont") );
draw_set_halign( fa_center );
draw_text_color( 480, 100, string(death_message_pick), c_white, c_white, c_white, c_white, (final_death_timer * 2) / 50);


//#endregion
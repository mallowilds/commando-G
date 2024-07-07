

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








//#region Item info display

if (should_debug) {
	
	draw_set_alpha(0.4);
	draw_rectangle_color(0, 0, 840, 480, c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
	
	// Item grid info
	if (debug_display_type == 0) {
	
		var debug_x = [0, 200, 300, 420, 540, 640, 840];
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
		
		draw_debug_text(540, 200, "Uncommons available: " + string(uncommon_pool_size));
		draw_debug_text(540, 220, "Rares remaining: " + string(rares_remaining));
		draw_debug_text(540, 240, "Common legendaries available: " + string(legendary_pool_size[RTY_COMMON]));
		draw_debug_text(540, 260, "Uncommon legendaries available: " + string(legendary_pool_size[RTY_UNCOMMON]));
		draw_debug_text(540, 280, "Rare legendaries available: " + string(legendary_pool_size[RTY_RARE]));
		
		var debug_x = [0, 200, 300, 380, 440];
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
	
}

//#endregion
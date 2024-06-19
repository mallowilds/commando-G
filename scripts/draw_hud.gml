// debug text, add more if need be
if "should_debug" in self {
    if (should_debug) {
        draw_debug_text(temp_x - 70, temp_y - 90, "Previous State: "+get_state_name(prev_state));
        draw_debug_text(temp_x - 70, temp_y - 75, "State: "         +get_state_name(state));
        draw_debug_text(temp_x - 70, temp_y - 60, "State Timer: "   +string(state_timer));
        draw_debug_text(temp_x - 70, temp_y - 45, "Attack: "        +string(attack));
        draw_debug_text(temp_x - 70, temp_y - 30, "Window: "        +string(window));
        draw_debug_text(temp_x - 70, temp_y - 15, "Window Timer: "  +string(window_timer));
        draw_debug_text(temp_x + 70, temp_y - 45, "HSP: "   +string(round(hsp)));
        draw_debug_text(temp_x + 70, temp_y - 30, "VSP: "   +string(round(vsp)));
        draw_debug_text(temp_x + 70, temp_y - 15, "Image Index: "   +string(image_index));
    }
}



if ("inventory_list" not in self) exit;

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
			draw_text_color(temp_x-14+i, temp_y+22+j, str, in_col, in_col, in_col, in_col, 1);
		}
	}
	var in_col = make_color_rgb(217, 132, 53);
	draw_text_color(temp_x-14, temp_y+22, str, in_col, in_col, in_col, in_col, 1);
}

//#endregion
/*// debug text, add more if need be
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

// draw_hud.gml
// draws the text "Hello" aligned to the left using "medFont" above the player's hud
draw_sprite(sprite_get("item_bgpanel"), 0, temp_x, temp_y - 320)
draw_sprite_ext(sprite_get("item_brilliant"), 0, temp_x + 12, temp_y - 318, 1, 1, 0, c_black, 0.5)
draw_sprite(sprite_get("item_brilliant"), 0, temp_x + 10, temp_y - 322)
draw_set_font( font_get("_rfont") );
draw_set_halign( fa_center );
draw_text_transformed( temp_x + 180, temp_y - 300, "Brilliant Behemoth", 1, 1, 0 );
draw_set_font( asset_get("fName") );
draw_set_halign( fa_center );
draw_text_color( temp_x + 180, temp_y - 264, "All of your attacks explode!", c_black, c_black, c_black, c_black, 1 );
draw_text_color( temp_x + 182, temp_y - 264, "All of your attacks explode!", c_white, c_white, c_white, c_white, 1 );
*/

if ("inventory_list" not in self) exit;

var x_spacing = clamp(72 - 6 * array_length(inventory_list), 26, 44);
var y_spacing = 22;

hud_x = temp_x - 10;
hud_y = temp_y - 44 - (y_spacing * floor((array_length(inventory_list)-1)/8));

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


// Barrier (temp)
var barrier = brooch_barrier + heart_barrier + jewel_barrier + aegis_barrier;
if (barrier > 0) draw_debug_text(temp_x+32, temp_y+24, string(floor(barrier)));
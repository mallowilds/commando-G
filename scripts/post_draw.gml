


//#region NSpecial beam

if (state == clamp(state, PS_ATTACK_AIR, PS_ATTACK_GROUND) && attack == AT_NSPECIAL) {
    if (window == 2 || window == 3) {
        draw_sprite_ext(sprite_get("nspecproj"), window_timer >= 2, x-8*spr_dir, y-100, spr_dir, 1, 0, c_white, 1);
    }
    else if (window == 4) {
        draw_sprite_ext(sprite_get("nspecproj"), 4+window_timer/2, x-8*spr_dir, y-100, spr_dir, 1, 0, c_white, 1);
    }
}

//#endregion





//#region Lightweight particle drawing
for (var i = 0; i < ds_list_size(lfx_list); i++) {
    var lfx = ds_list_find_value(lfx_list, i);
    if (lfx.lfx_foreground) {
    	var lfx_image_index = lfx.lfx_lifetime * (sprite_get_number(lfx.lfx_sprite_index) / lfx.lfx_max_lifetime);
    	draw_sprite_ext(lfx.lfx_sprite_index, lfx_image_index, lfx.lfx_x, lfx.lfx_y, lfx.lfx_spr_dir, 1, 0, c_white, 1 );
    }
}
//#endregion


//#region Bustling Fungus

if (bungus_active) {
    if (bungus_vis_timer < 10) draw_sprite(sprite_get("vfx_item_fung"), bungus_vis_timer/3, bungus_vis_x, bungus_vis_y);
    else draw_sprite(sprite_get("vfx_item_fung"), 3, bungus_vis_x, bungus_vis_y);
}

else if (bungus_vis_timer < 3) {
    draw_sprite(sprite_get("vfx_item_fung"), 4, bungus_vis_x, bungus_vis_y);
}

//#endregion


//#region Photon Jetpack fuel

if (pjetpack_hud_alpha > 0) {
    draw_sprite_ext(asset_get("mech_steambar_spr"), 31*(pjetpack_vis_fuel/pjetpack_fuel_max), x-32, y-char_height-hud_offset-30, 2, 2, 0, c_white, pjetpack_hud_alpha);
}

//#endregion

//#region Barrier indicator

var barrier = floor(brooch_barrier + heart_barrier + jewel_barrier + aegis_barrier);

if (barrier > 0 && get_local_setting(SET_HUD_SIZE) != 0) {
    var in_col = make_color_rgb(255, 202, 94);
    var out_col = make_color_rgb(113, 88, 38);
    var bar_x_offset = (get_local_setting(SET_HUD_SIZE) == 1 ? 8 : 6) + (get_local_setting(SET_HUD_SIZE) == 1 ? 4 : 6) * (string_length(string(get_player_damage(player))));
    var bar_y_offset = (get_local_setting(SET_HUD_NAMES) ? 64 : 46) + (get_local_setting(SET_HUD_SIZE) == 1 ? 0 : 4);
    
    draw_set_font(asset_get("fName"));
    for (var i = -2; i < 3; i += 2) {
        for (var j = -2; j < 3; j += 2) {
            draw_text_color(x+bar_x_offset+i, y-char_height-hud_offset-bar_y_offset+j, string(barrier) + "%", out_col, out_col, out_col, out_col, 1);
        }
    }
    draw_text_color(x+bar_x_offset, y-char_height-hud_offset-bar_y_offset, string(barrier) + "%", in_col, in_col, in_col, in_col, 1);
}

//#endregion
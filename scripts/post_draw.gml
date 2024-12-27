

if (!init_complete) exit;

//#region NSpecial beam

if (state == clamp(state, PS_ATTACK_AIR, PS_ATTACK_GROUND) && attack == AT_NSPECIAL) {
    if (window == 3) {
        draw_sprite_ext(nspec_proj_index, (window_timer>=2) + 2*(num_loops%2), x-16*spr_dir, y-100, spr_dir, 1, 0, c_white, 1);
    }
    else if (window == 4) {
        draw_sprite_ext(nspec_proj_index, 4+window_timer/2, x-16*spr_dir, y-100, spr_dir, 1, 0, c_white, 1);
    }
}

//#endregion

//#region Tri-shop selector
if (instance_exists(chest_obj) && chest_obj.state == 32 && chest_obj.trishop_vis_timer >= 0) with chest_obj {
    var progress = clamp(trishop_vis_timer / 5, 0, 1)
    var _x = x;
    var _y = other.y-28;
    
    draw_sprite_ext(sprite_get("trishop_bg_lines"), 0, _x, _y, 2, 2, 0, c_white, progress);
    
    draw_sprite_ext(sprite_get("item"), trishop_loot[0], _x-(64*progress), _y-(52*progress), 2*progress, 2, 0, c_white, 1);
    draw_sprite_ext(sprite_get("item"), trishop_loot[1], _x,               _y-(66*progress), 2*progress, 2, 0, c_white, 1);
    draw_sprite_ext(sprite_get("item"), trishop_loot[2], _x+(64*progress), _y-(52*progress), 2*progress, 2, 0, c_white, 1);
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
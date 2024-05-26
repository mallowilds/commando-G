

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
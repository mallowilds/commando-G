

switch state {
    
    // Fireman's Boots ~ Fire
    case 01:
    case 02:
        if (get_match_setting(SET_HITBOX_VIS)) draw_sprite_ext(sprite_get("item_firetile_mask"), 0, x, y, 1, 1, 0, c_white, 0.5);
        break;
    
    // Trophy Hunter's Tricorn ~ Trophy
    case 55:
    case 56:
    case 57:
        draw_sprite_ext(icon, icon_index, x, y, icon_scale, icon_scale, 0, c_white, 1);
        break;
    
    // Legendary Spark ~ Thunderbolt
    case 81:
        var pcol = get_player_hud_color(player);
        draw_rectangle_color(x-20, y-1000, x+20, y, pcol, pcol, pcol, pcol, false);
        break;
    case 82:
    case 83:
        if (state_timer >= 5) break;
        var pcol = get_player_hud_color(player);
        draw_rectangle_color(x-24, y-1000, x+24, y, pcol, pcol, pcol, pcol, false);
        break;
    case 84:
        if (state_timer >= 5) break;
        var pcol = get_player_hud_color(player);
        draw_rectangle_color(x-32, y-1000, x+32, y, pcol, pcol, pcol, pcol, false);
        break;
    
}
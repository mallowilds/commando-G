switch(state) { // use this one for changing sprites and animating
    case 00: // Request arrow (awaiting shipment)
        draw_sprite_ext(sprite_get("dspecial_arrows"), (state_timer < 4) ? state_timer / 2 : 2, x, view_get_yview(), 1, 1, 0, get_player_hud_color(player), 1);
        break;
    case 01: // Request arrow (small)
        draw_sprite_ext(sprite_get("dspecial_arrows"), (state_timer < 3) ? 3 + state_timer : 6, x, view_get_yview(), 1, 1, 0, get_player_hud_color(player), 1);
        break;
    case 02: // Request arrow (large)
        draw_sprite_ext(sprite_get("dspecial_arrows"), (state_timer < 2) ? 7 : 8, x, view_get_yview(), 1, 1, 0, get_player_hud_color(player), 1);
        break;
    
    // Small chest
    case 10: // Init
        
        break;
    case 11: // Fall
        
        break;
    case 12: // Idle
    case 13: // Opening
        draw_sprite_ext(sprite_get("dspec_smallchest_outline"), 0, x, y, 1, 1, 0, c_white, outline_alpha);
        break;
    case 14: // Despawning
        break;
      
    // Large chest
    case 20: // Init
        break;
    case 21: // Fall
        break;
    case 22: // Idle
    case 23: // Opening
        draw_sprite_ext(sprite_get("dspec_largechest_outline"), 0, x, y, 1, 1, 0, c_white, outline_alpha);
        break;
    case 24: // Despawning
        
        break;
    
}
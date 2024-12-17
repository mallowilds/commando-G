switch(state) { // use this one for changing sprites and animating
    case 00: // Request arrow (awaiting shipment)
        draw_sprite_ext(sprite_get("dspecial_arrows"), (state_timer < 4) ? state_timer / 2 : 2, x, view_get_yview()+10+(2*sin(state_timer/5/pi)), 1, 1, 0, get_player_hud_color(player), 1);
        break;
    case 01: // Request arrow (small)
        draw_sprite_ext(sprite_get("dspecial_arrows"), (state_timer < 3) ? 3 + state_timer : 6, x, view_get_yview()+10+(4*sin(state_timer/5/pi)), 1, 1, 0, get_player_hud_color(player), 1);
        break;
    case 02: // Request arrow (large)
        draw_sprite_ext(sprite_get("dspecial_arrows"), (state_timer < 2) ? 7 : 8, x, view_get_yview()+10+(6*sin(state_timer/5/pi)), 1, 1, 0, get_player_hud_color(player), 1);
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
    
    // Trishop
    case 30: // Init
    case 31: // Fall
    case 32: // Idle
        if (trishop_vis_timer >= 0) {
            var progress = clamp(trishop_vis_timer / 5, 0, 1)
            
            draw_sprite_ext(sprite_get("trishop_bg_lines"), 0, x, y-22, 2, 2, 0, c_white, progress);
            draw_sprite_ext(sprite_get("trishop_bg_sidefill"), 0, x, y-22, 2, 2, 0, c_white, trishop_vis_opacities[0]*progress);
            draw_sprite_ext(sprite_get("trishop_bg_centerfill"), 0, x, y-22, 2, 2, 0, c_white, trishop_vis_opacities[1]*progress);
            draw_sprite_ext(sprite_get("trishop_bg_sidefill"), 0, x, y-22, -2, 2, 0, c_white, trishop_vis_opacities[2]*progress);
            
            draw_sprite_ext(sprite_get("item"), trishop_loot[0], x-22-(60*progress), y-20-(76*progress), 2, 2, 0, c_white, 1);
            draw_sprite_ext(sprite_get("item"), trishop_loot[1], x-22,               y-20-(90*progress), 2, 2, 0, c_white, 1);
            draw_sprite_ext(sprite_get("item"), trishop_loot[2], x-22+(60*progress), y-20-(76*progress), 2, 2, 0, c_white, 1);
        }
    case 33: // Opening
    case 34: // Despawning
        draw_debug_text(x, y, "This is a trishop!!");
        break;
    
    
}
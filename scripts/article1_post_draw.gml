switch(state) { // use this one for changing sprites and animating
    case 00: // Request arrow (awaiting shipment)
        
        break;
    case 01: // Request arrow (small)
        draw_sprite_ext(sprite_get("dspecial_arrows"), 0, x, view_get_yview(), 1, 1, 0, c_white, 1);
        break;
    case 02: // Request arrow (large)
        draw_sprite_ext(sprite_get("dspecial_arrows"), 1, x, view_get_yview(), 1, 1, 0, c_white, 1);
        break;
    
    // Small chest
    case 10: // Init
        
        break;
    case 11: // Fall
        
        break;
    case 12: // Idle
        break;
    case 13: // Opening
        break;
    case 14: // Despawning
        break;
      
    // Large chest
    case 20: // Init
        break;
    case 21: // Fall
        break;
    case 22: // Idle
        
        break;
    case 23: // Opening
        
        break;
    case 24: // Despawning
        
        break;
    
}

// Commando Chests

/* STATE LIST
 *
 * 0x - Orbital state
 * 00 - Request arrow (awaiting shipment)
 * 01 - Request arrow (small)
 * 02 - Request arrow (large)
 * 03 - Jammed (parried state)
 * 
 * 1x - Small chest
 * 10 - Init
 * 11 - Falling
 * 12 - Idle 
 * 13 - Opening
 * 14 - Despawning
 *
 * 2x - Large chest
 * 20 - Init
 * 21 - Falling
 * 22 - Idle 
 * 23 - Opening
 * 24 - Despawning
 * 
 * 3x - "Extreme Reinforcements" (Classified Access Codes)
 * 
 */

state_timer += 1;

switch(state) { // use this one for doing actual article behavior
        
    //#region Orbital State
    case 00: // Request arrow (awaiting shipment)
        if (state_timer >= 300) { // Advance to small arrow after 5s
            set_state(01);
        }
        break;
    case 01: // Request arrow (large)
        if (state_timer >= 300) { // Advance to large arrow after 5s
            set_state(02);
        }
        break;
    case 02: // Request arrow (large)
        // No Classified Access Codes: forcibly drop large chest after 2s
        if (player_id.item_grid[player_id.ITEM_CODES][player_id.IG_NUM_HELD] < 1 && state_timer >= 120) { 
            set_state(20);
        }
        // Classified Access Codes: drop bomb after 5s
        else if (player_id.item_grid[player_id.ITEM_CODES][player_id.IG_NUM_HELD] >= 1 && state_timer >= 300) { 
            set_state(30);
            // not yet implemented, so~
            should_die = true;
        }
        break;
    case 03: // Jammed (parried state)
        if (state_timer >= 300) { // Finish after 5s
            should_die = true;
        }
        break;
    //#endregion
    
    
    //#region Small chest
    
    //#endregion
    
    
    //#region Large chest
    case 20: // Init
        target_y = y;
        y = get_stage_data(SD_TOP_BLASTZONE_Y);
        vsp = 20;
        set_state(21);
        // Spawn hitbox
        break;
    case 21: // Fall
        if (y + vsp > target_y) {
            mask_index = sprite_get("dspec_largechest"); // todo: make an actual mask
            ignores_walls = false;
            can_be_grounded = true;
        }
        if (!free) {
            set_state(22);
        }
        break;
    case 22: // Idle
        if (free) vsp = clamp(vsp+0.5, vsp, 8);
        break;
    case 23: // Opening
        if (state_timer >= 120) set_state(24);
        break;
    case 24: // Despawning
        should_die = true;
        break;
    //#endregion
    
}

switch(state) { // use this one for changing sprites and animating
    case 00: // Request arrow (awaiting shipment)
        sprite_index = sprite_get("dspecial_arrows");
        image_index = 0;
        break;
    case 01: // Request arrow (small)
        sprite_index = sprite_get("dspecial_arrows");
        image_index = 0;
        break;
    case 02: // Request arrow (large)
        sprite_index = sprite_get("dspecial_arrows");
        image_index = 1;
        break;
        
    // Large chest
    case 20: // Init
        sprite_index = sprite_get("null");
        break;
    case 21: // Fall
        sprite_index = sprite_get("dspec_largechest");
        image_index = 0;
        break;
    case 22: // Idle
        sprite_index = sprite_get("dspec_largechest");
        image_index = 0;
        break;
    case 23: // Opening
        sprite_index = sprite_get("dspec_largechest");
        image_index = 1;
        break;
    case 24: // Despawning
        sprite_index = sprite_get("dspec_largechest");
        image_index = 1;
        break;
    
}
// don't forget that articles aren't affected by small_sprites

if (should_die || y > get_stage_data(SD_BOTTOM_BLASTZONE_Y)) { //despawn and exit script
    player_id.chest_obj = noone;
    instance_destroy();
    exit;
}


#define set_state
var _state = argument0;
state = _state;
state_timer = 0;
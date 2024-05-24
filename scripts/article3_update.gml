
// article3_update - runs every frame the article exists
// Miscellaneous objects

/*STATE LIST

- Default (-1): Failed initialization

FIREMAN'S BOOTS ~ FIRE
- 00: Initialization
- 01: Idle
- 02: Despawn

*/



switch state {
    
    
    //#region Fireman's Boots ~ Fire
    case 00:
        sprite_index = asset_get("fire_grnd1");
        mask_index = sprite_get("item_firetile_mask");
        state = 01;
        state_timer = 0;
        do_hitbox = false;
        break;
        
    case 01:
        image_index += 0.3;
        if (state_timer > 20) {
            state = 02;
            state_timer = 0;
            sprite_index = asset_get("fire_grnd1_leave");
            image_index = 0;
        }
        var fire = self;
        with oPlayer if (player != other.player && !burned) {
            with hurtboxID if (place_meeting(x, y, fire)) {
                fire.do_hitbox = true;
            }
        }
        if (do_hitbox) {
            do_hitbox = false;
            create_hitbox(AT_EXTRA_1, 1, x, y-17);
        }
        break
        
    case 02:
        image_index += 0.3
        if (image_index >= 6) {
            instance_destroy();
            exit;
        }
        with oPlayer {
            if (player != other.player && !burned && place_meeting(x, y, other)) {
                other.do_hitbox = true;
            }
        }
        if (do_hitbox) {
            do_hitbox = false;
            create_hitbox(AT_EXTRA_1, 1, x, y-17);
        }
        break;
        
    //#endregion
    
    
    
    
    //#region Failed initialization
    default:
        print_debug("Error: article 3 was not properly initialized")
        instance_destroy();
        exit;
    //#endregion
    
}


// Make time progress
state_timer++;


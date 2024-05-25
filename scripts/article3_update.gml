
// article3_update - runs every frame the article exists
// Miscellaneous objects

/*STATE LIST

- Default (-1): Failed initialization

FIREMAN'S BOOTS ~ FIRE
- 00: Initialization
- 01: Idle
- 02: Despawn

MONSTER TOOTH ~ ORB
- 10: Initialization
- 11: Flying out
- 12: Idle
- 13: Approaching target

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
    
    //#region Monster Tooth
    case 10:
        sprite_index = sprite_get("item_tooth_orb");
        mask_index = sprite_get("item_tooth_orb");
        state = 11;
        state_timer = 0;
        orb_target = noone;
        orb_consumed = false;
        break;
        
    case 11:
        image_index += 0.3;
        vsp += 0.6;
        if (!free) {
            state = 12;
            state_timer = 0;
        }
        
        var min_distance = -1;
        if (state_timer > 6) with (oPlayer) {
            var distance = point_distance(x, y, other.x, other.y);
            if (state_cat != SC_HITSTUN && distance < 20 && (min_distance == -1 || distance < min_distance)) {
                min_distance = distance;
                other.orb_target = self;
                other.state = 13;
                other.state_timer = 0;
            }
        }
        
        break;
        
    case 12:
        if (hsp > 0) hsp = clamp(hsp - 0.6, 0, hsp);
        else if (hsp < 0) hsp = clamp(hsp + 0.6, hsp, 0);
        vsp = (state_timer > 6 ? sin(state_timer*pi/30) : -6 + state_timer);
        
        var min_distance = -1;
        with (oPlayer) {
            var distance = point_distance(x, y, other.x, other.y);
            if (!clone && distance < 70 && (min_distance == -1 || distance < min_distance)) {
                min_distance = distance;
                other.orb_target = self;
                other.state = 13;
                other.state_timer = 0;
            }
        }
        
        break;
    
    case 13:
        if (!instance_exists(orb_target)) {
            orb_target = noone;
            state = 11;
            state_timer = 0;
        }
        
        can_be_grounded = false;
        ignores_walls = true;
        dir = point_direction(x, y, orb_target.x, orb_target.y-orb_target.char_height/2);
        hsp = lengthdir_x(10, dir);
        vsp = lengthdir_y(10, dir);
        
        with oPlayer {
            if (place_meeting(x, y, other)) {
                take_damage(player, other.player, -1);
                if ("aegis_barrier" in self && "item_grid" in self) aegis_barrier += aegis_ratio * item_grid[42][IG_NUM_HELD];
                other.orb_consumed = true;
            }
        }
        
        if (orb_consumed) {
            sound_play(asset_get("mfx_timertick_holy"));
            instance_destroy();
            exit;
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


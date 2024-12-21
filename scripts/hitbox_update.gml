//

// Homing missiles
if (attack == AT_EXTRA_1) {
    
    // Ceremonial daggers (delayed homing, manual hitpause)
    if (hbox_num == 7) {
        if (bashed || target_obj.state == PS_DEAD || target_obj.state == PS_RESPAWN) homing = false;
        if (hitbox_timer < delay) {
            hit_priority = 0;
            homing = true;
            depth = player_id.depth+1;
            draw_xscale = 1;
            var sp = max(9-hitbox_timer, 2);
            hsp = lengthdir_x(sp, proj_angle);
            vsp = lengthdir_y(sp, proj_angle);
            if (hitbox_timer+2 == delay) {
                sound_play(sound_get("cm_dagger_swing"));
                spawn_hit_fx(x, y, HFX_CLA_PLASMA_PLUS);
            }
        } else if (homing) {
            hit_priority = 1;
            var target_y = target_obj.y - floor(target_obj.char_height/2);
            var dist = point_distance(x, y, target_obj.x, target_y);
            var sp = min(20, dist);
            proj_angle = point_direction(x, y, target_obj.x, target_y);
            hsp = lengthdir_x(sp, proj_angle);
            vsp = lengthdir_y(sp, proj_angle);
            if (dist <= 30) homing = false;
        } else {
            if (place_meeting(x, y, asset_get("par_block"))) {
                destroyed_next = true;
                spawn_hit_fx(x, y, hit_effect);
                sound_play(sound_effect);
            }
        }
    }
    
    // ATG (extremely basic, but must have its stats set externally when spawned)
    if (hbox_num == 8) {
        draw_xscale = 1;
        if (bashed || target_obj.state == PS_DEAD || target_obj.state == PS_RESPAWN) homing = false;
        if (homing) {
            var target_y = target_obj.y - floor(target_obj.char_height/2);
            var dist = point_distance(x, y, target_obj.x, target_y);
            var sp = min(20, dist);
            proj_angle = point_direction(x, y, target_obj.x, target_y);
            hsp = lengthdir_x(sp, proj_angle);
            vsp = lengthdir_y(sp, proj_angle);
            if (dist <= 30) homing = false;
        } else {
            if (place_meeting(x, y, asset_get("par_block"))) {
                destroyed_next = true;
                spawn_hit_fx(x, y, hit_effect);
                sound_play(sound_effect);
            }
        }
    }
    
    // Fireworks (delayed homing, capped rotational speed)
    if (hbox_num == 9) {
        draw_xscale = 1;
        hit_priority = (hitbox_timer >= 5);
        if (hitbox_timer == 1) {
            vsp = -16;
            delay = 6 + random_func(3, 10, true);
        }
        if (bashed || target_obj == noone || target_obj.state == PS_DEAD || target_obj.state == PS_RESPAWN) homing = false;
        if (homing && hitbox_timer >= delay) {
            var target_y = target_obj.y - floor(target_obj.char_height/2);
            var sp = 16;
            var dir = point_direction(x, y, target_obj.x, target_y);
            var diff = angle_difference(proj_angle, dir);
            if (diff >= 0) proj_angle -= min(diff, 6+(hitbox_timer/10));
            else proj_angle -= max(diff, -6-(hitbox_timer/10));
            
            hsp = lengthdir_x(sp, proj_angle);
            vsp = lengthdir_y(sp, proj_angle);
            
            if (hitbox_timer >= delay + 10 && point_distance(x, y, target_obj.x, target_y) < 40) {
                var incidence_angle = abs(angle_difference(dir, proj_angle))
                if (85 <= incidence_angle && incidence_angle <= 95) homing = false;
            }
        } else if (!homing) {
            if (place_meeting(x, y, asset_get("par_block"))) {
                destroyed_next = true;
                spawn_hit_fx(x, y, hit_effect);
                sound_play(sound_effect);
            }
        }
    }
    
}
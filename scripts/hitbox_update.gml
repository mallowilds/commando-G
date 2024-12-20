//

if (attack == AT_EXTRA_1) {
    
    if (hbox_num == 7) {
        if (target_obj.state == PS_DEAD || target_obj.state == PS_RESPAWN) homing = false;
        if (hitbox_timer < delay) {
            homing = true;
            depth = player_id.depth+1;
            draw_xscale = 1;
            var sp = max(9-hitbox_timer, 2);
            hsp = lengthdir_x(sp, proj_angle);
            vsp = lengthdir_y(sp, proj_angle);
            if (hitbox_timer+2 == delay) {
                sound_play(asset_get("sfx_swipe_medium1"));
                spawn_hit_fx(x, y, HFX_CLA_PLASMA_PLUS);
            }
        } else if (homing) {
            var target_y = target_obj.y - floor(target_obj.char_height/2);
            var dist = point_distance(x, y, target_obj.x, target_y);
            var sp = min(20, dist);
            proj_angle = point_direction(x, y, target_obj.x, target_y);
            hsp = lengthdir_x(sp, proj_angle);
            vsp = lengthdir_y(sp, proj_angle);
            if (dist <= 30) homing = false;
        }
    }
    
    if (hbox_num == 8) {
        draw_xscale = 1;
        if (target_obj.state == PS_DEAD || target_obj.state == PS_RESPAWN) homing = false;
        if (homing) {
            var target_y = target_obj.y - floor(target_obj.char_height/2);
            var dist = point_distance(x, y, target_obj.x, target_y);
            var sp = min(20, dist);
            proj_angle = point_direction(x, y, target_obj.x, target_y);
            hsp = lengthdir_x(sp, proj_angle);
            vsp = lengthdir_y(sp, proj_angle);
            if (dist <= 30) homing = false;
        }
    }
    
}
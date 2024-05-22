//a

//multihit variables
hitbox_multihits = false;
hitbox_multihit_rate = 10;
hitbox_multihit_max = 3;

with(player_id) {
    if (get_hitbox_value(other.attack,other.hbox_num,HG_PROJECTILE_MULTIHIT)) {
        other.hitbox_multihits = true;
        other.hitbox_multihit_rate = get_hitbox_value(other.attack,other.hbox_num, HG_PROJECTILE_MULTIHIT_RATE);
        other.hitbox_multihit_max = get_hitbox_value(other.attack,other.hbox_num, HG_PROJECTILE_MAX_HITS);
    }
}

if (hitbox_multihits) {
    hitbox_hit_player_timers = [0,0,0,0,0];
    hitbox_hit_player_count = [0,0,0,0,0];
    proj_old_player = player;
    proj_old_hitpause = hitpause;
    proj_hitstop = 0;
    proj_hitpause = 0;
    proj_old_hsp = 0;
    proj_old_vsp = 0;
    proj_old_img_spd = 0;
}
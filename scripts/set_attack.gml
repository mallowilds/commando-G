//a

if (attack == AT_TAUNT) {
    if (up_down) attack = utaunt_index;
    else if (down_down) attack = dtaunt_index;
    else attack = ntaunt_index;
}

if (attack == AT_USTRONG) attack = ustrong_index;

if (attack == AT_DSPECIAL) {
    if (!instance_exists(chest_obj)) chest_obj = noone;
    else attack = AT_DSPECIAL_2;
}

//reset number of windows in case of a grab
reset_attack_value(attack,AG_NUM_WINDOWS);

// detect/apply once-per-air limit to attacks
if (get_attack_value(attack,AG_ATTACK_AIR_LIMIT)) {
    if (attack_air_limit[attack]) {
        move_cooldown[attack] = 2;
    } else {
        attack_air_limit[attack] = true;
        attack_air_limit_ver = true;
    }
}

// reset grab variables on new attack
// if your grab uses different attack indexes, you may want to add additional
// checks to prevent accidental grab releases
grabbed_player_obj = noone; 
grabbed_player_relative_x = 0;
grabbed_player_relative_y = 0;



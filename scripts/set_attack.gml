

if (debug_display_opened && attack_pressed && taunt_pressed) attack = AT_TAUNT;

if (attack == AT_TAUNT) {
    if (up_down) attack = utaunt_index;
    else if (down_down) attack = dtaunt_index;
    else attack = ntaunt_index;
}

if (attack == AT_FSTRONG) attack = fstrong_index;

if (attack == AT_USTRONG) attack = ustrong_index;

if (attack == AT_FSPECIAL && (free || state == PS_JUMPSQUAT)) attack = AT_FSPECIAL_AIR;
if (prev_attack == AT_FSPECIAL_AIR) hsp = clamp(hsp, -leave_ground_max, leave_ground_max);

if (attack == AT_DSPECIAL) {
    if (!instance_exists(chest_obj)) chest_obj = noone;
    else if (chest_obj.state % 10 == 2 && chest_obj.state != 2) {
        attack = AT_DSPECIAL_2;
        var radius = (chest_obj.is_large) ? DSPEC_LCHEST_RADIUS : DSPEC_SCHEST_RADIUS;
        if (point_distance(x, y, chest_obj.x, chest_obj.y) >= radius) move_cooldown[AT_DSPECIAL_2] = 2;
        halt_for_trishop = false;
    }
    else if (chest_obj.state != clamp(chest_obj.state, 1, 2)) {
        move_cooldown[AT_DSPECIAL] = 2;
    }
}

if (attack != AT_TAUNT && debug_display_opened && debug_display_type == 3 && move_cooldown[attack] < 2) move_cooldown[attack] = 2;
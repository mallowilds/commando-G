
do_turbine_recolor = false; // it's easiest to just set it here...

if (debug_display_opened && attack_pressed && taunt_pressed) attack = AT_TAUNT;

if (attack == AT_JAB) {
    //num_loops = attack_speed;
    num_loops = 1;
    set_hitbox_value(AT_JAB, 1, HG_HITSTUN_MULTIPLIER, 1);
    set_hitbox_value(AT_JAB, 2, HG_HITSTUN_MULTIPLIER, 1);
    set_hitbox_value(AT_JAB, 3, HG_HITSTUN_MULTIPLIER, 1);
    set_hitbox_value(AT_JAB, 4, HG_HITSTUN_MULTIPLIER, 1);
    set_hitbox_value(AT_JAB, 1, HG_FORCE_FLINCH, 1);
	set_hitbox_value(AT_JAB, 2, HG_FORCE_FLINCH, 1);
}

if (attack == AT_TAUNT) {
    if (up_down) attack = utaunt_index;
    else if (down_down) attack = dtaunt_index;
    else attack = ntaunt_index;
}

if (attack == AT_FSTRONG) attack = fstrong_index;

if (attack == AT_USTRONG) attack = ustrong_index;

if (attack == AT_FSPECIAL && (free || state == PS_JUMPSQUAT)) attack = AT_FSPECIAL_AIR;
if (prev_attack == AT_FSPECIAL_AIR) hsp = clamp(hsp, -leave_ground_max, leave_ground_max);
if attack == AT_FSPECIAL && item_grid[ITEM_AFTERBURNER][IG_NUM_HELD] > 0 {
	set_attack_value(AT_FSPECIAL, AG_SPRITE                         , sprite_get("fspec_hardlight"));
}

if (attack == AT_DSPECIAL) {
    if (!instance_exists(chest_obj)) chest_obj = noone;
    else if (chest_obj.state % 10 == 2 && chest_obj.state != 2) {
        attack = AT_DSPECIAL_2;
        var radius = (chest_obj.is_large) ? DSPEC_LCHEST_RADIUS : DSPEC_SCHEST_RADIUS;
        if (point_distance(x, y, chest_obj.x, chest_obj.y) >= radius) move_cooldown[AT_DSPECIAL_2] = 2;
        halt_for_trishop = false;
    }
    else if (chest_obj.state != clamp(chest_obj.state, 1, 2) && move_cooldown[AT_DSPECIAL] == 0 && item_grid[ITEM_CODES][IG_NUM_HELD] <= 0) {
    	sound_play(asset_get("mfx_tut_fail"), false, false, 1, 0.5);
        move_cooldown[AT_DSPECIAL] = 45; // Hacky anti-spam measure, gets reset by article1 when it's ready
    }
}

if (attack != AT_TAUNT && debug_display_opened && debug_display_type == 3 && move_cooldown[attack] < 2) move_cooldown[attack] = 2;

// Crit handling
if (attack == AT_DTILT || attack == AT_UAIR || attack == AT_DAIR || attack == AT_USTRONG) {
    
    var do_enhanced_crits = snakeeyes_active || item_grid[ITEM_SCOPE][IG_NUM_HELD] > 0;
    
    if (do_enhanced_crits) enable_enhanced_crit(attack, 2, 3, 4);
    else enable_basic_crit(attack, 2, 3, 4);
    
}
else if (attack == AT_USTRONG_2) {
    
    var do_enhanced_crits = snakeeyes_active || item_grid[ITEM_SCOPE][IG_NUM_HELD] > 0;
    
    if (do_enhanced_crits) enable_enhanced_crit(attack, 7, 8, 9);
    else enable_basic_crit(attack, 7, 8, 9);
    
}
snakeeyes_active = false;

// Handle attack speed
if (attack_speed != get_attack_value(attack, AG_PREV_ATTACK_SPEED)) {
	var num_windows = get_attack_value(attack, AG_NUM_WINDOWS);
	set_attack_value(attack, AG_PREV_ATTACK_SPEED, attack_speed);
	
	// Init real window lengths if needed
	for (var i = 1; i <= num_windows; i++) {
		if (get_window_value(attack, i, AG_WINDOW_REAL_LENGTH) == 0) {
			set_window_value(attack, i, AG_WINDOW_REAL_LENGTH, get_window_value(attack, i, AG_WINDOW_LENGTH));
		} else {
			break;
		}
	}
	
	var real_as = attack_speed - 1;
	if (real_as >= 15) real_as *= 2; // extra dstrong breakpoint at 15 stacks for funsies
	
	// Set modified window lengths
	for (var i = 1; i <= num_windows; i++) {
		if (get_window_value(attack, i, AG_WINDOW_USES_ATTACK_SPEED)) {
			var real_length = get_window_value(attack, i, AG_WINDOW_REAL_LENGTH);
			var mod_length = ceil(real_length * (1-(real_as / (real_as + 3))));
			set_window_value(attack, i, AG_WINDOW_LENGTH, mod_length);
			set_window_value(attack, i, AG_WINDOW_SFX_FRAME, max(mod_length-1, 0));
			print_debug(mod_length);
		}
	}
}



#define enable_enhanced_crit(atk, normal, enhanced, ignition)
set_hitbox_value(atk, normal, HG_WINDOW, 99);
reset_hitbox_value(atk, enhanced, HG_WINDOW);

reset_hitbox_value(atk, enhanced, HG_DAMAGE);
reset_hitbox_value(atk, enhanced, HG_KNOCKBACK_SCALING);

var enhanced_dmg = get_hitbox_value(atk, enhanced, HG_DAMAGE);
var enhanced_kbs = get_hitbox_value(atk, enhanced, HG_KNOCKBACK_SCALING);
if (item_grid[ITEM_SNAKEEYES][IG_NUM_HELD] > 1 && snakeeyes_active) {
    var mult = item_grid[ITEM_SNAKEEYES][IG_NUM_HELD]-1;
    enhanced_dmg += SCOPE_DAMAGE_ADD * mult;
    enhanced_kbs += SCOPE_KBS_ADD * mult;
}
if (item_grid[ITEM_SCOPE][IG_NUM_HELD] > 0) {
    var mult = (item_grid[ITEM_SCOPE][IG_NUM_HELD]-1+snakeeyes_active); // A little extra reward for stacking these effects
	enhanced_dmg += SCOPE_DAMAGE_ADD * mult;
	enhanced_kbs += SCOPE_KBS_ADD * mult;
}
set_hitbox_value(atk, enhanced, HG_DAMAGE, enhanced_dmg);
set_hitbox_value(atk, enhanced, HG_KNOCKBACK_SCALING, enhanced_kbs);

if (item_grid[ITEM_IGNITION][IG_NUM_HELD] > 0) {
    set_hitbox_value(atk, enhanced, HG_HIT_LOCKOUT, 0);
    reset_hitbox_value(atk, ignition, HG_DAMAGE);
    reset_hitbox_value(atk, ignition, HG_KNOCKBACK_SCALING);
    var ignition_dmg = get_hitbox_value(atk, ignition, HG_DAMAGE);
    var ignition_kbs = get_hitbox_value(atk, ignition, HG_KNOCKBACK_SCALING);
    if (snakeeyes_active) {
        var mult = item_grid[ITEM_SNAKEEYES][IG_NUM_HELD];
        ignition_dmg += SCOPE_DAMAGE_ADD * mult;
        ignition_kbs += SCOPE_KBS_ADD * mult;
    }
    if (item_grid[ITEM_SCOPE][IG_NUM_HELD] > 0) {
        var mult = item_grid[ITEM_SCOPE][IG_NUM_HELD]+snakeeyes_active;
    	ignition_dmg += SCOPE_DAMAGE_ADD * mult;
    	ignition_kbs += SCOPE_KBS_ADD * mult;
    }
    ignition_kbs += IGNITION_KBS_SCALE * item_grid[ITEM_IGNITION][IG_NUM_HELD];
    set_hitbox_value(atk, ignition, HG_DAMAGE, ignition_dmg);
    set_hitbox_value(atk, ignition, HG_KNOCKBACK_SCALING, ignition_kbs);
} else {
    reset_hitbox_value(atk, enhanced, HG_HIT_LOCKOUT);
}


#define enable_basic_crit(atk, normal, enhanced, ignition)
reset_hitbox_value(atk, normal, HG_WINDOW);
set_hitbox_value(atk, enhanced, HG_WINDOW, 99);

reset_hitbox_value(atk, ignition, HG_DAMAGE);
reset_hitbox_value(atk, ignition, HG_KNOCKBACK_SCALING);
var ignition_kbs = get_hitbox_value(atk, ignition, HG_KNOCKBACK_SCALING);
ignition_kbs += IGNITION_KBS_SCALE * item_grid[ITEM_IGNITION][IG_NUM_HELD];
set_hitbox_value(atk, ignition, HG_KNOCKBACK_SCALING, ignition_kbs);

if (item_grid[ITEM_IGNITION][IG_NUM_HELD] > 0) set_hitbox_value(atk, normal, HG_HIT_LOCKOUT, 0);
else reset_hitbox_value(atk, normal, HG_HIT_LOCKOUT);
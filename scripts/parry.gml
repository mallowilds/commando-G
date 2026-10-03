blocktimer = 100;

if (fshield_damage != 0) {
    var _y = y-10;
    spawn_hit_fx(x, _y, HFX_ZET_SHINE_BIG_FG);
    with oPlayer {
        var can_hit = get_match_setting(SET_TEAMATTACK) ? self != other : get_player_team(player) != get_player_team(other.player);
        if (can_hit && collision_circle(other.x, _y, other.FSHIELD_RADIUS, hurtboxID, true, false)) {
            burned = true;
            burnt_id = other;
            burn_timer = 150 - 30*other.fshield_damage;
            burned_color = 0;
            init_shader();
            sound_play(asset_get("sfx_burnapplied"));
        }
    }
}

var deus_count = item_grid[ITEM_DEUS][IG_NUM_HELD];
var deus_weights = DEUS_WEIGHTS; // for RCF's sake
var deus_icons = DEUS_ICONS;
var new_effects = [];

// Apply new effects, reconstructing probability weights for each
for (var i = 0; i < deus_count; i++) {
    // Get sum of weights
    var total_weights = 0;
    for (var j = 0; j < DEUS_NUM_EFFECTS; j++) {
        if (!deus_active_arr[j]) total_weights += deus_weights[j];
    }
    
    if (total_weights == 0) break;
    var value = random_func(i, total_weights, true);

    var weight_sum = 0;
    
    for (var j = 0; j < DEUS_NUM_EFFECTS; j++) {
        if (!deus_active_arr[j]) {
            weight_sum += deus_weights[j];
            if (weight_sum > value) {
                deus_active_arr[j] = 1;
                array_push(new_effects, j);
                deus_active++;
                break;
            }
        }
    }
}

// Spawn visuals/sfx for new effects
var l = array_length(new_effects)
if (l > 0) {
    spawn_hit_fx(x, y, HFX_SHO_COIN_CAPTURE);
    //spawn_hit_fx(x, y-26, HFX_SHO_HORN_HIT);
    var fx = spawn_hit_fx(x, y-10, fx_deusparry_hit);
    fx.depth = depth-1;
    sound_play(asset_get("sfx_frog_gong_hit"));
    sound_play(sound_get("cm_sex_machina"));
}
if (l == 1) {
    var deus_warn = instance_create(x, y-50, "obj_article3");
    deus_warn.state = 92;
    deus_warn.item_id = deus_icons[new_effects[0]];
    deus_warn.wait_time = 0;
}
else if (l > 1) {
    // Spawn indicators in a circle
    var angle = spr_dir == -1 ? -150 : -30;
    print_debug(angle)
    for (var i = 0; i < l; i++) {
        var _x = round(x+lengthdir_x(40, angle));
        var _y = round(y-50+lengthdir_y(20, angle));
        var deus_warn = instance_create(_x, _y, "obj_article3");
        deus_warn.state = 92;
        deus_warn.item_id = deus_icons[new_effects[i]];
        deus_warn.wait_time = 0;
        angle += (360 / l)
    }
}
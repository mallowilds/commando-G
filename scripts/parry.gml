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
                deus_active++;
                break;
            }
        }
    }
}
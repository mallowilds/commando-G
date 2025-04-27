
if ("other_player_id" not in self || "commando_status_state" not in self || "init_complete" not in other_player_id) exit;

// Ol' Lopper
if (commando_status_state[other_player_id.ST_LOPPER] == 1) {
    var i = clamp(7 * commando_status_counter[other_player_id.ST_LOPPER] / other_player_id.LOPPER_AWAIT_TIME, 0, 7);
    draw_sprite_ext(other_player_id.spr_lopper_start, i, x, y+floor(char_height/3), 2*spr_dir, 2, 0, c_white, 1);
}

if ("other_player_id" not in self || "commando_status_state" not in self || "init_complete" not in other_player_id) exit;

// Sticky Bomb
if (commando_status_state[other_player_id.ST_STICKY] == 1) {
    draw_sprite_ext(other_player_id.spr_sticky, 0, x-(10*spr_dir), y-char_height+6, spr_dir*2, 2, 0, c_white, 1);
}

// Shattering Justice
if (commando_status_state[other_player_id.ST_SHATTERED] > 0) {
    draw_debug_text(x, y-14, "shattered");
}

if ("commando_status_state" not in self || !instance_exists(other_player_id)) exit;

// Bleed effect
if (commando_status_state[other_player_id.ST_BLEED] > 0) {
    draw_debug_text(x, y, "bleeding");
}

// Ol' Lopper
if (commando_status_state[other_player_id.ST_LOPPER] == 1) {
    draw_debug_text(x, y-14, "lopping");
}
else if (commando_status_state[other_player_id.ST_LOPPER] == 2) {
    draw_debug_text(x, y-14, "lopped");
}
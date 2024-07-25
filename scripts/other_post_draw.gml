
if ("commando_status_state" not in self || !instance_exists(other_player_id) || "ST_BLEED" not in other_player_id) exit;

// Sticky Bomb
if (commando_status_state[other_player_id.ST_STICKY] > 0) {
    var text = (commando_status_state[other_player_id.ST_STICKY] == 1) ? "sticky'd" : "stickproof"
    draw_debug_text(x, y+14, text);
}

// Ol' Lopper
if (commando_status_state[other_player_id.ST_LOPPER] == 1) {
    draw_debug_text(x, y-14, "lopping");
}
else if (commando_status_state[other_player_id.ST_LOPPER] == 2) {
    draw_debug_text(x, y-14, "lopped");
}

// Shattering Justice
if (commando_status_state[other_player_id.ST_SHATTERED] > 0) {
    draw_debug_text(x, y-14, "shattered");
}
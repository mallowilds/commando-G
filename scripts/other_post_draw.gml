
if ("commando_status_state" not in self || !instance_exists(other_player_id)) exit;

// Bleed effect
if (commando_status_state[other_player_id.ST_BLEED] > 0) {
    draw_debug_text(x, y, "bleeding");
}
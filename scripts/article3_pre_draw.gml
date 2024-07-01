//


if (30 < state && state < 40) {
    draw_set_alpha(0.15);
    draw_circle_color(x, y+radius_y_offset, warbanner_radius, get_player_hud_color(player), get_player_hud_color(player), false);
    draw_set_alpha(1);
    draw_circle_color(x, y+radius_y_offset, warbanner_radius, get_player_hud_color(player), get_player_hud_color(player), true);
}
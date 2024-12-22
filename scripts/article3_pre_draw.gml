//

if (20 < state && state < 30) {
    var hi = history_index;
    
    if (state == 23) {
        var segments = floor((10-state_timer)/3);
        var radii = [];
        var half = (segments-1)/2;
        var j = 0;
        for (var i = 0; i < segments+1; i++) {
            array_push(radii, j);
            if (i < half) j++;
            else if (i > half) j--;
        }
    } else {
        var segments = 5;
        var radii = [5, 4, 3, 2, 1, 0];
    }
    
    for (var i = 0; i < segments; i++) {
        var hi2 = (hi-2);
        if (hi2 < 0) hi2 += history_len;
        var x1 = x_history[hi]
        var y1 = y_history[hi];
        var d1 = dir_history[hi];
        var x2 = x_history[hi2];
        var y2 = y_history[hi2];
        var d2 = dir_history[hi2];
        var rf = radii[i];
        var rb = radii[i+1];
        
        var xs = [
            x1 + lengthdir_x(rf, d1-90),
            x1 + lengthdir_x(rf, d1+90),
            x2 + lengthdir_x(rb, d2-90),
            x2 + lengthdir_x(rb, d2+90),
        ]
        
        var ys = [
            y1 + lengthdir_y(rf, d1-90),
            y1 + lengthdir_y(rf, d1+90),
            y2 + lengthdir_y(rb, d2-90),
            y2 + lengthdir_y(rb, d2+90),
        ]
        
        draw_triangle_color(xs[0], ys[0], xs[1], ys[1], xs[2], ys[2], trail_color, trail_color, trail_color, false);
        draw_triangle_color(xs[3], ys[3], xs[1], ys[1], xs[2], ys[2], trail_color, trail_color, trail_color, false);
        hi -= 2;
        if (hi < 0) hi += history_len;
    }
}

if (30 < state && state < 40) {
    draw_set_alpha(0.15);
    draw_circle_color(x, y+radius_y_offset, warbanner_radius, get_player_hud_color(player), get_player_hud_color(player), false);
    draw_set_alpha(1);
    draw_circle_color(x, y+radius_y_offset, warbanner_radius, get_player_hud_color(player), get_player_hud_color(player), true);
}
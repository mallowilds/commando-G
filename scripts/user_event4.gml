// Training mode utility draw (called from draw_hud.gml)

var tmu_x = temp_x;
var tmu_y = 0;
var rows = 3;
var columns = 3;

switch tmu_state {
    
    case 0: // TMU_OPENING
        break;
    
    case 1: // TMU_ITEM
        var loc = tmu_display_row*columns;
        var draw_row = 0;
        var draw_column = 0;
        var endpoint = array_length(tmu_item_panel_contents);
        
        while (loc < endpoint && loc < (rows+tmu_display_row) * columns) {
            draw_sprite_ext(sprite_get("item"), tmu_item_panel_contents[loc], 20+tmu_x+60*draw_column, 40+tmu_y+60*draw_row, 2, 2, 0, c_white, 1);
            loc++;
            draw_column++;
            if (draw_column >= rows) {
                draw_column = 0;
                draw_row++;
            }
        }
        
        var pcol = get_player_hud_color(player);
        var cursor_x = 10+tmu_x+60*tmu_column;
        var cursor_y = 30+tmu_y+60*(tmu_row);
        draw_rectangle_color(cursor_x, cursor_y, cursor_x+60, cursor_y+60, pcol, pcol, pcol, pcol, true);
        
        var category_text = (tmu_item_panel < 3) ? rarity_names[tmu_item_panel] : legendary_type_name;
        var text_width = string_length(category_text) * 8; // temp
        draw_debug_text(tmu_x+100-(text_width/2), tmu_y+8, category_text);
        
        var item_text = item_grid[tmu_item_id][IG_NAME];
        var text_width = string_length(item_text) * 8; // temp
        draw_debug_text(tmu_x+100-(text_width/2), tmu_y+230, item_text);
        
        break;
    
    case 2: // TMU_ITEM_CLOSING
        break;
    
}
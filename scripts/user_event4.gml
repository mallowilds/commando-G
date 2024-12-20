// Training mode utility draw (called from draw_hud.gml)

var tmu_x = temp_x;
var tmu_y = tmu_y_offset;
var rows = 3;
var columns = 3;

switch tmu_state {
    
    case 0: // TMU_OPENING
        break;
    
    case 1: // TMU_ITEM
    case 2: // TMU_ITEM_CLOSING
        var loc = tmu_display_row*columns;
        var draw_row = 0;
        var draw_column = 0;
        var endpoint = array_length(tmu_item_panel_contents);
        var show_add = false;
        
        while (loc < endpoint && loc < (rows+tmu_display_row) * columns) {
            draw_sprite_ext(sprite_get("_tmu_panel_square"), 0, 14+tmu_x+58*draw_column, 32+tmu_y+58*draw_row, 2, 2, 0, c_white, 1);
            if (draw_row > 0 && draw_column > 0) draw_sprite_ext(sprite_get("_tmu_screwjoint"), 0, 6+tmu_x+58*draw_column, 24+tmu_y+58*draw_row, 2, 2, 0, c_white, 1)
            
            var iid = tmu_item_panel_contents[loc];
            draw_sprite_ext(sprite_get("item"), iid, 22+tmu_x+58*draw_column, 42+tmu_y+58*draw_row, 2, 2, 0, c_white, 1);
            var draw_shadowed = false;
            if (item_grid[iid][IG_TYPE] == ITP_LEGENDARY && item_grid[iid][IG_RARITY] != RTY_COMMON) {
                if (rarity == RTY_RARE) draw_shadowed = (rares_remaining == 0 || item_grid[iid][IG_TYPE] >= 1);
                else draw_shadowed = item_grid[iid][IG_TYPE] >= uncommon_limit;
            } else {
                var rarity = item_grid[iid][IG_RARITY]
                var index = item_grid[iid][IG_RANDOMIZER_INDEX];
                if (rarity == RTY_COMMON) draw_shadowed = (item_grid[iid][IG_NUM_HELD] >= 10);
                else if (rarity == RTY_RARE && rares_remaining == 0) draw_shadowed = true;
                else draw_shadowed = (p_item_weights[rarity][index] <= 0);
            }
            if (draw_shadowed) {
                gpu_set_fog(true, c_black, depth, depth);
                draw_sprite_ext(sprite_get("item"), iid, 22+tmu_x+58*draw_column, 42+tmu_y+58*draw_row, 2, 2, 0, c_white, 0.4);
                gpu_set_fog(false, c_white, 0, 0);
            }
            if (tmu_item_id == iid) show_add = !draw_shadowed;
            
            loc++;
            draw_column++;
            if (draw_column >= rows) {
                draw_column = 0;
                draw_row++;
            }
        }
        
        var pcol = get_player_hud_color(player);
        var cursor_x = 14+tmu_x+58*tmu_column;
        var cursor_y = 32+tmu_y+58*tmu_row;
        draw_sprite_ext(sprite_get("_tmu_hover_square"), 0, cursor_x, cursor_y, 2, 2, 0, pcol, 1);
        
        draw_sprite_ext(sprite_get("_tmu_panel_top"), 0, 14+tmu_x, tmu_y, 2, 2, 0, c_white, 1);
        var category_text = (tmu_item_panel < 3) ? rarity_names[tmu_item_panel] : legendary_type_name;
        var text_width = string_length(category_text) * 7; // temp
        draw_debug_text(tmu_x+96-floor(text_width/2), tmu_y+14, category_text);
        
        draw_sprite_ext(sprite_get("_tmu_panel_bottom"), 0, 14+tmu_x, 210+tmu_y, 2, 2, 0, c_white, 1);
        var item_text = item_grid[tmu_item_id][IG_NAME];
        var text_width = string_length(item_text) * 7; // temp
        draw_debug_text(tmu_x+96-floor(text_width/2), tmu_y+222, item_text);
        
        
        if (show_add) {
            draw_sprite_ext(sprite_get("_tmu_prompt_add"), 0, 28+tmu_x, 238+tmu_y, 2, 2, 0, c_white, 1);
        }
        
        if (item_grid[tmu_item_id][IG_NUM_HELD] > 0) {
            draw_sprite_ext(sprite_get("_tmu_prompt_remove"), 0, 100+tmu_x, 238+tmu_y, 2, 2, 0, c_white, 1);
        }
        
        break;
    
}
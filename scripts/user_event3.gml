// Training mode utility update

tmu_timer++;

var rows = 3;
var columns = 3;

switch tmu_state {
    
    case 0: // TMU_OPENING
        fill_panel_contents(tmu_item_panel);
        set_tmu_state(TMU_ITEM);
        break;
    
    case 1: // TMU_ITEM
        
        var panel_size = array_length(tmu_item_panel_contents);
        
        tmu_row += (down_pressed - up_pressed);
        tmu_column += (right_pressed - left_pressed);
        
        // Rows: stop at either end
        if (tmu_row < 0) {
            if (tmu_display_row > 0) tmu_display_row--;
            tmu_row = 0;
        }
        if (tmu_row >= rows) {
            if ((tmu_display_row+rows)*columns < panel_size) tmu_display_row++;
            tmu_row--;
        }
        
        // Columns: upon leaving bounds, move to other panel
        if (tmu_column < 0) {
            tmu_column = columns-1;
            tmu_item_panel--;
            if (tmu_item_panel < 0) tmu_item_panel = tmu_item_panel_max;
            fill_panel_contents(tmu_item_panel);
            panel_size = array_length(tmu_item_panel_contents);
        }
        if (tmu_column >= columns) {
            tmu_column = 0;
            tmu_item_panel++;
            if (tmu_item_panel > tmu_item_panel_max) tmu_item_panel = 0;
            fill_panel_contents(tmu_item_panel);
            panel_size = array_length(tmu_item_panel_contents);
        }
        
        // Finishing: force cursor to a valid space if necessary
        tmu_selected = tmu_column + (tmu_row+tmu_display_row)*columns;
        if (tmu_selected >= panel_size) {
            var disjoint = tmu_selected - (panel_size-1); // distance from a valid position
            var offset = ceil(disjoint / columns); // number of rows to jump up to reach a valid position
            tmu_row -= offset;
            if (tmu_row < 0) { // if this jump places the cursor offscreen, move the display position up to match
                tmu_display_row += tmu_row;
                tmu_row = 0;
            }
            tmu_selected = tmu_column + (tmu_row+tmu_display_row)*columns;
        }
        
        // Process commands
        tmu_item_id = tmu_item_panel_contents[tmu_selected];
        
        if (attack_pressed && item_grid[tmu_item_id][IG_NUM_HELD] < 10) {
            clear_button_buffer(PC_ATTACK_PRESSED);
            new_item_id = tmu_item_id;
            force_grant_item = true;
            user_event(1);
        }
        
        else if (special_pressed) {
            clear_button_buffer(PC_SPECIAL_PRESSED);
            new_item_id = tmu_item_id;
            force_remove_item = true;
            user_event(1);
        }
        
        else if (shield_pressed) {
            // change to info panel
        }
        
        else if (taunt_pressed) {
            set_state(TMU_ITEM_CLOSING);
        }
        
        
        
        break;
    
    case 2: // TMU_ITEM_CLOSING
        
        set_tmu_state(TMU_INACTIVE);
        break;
    
}



#define fill_panel_contents(panel_num)

    tmu_item_panel_contents = [];
    var i = ordering_start_indices[panel_num];
    var endpoint = array_length(item_id_ordering);
    
    while (i < endpoint && item_id_ordering[i] != noone) {
        array_push(tmu_item_panel_contents, item_id_ordering[i]);
        i++;
    }

#define set_tmu_state(in_state)
    tmu_state = in_state;
    tmu_timer = 0;
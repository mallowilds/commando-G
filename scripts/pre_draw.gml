// use this to draw stuff

/*
//temp, i just wanna see how it looks - Shear, if you could, the timer should be moved to update.gml (obviously) 
if blocktimer > 0 {
    blocktimer = blocktimer - 3;
    if blocktimer < 0 blocktimer = 0
    print(blocktimer)
    draw_sprite_ext(sprite_get("blocked"), 0, x - 60, y - 115 + (blocktimer/25), 1, 1, 0, c_white, blocktimer/100)
}*/


// obj_article2 pre_draw (because text draw functions are unstable in article code)
with (obj_article2) if (other == player_id) {
    
    switch state {
        
        case 1:
            
            draw_set_alpha(draw_alpha);
            
            draw_sprite(sprite_get("item_bgpanel"), 0, x, y - 20)
            draw_sprite_ext(sprite_get("item"), item_id, x + 12, y - 18, 2, 2, 0, c_black, 0.5 * draw_alpha)
            draw_sprite_ext(sprite_get("item"), item_id, x + 10, y - 22, 2, 2, 0, c_white, draw_alpha)
            
            draw_set_font( font_get("_rfont") );
            draw_set_halign( fa_center );
            draw_text_color( x + 180, y, player_id.item_grid[item_id][player_id.IG_NAME], c_white, c_white, c_white, c_white, draw_alpha );
            
            draw_set_font( asset_get("fName") );
            draw_set_halign( fa_center );
            draw_text_color( x + 180, y + 36, player_id.item_grid[item_id][player_id.IG_DESC], c_black, c_black, c_black, c_black, draw_alpha );
            draw_text_color( x + 182, y + 36, player_id.item_grid[item_id][player_id.IG_DESC], c_white, c_white, c_white, c_white, draw_alpha );
            
            draw_set_alpha(draw_flash);
            gpu_set_fog(1, c_white, 0, 1);
            draw_sprite(sprite_get("item_bgpanel"), 0, x, y - 20);
            gpu_set_fog(0, c_white, 0, 1);
            
            draw_set_alpha(1);
            
            break;
        
    }
    
}
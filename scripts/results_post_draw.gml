
// Retrieve item smuggler
if ("inventory_list" not in self) {
    inventory_list = noone;
    with obj_article3 if player == other.player {
         other.inventory_list = inventory_list;
    }
    // TODO: handle item priority
}

// Draw items
if (inventory_list != noone) {
    // TODO: actual checks
    for (var i = 0; i < 35; i++) {
        draw_sprite_ext(sprite_get("portrait_item"), i, portrait_x, portrait_y, 2, 2, 0, c_white, 1);
    }
}
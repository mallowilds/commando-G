
// Commando Chests

/* STATE LIST
 *
 * 0x - Orbital state
 * 00 - Request arrow (awaiting shipment)
 * 01 - Request arrow (small)
 * 02 - Request arrow (large)
 * 03 - Jammed (parried state)
 * 
 * 1x - Small chest
 * 10 - Init
 * 11 - Falling
 * 12 - Idle 
 * 13 - Opening
 * 14 - Despawning
 *
 * 2x - Large chest
 * 20 - Init
 * 21 - Falling
 * 22 - Idle 
 * 23 - Opening
 * 24 - Despawning
 * 
 * 3x - "Extreme Reinforcements" (Classified Access Codes)
 * 
 */

if (hitstop > 0) {
    if (instance_exists(hbox)) {
        hbox.hitbox_timer--;
        hbox.vsp = 0;
    }
    if (instance_exists(land_vfx)) land_vfx.step_timer--;
    exit;
}

state_timer += 1;

switch(state) { // use this one for doing actual article behavior
        
    //#region Orbital State
    case 00: // Request arrow (awaiting shipment)
        if (state_timer >= 300) { // Advance to small arrow after 5s
            set_state(01);
        }
        break;
    case 01: // Request arrow (large)
        if (state_timer >= 300) { // Advance to large arrow after 5s
            set_state(02);
        }
        break;
    case 02: // Request arrow (large)
        // No Classified Access Codes: forcibly drop large chest after 2s
        if (player_id.item_grid[player_id.ITEM_CODES][player_id.IG_NUM_HELD] < 1 && state_timer >= 120) { 
            set_state(20);
        }
        // Classified Access Codes: drop bomb after 5s
        else if (player_id.item_grid[player_id.ITEM_CODES][player_id.IG_NUM_HELD] >= 1 && state_timer >= 300) { 
            set_state(30);
            // not yet implemented, so~
            should_die = true;
        }
        break;
    case 03: // Jammed (parried state)
        if (state_timer >= 300) { // Finish after 5s
            should_die = true;
        }
        break;
    //#endregion
    
    
    //#region Small chest
    case 10: // Init
        target_y = y;
        y = get_stage_data(SD_TOP_BLASTZONE_Y);
        vsp = 25;
        set_state(11);
        hbox = create_hitbox(AT_DSPECIAL, 1, x, y-54);
        hbox.vsp = vsp;
        hbox.owner_chest = self;
        sound_play(player_id.s_cfall);
        break;
    case 11: // Fall
        if (y + vsp > target_y) {
            mask_index = sprite_get("dspec_smallchest"); // todo: make an actual mask
            ignores_walls = false;
            can_be_grounded = true;
        }
        if (!free) {
            set_state(12);
            land_vfx = spawn_hit_fx(x, y, player_id.fx_small_chest_land);
            land_vfx.depth = depth-1;
            hbox.destroyed = true;
            hbox = noone;
            var land_hbox = create_hitbox(AT_DSPECIAL, 2, x, y-16);
            land_hbox.owner_chest = self;
            sound_play(player_id.s_cland);
        }
        else {
            hbox.hitbox_timer--;
            hbox.vsp = vsp;
        }
        break;
    case 12: // Idle
        if (free) vsp = clamp(vsp+0.5, vsp, 8);
        if (point_distance(x, y, player_id.x, player_id.y) < player_id.DSPEC_SCHEST_RADIUS) outline_alpha = clamp(outline_alpha + 0.2, 0, 1);
        else outline_alpha = clamp(outline_alpha - 0.2, 0, 1);
        break;
    case 13: // Opening
        if (outline_alpha > 0) outline_alpha -= 0.2;
        if (state_timer == 1) sound_play(sound_get("cm_smallchest"));
        if (state_timer == 20) {
            var rarity_weights = [player_id.SCHEST_C_WEIGHT, player_id.SCHEST_U_WEIGHT, player_id.SCHEST_R_WEIGHT]
            if (player_id.uncommons_remaining <= 0) rarity_weights[1] = 0;
            if (player_id.rares_remaining <= 0) rarity_weights[2] = 0;
            var rarity = random_weighted_roll(player_id.item_seed, rarity_weights);
            player_id.item_seed = (player_id.item_seed + 1) % 200;
            
            var item = instance_create(x, y-10, "obj_article3");
            item.state = 20;
            item.rarity = rarity;
        }
        if (state_timer >= 35) set_state(14);
        break;
    case 14: // Despawning
        if (state_timer >= 60) should_die = true;
        break;
    //#endregion
    
    
    //#region Large chest
    case 20: // Init
        target_y = y;
        y = get_stage_data(SD_TOP_BLASTZONE_Y);
        vsp = 25;
        set_state(21);
        hbox = create_hitbox(AT_DSPECIAL, 3, x, y-50);
        hbox.vsp = vsp;
        hbox.owner_chest = self;
        sound_play(player_id.s_cfall);
        break;
    case 21: // Fall
        if (y + vsp > target_y) {
            mask_index = sprite_get("dspec_largechest"); // todo: make an actual mask
            ignores_walls = false;
            can_be_grounded = true;
        }
        if (!free) {
            set_state(22);
            land_vfx = spawn_hit_fx(x, y, player_id.fx_large_chest_land);
            land_vfx.depth = depth-1;
            hbox.destroyed = true;
            hbox = noone;
            var land_hbox = create_hitbox(AT_DSPECIAL, 4, x, y-16);
            land_hbox.owner_chest = self;
            sound_play(player_id.s_cland);
        }
        else {
            hbox.hitbox_timer--;
            hbox.vsp = vsp;
        }
        break;
    case 22: // Idle
        if (free) vsp = clamp(vsp+0.5, vsp, 8);
        if (point_distance(x, y, player_id.x, player_id.y) < player_id.DSPEC_LCHEST_RADIUS) outline_alpha = clamp(outline_alpha + 0.2, 0, 1);
        else outline_alpha = clamp(outline_alpha - 0.2, 0, 1);
        break;
    case 23: // Opening
        if (outline_alpha > 0) outline_alpha -= 0.2;
        if (state_timer == 1) sound_play(sound_get("cm_largechest"));
        if (state_timer == 20) {
            var rarity_weights = [player_id.LCHEST_C_WEIGHT, player_id.LCHEST_U_WEIGHT, player_id.LCHEST_R_WEIGHT]
            if (player_id.uncommons_remaining <= 0) rarity_weights[1] = 0;
            if (player_id.rares_remaining <= 0) rarity_weights[2] = 0;
            var rarity = random_weighted_roll(player_id.item_seed, rarity_weights);
            player_id.item_seed = (player_id.item_seed + 1) % 200;
            
            var item = instance_create(x, y-10, "obj_article3");
            item.state = 20;
            item.rarity = rarity;
        }
        if (state_timer >= 54) set_state(24);
        break;
    case 24: // Despawning
        if (state_timer >= 60) should_die = true;
        break;
    //#endregion
    
}

switch(state) { // use this one for changing sprites and animating
    case 00: // Request arrow (awaiting shipment)
        sprite_index = sprite_get("null");
        image_index = 0;
        break;
    case 01: // Request arrow (small)
        sprite_index = sprite_get("null");
        image_index = 0;
        break;
    case 02: // Request arrow (large)
        sprite_index = sprite_get("null");
        image_index = 1;
        break;
    
    // Small chest
    case 10: // Init
        sprite_index = sprite_get("null");
        break;
    case 11: // Fall
        sprite_index = sprite_get("dspec_smallchest");
        image_index = 0;
        break;
    case 12: // Idle
        sprite_index = sprite_get("dspec_smallchest");
        image_index = 1 + ((state_timer < 6) ? state_timer / 3 : 2);
        break;
    case 13: // Opening
        sprite_index = sprite_get("dspec_smallchest");
        image_index = 5 + (state_timer / 5);
        break;
    case 14: // Despawning
        sprite_index = sprite_get("dspec_smallchest");
        image_index = 11;
        break;
      
    // Large chest
    case 20: // Init
        sprite_index = sprite_get("null");
        break;
    case 21: // Fall
        sprite_index = sprite_get("dspec_largechest");
        image_index = 0;
        break;
    case 22: // Idle
        sprite_index = sprite_get("dspec_largechest");
        image_index = 1 + ((state_timer < 6) ? state_timer / 3 : 2);
        break;
    case 23: // Opening
        sprite_index = sprite_get("dspec_largechest");
        image_index = 5 + (state_timer / 4.5);
        break;
    case 24: // Despawning
        sprite_index = sprite_get("dspec_largechest");
        image_index = 16;
        break;
    
}
// don't forget that articles aren't affected by small_sprites

if (should_die || y > get_stage_data(SD_BOTTOM_BLASTZONE_Y)) { //despawn and exit script
    player_id.chest_obj = noone;
    instance_destroy();
    exit;
}


#define set_state
var _state = argument0;
state = _state;
state_timer = 0;


#define random_weighted_roll(seed, weight_array)
// Picks one index from a given array of weights.
// Each index's odds of being picked is (weight at index) / (total of weights in array)
// Uses random_func_2, so 0 <= seed <= 200.
var array_len = array_length(weight_array);
var total_weight = 0;
for (var i = 0; i < array_len; i++) {
	total_weight += weight_array[i];
}
// on each loop, check if rand_int is less than the sum of all previous weights
var rand_int = random_func_2(seed, total_weight, true);
for (var i = 0; i < array_len; i++) {
	if (rand_int < weight_array[i]) {
		// print_debug("In: " + string(weight_array) + ", Out: " + string(i));
		return i;
	}
	rand_int -= weight_array[i];
}
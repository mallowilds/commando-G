
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
 * 3x - Tri-Shop
 * 30 - Init
 * 31 - Falling
 * 32 - Idle 
 * 33 - Opening
 * 34 - Despawning
 * 36 - Falling (large)
 * 
 * 5x - "Extreme Reinforcements" (Classified Access Codes)
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
            set_state(50);
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
        is_large = false;
        
        var roll = random_func(3, 100, true) + 1;
        if (roll <= player_id.trishop_odds) {
        	set_state(31);
        	var rarity_weights = [player_id.SCHEST_C_WEIGHT, player_id.SCHEST_U_WEIGHT, player_id.SCHEST_R_WEIGHT];
        	if (player_id.uncommon_pool_size <= 2) rarity_weights[1] = 0;
            if (player_id.rares_remaining <= 0) rarity_weights[2] = 0;
            trishop_rarity = random_weighted_roll(player_id.item_seed, rarity_weights);
            player_id.item_seed = (player_id.item_seed + 1) % 200;
        }
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
        else if (instance_exists(hbox)) {
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
            if (player_id.uncommon_pool_size <= 0) rarity_weights[1] = 0;
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
        is_large = true;
        
        var roll = random_func(player_id.item_seed, 100, true) + 1;
        player_id.item_seed = (player_id.item_seed + 1) % 200;
        if (roll <= player_id.trishop_odds) {
        	set_state(31);
        	var rarity_weights = [player_id.LCHEST_C_WEIGHT, player_id.LCHEST_U_WEIGHT, player_id.LCHEST_R_WEIGHT];
        	if (player_id.uncommon_pool_size <= 2) rarity_weights[1] = 0;
            if (player_id.rares_remaining <= 0) rarity_weights[2] = 0;
            trishop_rarity = random_weighted_roll(player_id.item_seed, rarity_weights);
            player_id.item_seed = (player_id.item_seed + 1) % 200;
        }
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
        else if (instance_exists(hbox)) {
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
            if (player_id.uncommon_pool_size <= 2) rarity_weights[1] = 0;
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
    
    //#region Trishop
    // Trishop inherits its init from chests that turn into it, so no init here.
    case 31: // Fall
        if (y + vsp > target_y) {
            mask_index = sprite_get("dspec_largechest"); // todo: make an actual mask
            ignores_walls = false;
            can_be_grounded = true;
        }
        if (!free) {
            set_state(32);
            land_vfx = spawn_hit_fx(x, y, is_large ? player_id.fx_large_chest_land : player_id.fx_small_chest_land);
            land_vfx.depth = depth-1;
            hbox.destroyed = true;
            hbox = noone;
            var land_hbox = create_hitbox(AT_DSPECIAL, is_large ? 4 : 2, x, y-16);
            land_hbox.owner_chest = self;
            sound_play(player_id.s_cland);
            
            // This is a good time to roll for Tri-shop loot.
            trishop_loot = choose_three_items(trishop_rarity);
        }
        else if (instance_exists(hbox)) {
            hbox.hitbox_timer--;
            hbox.vsp = vsp;
        }
        break;
    case 32: // Idle
        if (free) vsp = clamp(vsp+0.5, vsp, 8);
        if (point_distance(x, y, player_id.x, player_id.y) < player_id.DSPEC_SCHEST_RADIUS) outline_alpha = clamp(outline_alpha + 0.2, 0, 1);
        else outline_alpha = clamp(outline_alpha - 0.2, 0, 1);
        if (trishop_vis_timer >= 0) trishop_vis_timer++;
        break;
    case 33: // Opening
        if (outline_alpha > 0) outline_alpha -= 0.2;
        if (state_timer == 1) sound_play(sound_get("cm_smallchest"));
        if (state_timer == 20) {
            var item = instance_create(x, y-10, "obj_article3");
            item.state = 20;
            item.rarity = trishop_rarity;
            item.forced_index = trishop_loot[trishop_selection];
        }
        if (state_timer >= 35) set_state(34);
        break;
    case 34: // Despawning
        if (state_timer >= 60) should_die = true;
        break;
    //#endregion
    
    //#region Classified Access Codes
    case 50: // Init
        target_y = y;
        y = get_stage_data(SD_TOP_BLASTZONE_Y)+80;
        vsp = 2;
        set_state(51);
        hbox = create_hitbox(AT_DSPECIAL, 5, x, y-50);
        hbox.vsp = vsp;
        hbox.owner_chest = self;
        sound_play(player_id.s_cfall);
        sound_play(asset_get("sfx_mol_huge_countdown"), false, noone, 1, 0.7);
        break;
    case 51: // Fall
    	if (state_timer > 30) vsp += 0.9;
        if (y + vsp > target_y) {
            mask_index = sprite_get("dspec_cac_bomb"); // todo: make an actual mask
            ignores_walls = false;
            can_be_grounded = true;
        }
        if (!free || has_hit) {
            set_state(52);
            var explode_vfx = spawn_hit_fx(x, y-50, HFX_MOL_BOOM_FINISH);
            explode_vfx.depth = depth-1;
            hbox.destroyed = true;
            hbox = noone;
            var explode_hbox = create_hitbox(AT_DSPECIAL, 6, x, y-50);
            explode_hbox.owner_chest = self;
            sound_play(asset_get("sfx_mol_huge_explode"));
        }
        else {
            hbox.hitbox_timer--;
            hbox.vsp = vsp;
        }
        break;
    case 52: // Despawning
        should_die = true;
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
       
    // Trishop (no assets yet)
    case 30: // Init
        sprite_index = sprite_get("null");
        break;
    case 31: // Fall
        sprite_index = sprite_get("dspec_largechest");
        image_index = 0;
        break;
    case 32: // Idle
        sprite_index = sprite_get("dspec_largechest");
        image_index = 1 + ((state_timer < 6) ? state_timer / 3 : 2);
        break;
    case 33: // Opening
        sprite_index = sprite_get("dspec_largechest");
        image_index = 5 + (state_timer / 4.5);
        break;
    case 34: // Despawning
        sprite_index = sprite_get("dspec_largechest");
        image_index = 16;
        break;
    
    // Classified Access Codes bomb
    case 50: // Init
        sprite_index = sprite_get("null");
        break;
    case 51: // Fall
        sprite_index = sprite_get("dspec_cac_bomb");
        image_index = 0;
        break;
    case 52:
    case 53:
    	sprite_index = sprite_get("null");
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

#define choose_three_items(rarity)

var items = [];

if (rarity < 0 || rarity > 2) {
	print_debug("article1_update error: bad rarity value");
	exit;
}

while (array_length(items) < 3) {

	// Attempt to generate a legendary item
	var rnd_legendary = random_func_2(player_id.item_seed, 1, false);
	player_id.item_seed = (player_id.item_seed + 1) % 200;
	var odds = has_rune("O") ? player_id.LEGENDARY_ABYSS_ODDS : player_id.LEGENDARY_ODDS;
	if (rnd_legendary <= odds && player_id.legendary_pool_size[rarity] > 0) {
		
		var weight_array =player_id. p_legendary_available[rarity];
		var access_index = random_weighted_roll(player_id.item_seed, weight_array);
		player_id.item_seed = (player_id.item_seed + 1) % 200;
		var item_id =player_id. p_legendary_ids[rarity][access_index];
		
	}
	
	// Generate a standard item
	else {
		
		var weight_array = player_id.p_item_weights[rarity];
		var access_index = random_weighted_roll(player_id.item_seed, weight_array);
		player_id.item_seed = (player_id.item_seed + 1) % 200;
		var item_id = player_id.p_item_ids[rarity][access_index];
		
	}
	
	temp_reduce_item_probability(item_id);
	array_push(items, item_id);

}

for (var i = 0; i < 3; i++) {
	temp_restore_item_probability(items[i]);
}

return items;

#define temp_reduce_item_probability(item_id)
	with player_id {
		var access_index = item_grid[item_id][IG_RANDOMIZER_INDEX];
		var itp = item_grid[item_id][IG_TYPE];
		var rarity = item_grid[item_id][IG_RARITY];
		
		// Reduce for a legendary item
		if (itp == ITP_LEGENDARY) {
			legendary_pool_size[rarity]--;
			p_legendary_available[@ rarity][@ access_index] = p_legendary_available[@ rarity][@ access_index] - 1;
			p_legendary_remaining[@ rarity][@ access_index] = p_legendary_remaining[@ rarity][@ access_index] - 1;
			// Don't decrement the uncommon pool! Legendaries aren't a part of it
			//if (rarity == RTY_RARE) rares_remaining--;
		}
		
		// Reduce for a standard item
		else {
			var remaining = p_item_remaining[rarity][access_index];
			var value = p_item_values[rarity][access_index];
			p_item_remaining[@ rarity][@ access_index] = p_item_remaining[@ rarity][@ access_index] - 1;
			p_item_weights[@ rarity][@ access_index] = p_item_weights[@ rarity][@ access_index] - value;
			if (rarity == RTY_UNCOMMON) uncommon_pool_size--;
			//if (rarity == RTY_RARE) rares_remaining--;
		}
	}

#define temp_restore_item_probability(item_id)
	with player_id {
		var access_index = item_grid[item_id][IG_RANDOMIZER_INDEX];
		var itp = item_grid[item_id][IG_TYPE];
		var rarity = item_grid[item_id][IG_RARITY];
		
		// Increase for a legendary item
		if (itp == ITP_LEGENDARY) {
			legendary_pool_size[rarity]++;
			p_legendary_available[@ rarity][@ access_index] = p_legendary_available[@ rarity][@ access_index] + 1;
			p_legendary_remaining[@ rarity][@ access_index] = p_legendary_remaining[@ rarity][@ access_index] + 1;
			//if (rarity == RTY_RARE) rares_remaining++;
		}
		
		// Increase for a standard item
		else {
			var remaining = p_item_remaining[rarity][access_index];
			var value = p_item_values[rarity][access_index];
			p_item_remaining[@ rarity][@ access_index] = p_item_remaining[@ rarity][@ access_index] + 1;
			p_item_weights[@ rarity][@ access_index] = p_item_weights[@ rarity][@ access_index] + value;
			if (rarity == RTY_UNCOMMON) uncommon_pool_size++;
			//if (rarity == RTY_RARE) rares_remaining++;
		}
	}
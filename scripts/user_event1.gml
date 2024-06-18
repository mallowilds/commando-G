
if (object_index == oPlayer || object_index == oTestPlayer) {
    var iid = generate_item();
    var popup = instance_create(x-172, y-110, "obj_article2");
    popup.item_id = iid;
}
else if (player_id.object_index == oPlayer || player_id.object_index == oTestPlayer) with player_id {
    var iid = generate_item();
    var popup = instance_create(x-172, y-110, "obj_article2");
    popup.item_id = iid;
}
else {
    print_debug("user_event1 error: called from unidentifiable object");
}


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


#define generate_item()
// Set rarity
var rarity_weights = [common_weight, uncommon_weight, rare_weight]
if (uncommons_remaining <= 0) rarity_weights[1] = 0;
if (rares_remaining <= 0) rarity_weights[2] = 0;
var rarity = random_weighted_roll(item_seed, rarity_weights);
item_seed = (item_seed + 1) % 200;

// Attempt to generate a legendary item
var rnd_legendary = random_func_2(item_seed, 1, false);
item_seed = (item_seed + 1) % 200;
if (rnd_legendary <= LEGENDARY_ODDS && legendaries_remaining[rarity] > 0) {
	
	var num_items = array_length(rnd_legend_index_store[rarity]);
	var access_index = random_func_2(num_items, 1, false);
	item_seed = (item_seed + 1) % 200;
	var item_id = rnd_legend_index_store[rarity][access_index];
	
	legendaries_remaining[rarity]--;
	// Remove legendary from item pool
	for (var i = access_index; i < num_items-1; i++) {
		rnd_legend_index_store[@ rarity][@ i] = rnd_legend_index_store[rarity][i+1];
	}
	rnd_legend_index_store[@ rarity] = array_slice(rnd_legend_index_store[rarity], 0, num_items-1);
	
}

else {
	
	// Generate a standard item
	var item_type = random_weighted_roll(item_seed, type_values[rarity]);
	item_seed = (item_seed + 1) % 200;
	var num_items = array_length(rnd_index_store[rarity][item_type]);
	var access_index = random_func_2(item_seed, num_items, false);
	item_seed = (item_seed + 1) % 200;
	var item_id = rnd_index_store[rarity][item_type][access_index];
	
	// Update probability properties to account for new item
	type_values[@ rarity][@ item_type] -= type_weights[rarity][item_type]; // update weights
	if (rarity = RTY_UNCOMMON) uncommons_remaining--;
	// remove item instance from rnd_index_store
	if (rarity != RTY_COMMON) {
		for (var i = access_index; i < num_items-1; i++) {
			rnd_index_store[@ rarity][@ item_type][@ i] = rnd_index_store[rarity][item_type][i+1];
		}
		rnd_index_store[@ rarity][@ item_type] = array_slice(rnd_index_store[rarity][item_type], 0, num_items-1);
	}
	
}

// Apply item (or roll for a new one if a conflict occured)
var incompat_index = item_grid[item_id][IG_INCOMPATIBLE]
if (incompat_index == noone || item_grid[incompat_index][IG_NUM_HELD] == 0) {
	if (item_grid[item_id][IG_NUM_HELD] == 0) array_push(inventory_list, item_id);
	item_grid[@ item_id][@ IG_NUM_HELD] = item_grid[item_id][IG_NUM_HELD] + 1;
	new_item_id = item_id;
	if (rarity = RTY_RARE) rares_remaining--;
	user_event(0);
}
else item_id = generate_item(common_weight, uncommon_weight, rare_weight);

return item_id;

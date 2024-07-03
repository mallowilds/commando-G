
if (object_index == oPlayer || object_index == oTestPlayer) {
	do_user_event1();
}
else if (player_id.object_index == oPlayer || player_id.object_index == oTestPlayer) with player_id {
    do_user_event1();
}
else {
    print_debug("user_event1 error: called from unidentifiable object");
}




// This is in a define in order to accomodate the object perspective-switching above.
#define do_user_event1

var command_type = force_grant_item + 2*force_remove_item
switch command_type {
	case 0: // grant a random item
		var iid = generate_item(grant_rarity);
	    var popup = instance_create(x-172, y-110, "obj_article2");
	    popup.item_id = iid;
		break;
	case 1: // grant a copy of the item at new_item_id, if possible
		apply_item(new_item_id);
		force_grant_item = false;
		break;
	case 2: // remove a copy of the item at new_item_id, if possible
		remove_item(new_item_id);
		force_remove_item = false;
		break;
	default: // undefined case
		print_debug("user_event1 error: parameter conflict. resetting parameters")
		force_grant_item = false;
		force_remove_item = false;
		break;
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


#define generate_item(rarity)

var rarity = grant_rarity;
if (rarity < 0 || rarity > 2) {
	print_debug("user_event1 error: bad rarity value");
	exit;
}

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
var item_applied = apply_item(item_id);
if (!item_applied) {
	item_id = generate_item(rarity);
	/*
	var is_valid_index = (item_id == clamp(item_id, 0, array_length(item_grid)-1));
	if (is_valid_index) print_debug("ERROR: failed to grant " + string(item_grid[item_id][IG_NAME]) + ". In a non-debug environment, this could result in a crash.");
	else print_debug("ERROR: failed to grant item with id " + string(item_id) + ". In a non-debug environment, this could result in a crash.");
	*/
}

return item_id;


// Returns true if the item was applied successfully, false if a conflict occurred
#define apply_item(item_id)

var rarity = item_grid[item_id][IG_RARITY];
var incompat_index = item_grid[item_id][IG_INCOMPATIBLE]
var is_valid_index = (item_id == clamp(item_id, 0, array_length(item_grid)-1));
var is_incompatible = (incompat_index != noone && item_grid[incompat_index][IG_NUM_HELD] >= 1);
var is_excess_uncommon = (rarity == RTY_UNCOMMON && item_grid[item_id][IG_NUM_HELD] >= 3);
var is_excess_rare = (rarity == RTY_RARE && (rares_remaining <= 0 || item_grid[item_id][IG_NUM_HELD] >= 1));

if (is_valid_index && !is_incompatible && !is_excess_uncommon && !is_excess_rare) {
	switch rarity {
		case 0:
			sound_play(s_itemw);
			break;
		case 1:
			sound_play(s_itemg);
			break;
		case 2:
			sound_play(s_itemr);
			break;
	}
	
	if (item_grid[item_id][IG_NUM_HELD] == 0) array_push(inventory_list, item_id);
	item_grid[@ item_id][@ IG_NUM_HELD] = item_grid[item_id][IG_NUM_HELD] + 1;
	if (rarity = RTY_RARE) rares_remaining--;
	new_item_id = item_id;
	user_event(0);
	return true;
}

return false;

// Returns true if the item was applied successfully, false if there was no item to remove
#define remove_item(item_id)

var is_valid_index = (item_id == clamp(item_id, 0, array_length(item_grid)-1));
if (!is_valid_index || item_grid[item_id][IG_NUM_HELD] <= 0) return false;

item_grid[@ item_id][@ IG_NUM_HELD] = item_grid[item_id][IG_NUM_HELD] - 1;
if (item_grid[item_id][IG_RARITY] == RTY_RARE) rares_remaining++;
new_item_id = item_id;
user_event(0);

// Remove from the inventory list if appropriate
if (item_grid[item_id][IG_NUM_HELD] <= 0) {
	
	var i = 0;
	var j = 0;
	var inv_list_len = array_length(inventory_list);
	var new_inv_list = array_create(inv_list_len - 1);
	
	while (i < inv_list_len && j < inv_list_len - 1) {
		if (inv_list[i] != item_id) {
			new_inv_list[j] = inv_list[i];
			j++;
		}
		i++;
	}
	
	inventory_list = new_inv_list;
	
}

return true;

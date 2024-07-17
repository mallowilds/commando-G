
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
var odds = has_rune("O") ? LEGENDARY_ABYSS_ODDS : LEGENDARY_ODDS;
if (rnd_legendary <= odds && legendary_pool_size[rarity] > 0) {
	
	var weight_array = p_legendary_available[rarity];
	var access_index = random_weighted_roll(item_seed, weight_array);
	item_seed = (item_seed + 1) % 200;
	var item_id = p_legendary_ids[rarity][access_index];
	
}

// Generate a standard item
else {
	
	var weight_array = p_item_weights[rarity];
	var access_index = random_weighted_roll(item_seed, weight_array);
	item_seed = (item_seed + 1) % 200;
	var item_id = p_item_ids[rarity][access_index];
	
}

// Apply item
var item_applied = apply_item(item_id);
// if (!item_applied) print_debug("user_event1 error: unknown item conflict")

return item_id;

// Returns true if the item was applied successfully, false if a conflict occurred
#define apply_item(item_id)

var rarity = item_grid[item_id][IG_RARITY];
var incompat_index = item_grid[item_id][IG_INCOMPATIBLE]
var is_valid_index = (item_id == clamp(item_id, 0, array_length(item_grid)-1));
var is_incompatible = (incompat_index != noone && item_grid[incompat_index][IG_NUM_HELD] >= 1);
var is_excess_uncommon = (rarity == RTY_UNCOMMON && item_grid[item_id][IG_NUM_HELD] >= UNCOMMON_LIMIT);
var is_excess_rare = (rarity == RTY_RARE && (rares_remaining <= 0 || item_grid[item_id][IG_NUM_HELD] >= 1));

// Successful item grant
if (is_valid_index && !is_incompatible && !is_excess_uncommon && !is_excess_rare) {
	
	// Play item get sound
	if (item_grid[item_id][IG_TYPE] == ITP_LEGENDARY) sound_play(s_itemr);
	else switch rarity {
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
	
	// Grant item
	if (item_grid[item_id][IG_NUM_HELD] == 0) array_push(inventory_list, item_id);
	item_grid[@ item_id][@ IG_NUM_HELD] = item_grid[item_id][IG_NUM_HELD] + 1;
	new_item_id = item_id;
	user_event(0);
	
	// If something else is incompatible, remove it from the pool
	if (incompat_index != noone) {
		var incompat_access_index = item_grid[incompat_index][IG_RANDOMIZER_INDEX];
		var incompat_rarity = item_grid[incompat_index][IG_RARITY];
		if (0 <= incompat_rarity && incompat_rarity <= 2) {
			if (item_grid[incompat_index][IG_TYPE] == ITP_LEGENDARY) {
				p_legendary_available[@ incompat_rarity][@ incompat_access_index] = 0;
			}
			else {
				p_item_weights[@ incompat_rarity][@ incompat_access_index] = 0;
			}
		}
	}
	
	// Update probabilities
	if (rarity != RTY_COMMON) reduce_item_probability(item_id);
	
	return true;
	
}

// Fail case
// (If everything is working properly, this should never run.)
else if (!is_valid_index) print_debug("user_event1 error: attempted to grant item at invalid index " + string(item_id));
else if (is_incompatible) print_debug("user_event1 error: attempted to grant incompatible item " + item_grid[item_id][IG_NAME]);
else if (is_excess_uncommon) print_debug("user_event1 error: attempted to grant excess uncommon item " + item_grid[item_id][IG_NAME]);
else if (is_excess_rare) print_debug("user_event1 error: attempted to grant excess rare item " + item_grid[item_id][IG_NAME]);
else print_debug("user_event1 error: unknown item conflict");

return false;

#define reduce_item_probability(item_id)
	var access_index = item_grid[item_id][IG_RANDOMIZER_INDEX];
	var itp = item_grid[item_id][IG_TYPE];
	var rarity = item_grid[item_id][IG_RARITY];
	
	// Reduce for a legendary item
	if (itp == ITP_LEGENDARY) {
		legendary_pool_size[rarity]--;
		p_legendary_available[@ rarity][@ access_index] = p_legendary_available[@ rarity][@ access_index] - 1;
		p_legendary_remaining[@ rarity][@ access_index] = p_legendary_remaining[@ rarity][@ access_index] - 1;
		// Don't decrement the uncommon pool! Legendaries aren't a part of it
		if (rarity == RTY_RARE) rares_remaining--;
	}
	
	// Reduce for a standard item
	else {
		var remaining = p_item_remaining[rarity][access_index];
		var value = p_item_values[rarity][access_index];
		p_item_remaining[@ rarity][@ access_index] = p_item_remaining[@ rarity][@ access_index] - 1;
		p_item_weights[@ rarity][@ access_index] = p_item_weights[@ rarity][@ access_index] - value;
		if (rarity == RTY_UNCOMMON) uncommon_pool_size--;
		if (rarity == RTY_RARE) rares_remaining--;
	}

// Returns true if the item was applied successfully, false if there was no item to remove.
#define remove_item(item_id)

var is_valid_index = (item_id == clamp(item_id, 0, array_length(item_grid)-1));
if (!is_valid_index || item_grid[item_id][IG_NUM_HELD] <= 0) {
	if (!is_valid_index) print_debug("user_event1 error: attempted to remove item at invalid index " + string(item_id));
	else print_debug("user_event1 error: attempted to remove unowned item " + item_grid[item_id][IG_NAME]);
	return false;
}

// Remove item
item_grid[@ item_id][@ IG_NUM_HELD] = item_grid[item_id][IG_NUM_HELD] - 1;
new_item_id = item_id;
user_event(0);

// If removing an item returns the number held to 0:
if (item_grid[item_id][IG_NUM_HELD] <= 0) {
	
	// Remove from the inventory list
	var i = 0;
	var j = 0;
	var inv_list_len = array_length(inventory_list);
	var new_inv_list = array_create(inv_list_len - 1);
	
	while (i < inv_list_len && j < inv_list_len - 1) {
		if (inventory_list[i] != item_id) {
			new_inv_list[j] = inventory_list[i];
			j++;
		}
		i++;
	}
	
	inventory_list = new_inv_list;
	
	// Reenable incompatible items if present
	var incompat_index = item_grid[item_id][IG_INCOMPATIBLE]
	if (incompat_index != noone) {
		var incompat_access_index = item_grid[incompat_index][IG_RANDOMIZER_INDEX];
		var incompat_rarity = item_grid[incompat_index][IG_RARITY];
		if (0 <= incompat_rarity && incompat_rarity <= 2) {
			if (item_grid[incompat_index][IG_TYPE] == ITP_LEGENDARY) {
				p_legendary_available[@ incompat_rarity][@ incompat_access_index] = p_legendary_remaining[@ incompat_rarity][@ incompat_access_index];
			}
			else {
				p_item_weights[@ incompat_rarity][@ incompat_access_index] = p_item_remaining[incompat_rarity][incompat_access_index] * p_item_values[incompat_rarity][incompat_access_index];
			}
		}
	}
	
}

// increase item probability
if (item_grid[item_id][IG_RARITY] != RTY_COMMON) increase_item_probability(item_id);

return true;

#define increase_item_probability(item_id)
	var access_index = item_grid[item_id][IG_RANDOMIZER_INDEX];
	var itp = item_grid[item_id][IG_TYPE];
	var rarity = item_grid[item_id][IG_RARITY];
	
	// Increase for a legendary item
	if (itp == ITP_LEGENDARY) {
		legendary_pool_size[rarity]++;
		p_legendary_available[@ rarity][@ access_index] = p_legendary_available[@ rarity][@ access_index] + 1;
		p_legendary_remaining[@ rarity][@ access_index] = p_legendary_remaining[@ rarity][@ access_index] + 1;
		if (rarity == RTY_RARE) rares_remaining++;
	}
	
	// Increase for a standard item
	else {
		var remaining = p_item_remaining[rarity][access_index];
		var value = p_item_values[rarity][access_index];
		p_item_remaining[@ rarity][@ access_index] = p_item_remaining[@ rarity][@ access_index] + 1;
		p_item_weights[@ rarity][@ access_index] = p_item_weights[@ rarity][@ access_index] + value;
		if (rarity == RTY_UNCOMMON) uncommon_pool_size++;
		if (rarity == RTY_RARE) rares_remaining++;
	}


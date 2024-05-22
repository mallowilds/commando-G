/*

Item category management reqs:

Probability flags
Common/uncommon/rare [fixed]
Damage/knockback/healing/speed/barrier [rare/legendary: weights adjust based on remaining items]
Legendary/Non-legendary [

Effect flags
Critical
Attack Speed
Explosive


DATA STRUCTURES
Core data grid: contains all info for easy access. Item ID is equal to index. Fields:
- Name
- Rarity flag
- Type flag
- Legendary flag
- Item held amount

Index tree: For use by probability handler, generated dynamically at init. Nested as follows:
Rarity -> Type -> (ds list containing indices)
* The uncommon lists should be populated with three of each index, as appropriate.
* Uncommon and rare items should be removed from their respective pools.

Legendary lists: similar to index tree. separated in order to distinguish the unique behavior of legendaries.
Rarity -> (ds list containing indices)
* All lists should be populated with one of each index.
* Unlike standard commons, legendary commons are non-stackable and should be removed from the pool on obtaining.

Held item list: used for quick access in update and draw operations. Exclusively holds item IDs, sorted by order of obtainment.

Probability stores
legendary_remaining[rarity] (used to disable legendary rolls when appropriate)
rares_remaining (decrement when obtaining a rare item, disable rares upon reaching 0)
type_values[rarity, type] (stores "values" of each item type for item rolls.)
                          (higher values are more likely.)
                          (uncommon/rare values are mutable to account for removal of items from pool.)
type_weights[rarity, type] (the value of any single item within a type's value.)
                           (used for decrementing uncommon/rare type values.)
                           (for ease of implementation, commons have a weight of 0.)
* To avoid issues with floats, all values/weights are stored as integers.

__ TODO \/ __

Stat flags
has_critical (enables checks for crit effects)
attack_speed_count (inits to 1, goes up with attack speed items)
move_speed_count (inits to 0, goes up with items like Paul's Goat Hoof)

Stat modifier managment
In the interest of safety, the following system will be used for all movement stat updates (might be overkill, subject to change):
[statname]_base = [init value]
[statname]_mod = [difference applied by raw stat changes from items, excluding distinct stacking effects like move_speed_count]
On a raw stat update: update statname_mod and statname_base accordingly
On a move_speed_count (or similar) update: delegate out to a function
	- Reset [statname] to [statname]_base
	- Add appropriate modifier
	- Readd [statname]_mod
	
Other
u_mult system (necessary for fractional multipliers. same as despy and momoyo)


PROBABILITY ROUTINE
Roll for rarity
Roll for legendary chance (unless legendary pool for this rarity is empty)
If legendary:
    Roll for an option from legendary pool
    Remove instance from index tree
    Take item, apply effects
    Decrement legendary_remaining[rarity]
If non-legendary:
    Roll for which category to pull from based on item type values
    Decrement type value by weights
    If uncommon/rare: remove instance from index tree
    If rare: decrement rares_remaining
    Take item, apply effects
	
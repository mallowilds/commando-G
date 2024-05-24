// ITEM INIT
// Called whenever an item is added to Commando's inventory.

// TODO: flatten to fixed IDs later (?)
switch item_grid[new_item_id][IG_NAME] {
    
    case "Hopoo Feather":
        max_djumps++;
        break;
    
    case "Tough Times":
        knockback_adj -= 0.1;
        break;
    
}
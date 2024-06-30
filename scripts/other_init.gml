

u_mult_damage_buffer = 0; // buffer for fractional multiplier damage

commando_status_state = array_create(7);
commando_status_counter = array_create(7);
commando_status_owner = array_create(7, noone); // for the sake of the ditto

burnt_pause = 0; // seems to improve stability (?)


commando_warbanner_owner = noone;
commando_warbanner_strength = 0;
commando_warbanner_updated = 0;


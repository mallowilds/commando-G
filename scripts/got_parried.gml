
// Ignition Tank
do_ignite_hbox = 0;

// Fireman's Boots
if (fireboots_lockout < FIREBOOTS_PARRY_LOCKOUT && item_grid[ITEM_FIREBOOTS][IG_NUM_HELD] > 0) {
    fireboots_lockout = FIREBOOTS_PARRY_LOCKOUT;
    sound_play(asset_get("sfx_burnend"));
}

// Filial Imprinting
if (filial_aspeed_timer > 0) filial_aspeed_timer = 1;
if (filial_speed_timer > 0) filial_speed_timer = 1;
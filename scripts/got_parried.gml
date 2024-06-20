
// Ignition Tank
do_ignite_hbox = 0;

// Fireman's Boots
if (fireboots_lockout < FIREBOOTS_PARRY_LOCKOUT && item_grid[ITEM_FIREBOOTS][IG_NUM_HELD] > 0) {
    fireboots_lockout = FIREBOOTS_PARRY_LOCKOUT;
    sound_play(asset_get("sfx_burnend"));
}
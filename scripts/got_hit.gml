
// Heart Barrier
heart_barrier_endangered = 1;
heart_barrier_timer = 0;

// Ignition Tank
do_ignite_hbox = 0;

// Fireman's Boots
if (fireboots_lockout < FIREBOOTS_HIT_LOCKOUT) fireboots_lockout = FIREBOOTS_HIT_LOCKOUT;

// Brilliant Behemoth
do_behemoth_hbox = 0;

//Death Message (N/A Compat)

if hit_player_obj.url = 2229832619 {
    is_na = 1
} else {
    is_na = 0
}
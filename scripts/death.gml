



// Barriers
jewel_barrier = 0;
heart_barrier = 0;
aegis_barrier = 0;
brooch_barrier = 0;

// Heart Barrier
heart_barrier_endangered = 1;
heart_barrier_timer = 0;

// Ignition Tank
do_ignite_hbox = 0;

// Brilliant Behemoth
do_behemoth_hbox = 0;

// Dio's Best Friend
if (item_grid[44][IG_NUM_HELD] > 0) {
    
	sound_play(s_dios);
	dios_revive_timer = DIOS_REVIVE_WAIT;
	set_state(PS_HITSTUN);
	initial_invince = 1;
	invince_time = DIOS_REVIVE_WAIT + 4;
	hitstop = 3;
	hitstop_full = 3;
	hitpause = true;
	visible = false;
		
	hsp = 0;
	vsp = 0;
	old_hsp = 0;
	old_vsp = 0;
    
    set_player_stocks(player, get_player_stocks(player)+1);
    dios_stored_damage = get_player_damage(player) - 20;
    
}

// Death Message
if is_na {
	sound_play(s_jailed, 0, noone, 1.5, 1)
} else {
	sound_play(s_mortem)
}
//if get_player_stocks( player ) == 0 {
	
	final_death_timer = 120
//}
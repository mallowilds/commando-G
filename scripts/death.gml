



// Barriers
jewel_barrier = 0;
heart_barrier = 0;
aegis_barrier = 0;
brooch_barrier = 0;

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
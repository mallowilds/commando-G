//a

//multihit projectiles
if (hitbox_multihits) {
    if (!getting_bashed) {
        if (proj_hitpause) {
            proj_hitstop--;
            hitbox_timer--;
            if (proj_hitstop <= 0) {
        		//hitpause has ended. reset all of the movement and animation variables.
        		hsp = proj_old_hsp;
        		vsp = proj_old_vsp;
        		img_spd = proj_old_img_spd;
        		proj_hitpause = false;
        		
        		//if this projectile has hit its maximum number of times, destroy it.
        		for(var i=0;i<5;i++) {
        		    if (hitbox_hit_player_count[i] >= hitbox_multihit_max && hitbox_multihit_max != -1) {
                        destroyed = true;
                    }
        		}
            
        	}
        	else {
        		//stop movement and exit here if the projectile is still in hitpause.
        		hsp = 0;
        		vsp = 0;
        		img_spd = 0;
        	}
        } else {
            for(var i=0;i<5;i++) {
                if (hitbox_hit_player_timers[i] != hitbox_multihit_rate && i != player) {
                    hitbox_hit_player_timers[i] += 1;
                }
                if (hitbox_hit_player_timers[i] == hitbox_multihit_rate) {
                    can_hit[i] = true;
                }
            }
        }
        if (proj_old_player != player) {
            hitbox_hit_player_timers[player] = 0;
            can_hit[player] = false;
            proj_old_player = player;
        }
        
        hitpause = proj_old_hitpause;
    }
}



//                              ARTICLE  STUFF                                //
/*
    considering that articles are p much empty things that you can do whatever
    with, I'll only set up a really basic state machine since those tend to be 
    pretty useful for most situations
    
    although sometimes you'll probably want to delete it and start from scratch
    if it's a really simple article
*/

// sprite and mask indexes; + default article variables
sprite_index = sprite_get("idle");
mask_index = asset_get("ex_guy_hurt_box");
can_be_grounded = false;
ignores_walls = true;
spr_dir = player_id.spr_dir;

uses_shader = true;

// state machine variables
state = 0;
state_timer = 0;
should_die = false; //if the article should be despawned

// animation variables
anim_speed = 0.15;


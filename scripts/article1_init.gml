
// Chests

// sprite and mask indexes; + default article variables
sprite_index = sprite_get("null");
mask_index = asset_get("null");
can_be_grounded = false;
ignores_walls = true;
spr_dir = player_id.spr_dir;

uses_shader = true;

// state machine variables
state = 0;
state_timer = 0;
should_die = false; //if the article should be despawned

// article variables
target_y = y;
outline_alpha = 0;
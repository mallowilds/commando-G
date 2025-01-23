
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
target_y = y-10;
outline_alpha = 0;
hbox = noone;
land_vfx = noone;
has_hit = false;
is_large = false; // for the sake of trishops
trishop_rarity = 0; // common, uncommon, rare
trishop_selection = -1; // 0-2, left-to-right
trishop_vis_timer = -1;
trishop_vis_opacities = [0.1, 0.1, 0.1];
trishop_vis_flashing = 0;
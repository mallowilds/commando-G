//                                  debug                                     //
should_debug                    = 0;
rainfont = font_get("_rfont");
rainfontbig = font_get("_rfontbig");

//=-(                        ~~//** CONSTANTS **//~~                       )-=//
user_event(2); // Lots of primitive constants are defined in here. These should be baked into the code before release (using the planned tool)

// Non-primitive constants are below. (mostly text strings)
rarity_names = ["Common", "Uncommon", "Rare"];
item_type_names = ["Damage", "Knockback", "Healing", "Speed", "Critical", "Attack Speed", "Barrier", "Explosive"];
legendary_type_name = "Legendary";



//=-(                    ~~//** NON-ITEM MANAGEMENT **//~~                  )-=//

// Lightweight particles
lfx_list = ds_list_create();

// DSpec
chest_obj = noone;
dspec_cooldown_hits = DSPEC_INIT_CD_HITS; // Hits on the opponent remaining until DSpec goes off cooldown.
first_hit = false; // Mirrors has_hit, but is accessible from hit_player to track the first hit applied.

//=-(                     ~~//** ITEM MANAGEMENT **//~~                     )-=//

// Item Grid
// Format: see IG indices above.
// Do not reorder items without updating their indices (user_event2.gml)! If you need to remove an item, use RTY_DUMMY to disable it.
item_grid = [
    ["Crowbar",                 RTY_COMMON,     ITP_KNOCKBACK,    0, noone, "Deal more damage & knockback to healthy enemies."], // 0 | hit_player.gml
    ["Warbanner",               RTY_COMMON,     ITP_DAMAGE,       0, noone, "Taunt to place down a powerful buffing Warbanner."], // 1 | Unimplemented
    ["Headstompers",            RTY_COMMON,     ITP_DAMAGE,       0, noone, "Hurt enemies by fast-falling."], // 2 | Unimplemented
    ["Armor-Piercing Rounds",   RTY_COMMON,     ITP_KNOCKBACK,    0, noone, "Strongs deal more damage and slightly more knockback."], // 3 | Unimplemented
    ["Bustling Fungus",         RTY_COMMON,     ITP_HEALING,      0, noone, "Crouch to heal over time."], // 4 | update.gml, post_draw.gml
    ["Paul's Goat Hoof",        RTY_COMMON,     ITP_SPEED,        0, noone, "Move faster."], // 5 | user_event0.gml
    ["Energy Drink",            RTY_COMMON,     ITP_SPEED,        0, noone, "Dash faster."], // 6 | user_event0.gml
    ["Arcane Blades",           RTY_COMMON,     ITP_SPEED,        0, noone, "Move faster after reaching 100%."], // 7 | user_event0.gml, update.gml
    ["Hermit's Scarf",          RTY_COMMON,     ITP_SPEED,        0, noone, "Parry, rolls, and airdodges have more invulnerability."], // 8 | user_event0.gml
    ["Topaz Brooch",            RTY_COMMON,     ITP_BARRIER,      0, noone, "Gain 5% barrier on kill."], // 9 | update.gml, general barrier utils
    ["Lens Maker's Glasses",    RTY_COMMON,     ITP_CRITICAL,     0, noone, "Critical Strikes deal more damage."], // 10 | update.gml ~ melee hitbox update, user_event0.gml
    ["Tri-Tip Dagger",          RTY_COMMON,     ITP_CRITICAL,     0, noone, "Critical Strikes bleed opponents, dealing damage over time."], // 11 | update.gml, hit_player.gml
    ["Taser",                   RTY_COMMON,     ITP_CRITICAL,     0, noone, "Critical Strikes briefly stun opponents."], // 12 | update.gml ~ melee hitbox update (partially done), user_event0.gml
    ["Soldier's Syringe",       RTY_COMMON,     ITP_ATTACK_SPEED, 0, noone, "Increased attack speed."], // 13 | user_event0.gml
    ["Mocha",                   RTY_COMMON,     ITP_ATTACK_SPEED, 0, noone, "Slightly increased movement & attack speed."], // 14 | user_event0.gml
    ["Sticky Bomb",             RTY_COMMON,     ITP_EXPLOSIVE,    0, noone, "Blast attacks attach a little more firepower."], // 15 | Unimplemented
    ["Gasoline",                RTY_COMMON,     ITP_EXPLOSIVE,    1, noone, "Blast attacks set enemies on fire."], // 16 | hit_player.gml, user_event0.gml
    ["Tough Times",             RTY_COMMON,     ITP_LEGENDARY,    0, noone, "I'm coming home soon. Stay strong."], // 17 | user_event0.gml
    
    ["Kjaro's Band",            RTY_UNCOMMON,   ITP_DAMAGE,       0, noone, "Strongs blast enemies with runic fire, lighting them ablaze."], // 18 | hit_player.gml, user_event0.gml
    ["Runald's Band",           RTY_UNCOMMON,   ITP_KNOCKBACK,    0, noone, "Strongs blast enemies with runic ice, freezing to the bone."], // 19 | melee hitbox update, hit_player.gml
    ["Ukelele",                 RTY_UNCOMMON,   ITP_KNOCKBACK,    0, noone, "..And his music was electric."], // 20 | Unimplemented
    ["Hopoo Feather",           RTY_UNCOMMON,   ITP_SPEED,        0, noone, "Gain an extra jump."], // 21 | user_event0.gml
    ["Guardian Heart",          RTY_UNCOMMON,   ITP_BARRIER,      0, noone, "Gain a 4% shield. Recharges outside of danger."], // 22 | update.gml, got_hit.gml, user_event0.gml , general barrier utils
    ["Locked Jewel",            RTY_UNCOMMON,   ITP_BARRIER,      0, noone, "Gain a burst of shield and speed after opening chests."], // 23 | attack_update.gml, update.gml, general barrier utils
    ["Harvester's Scythe",      RTY_UNCOMMON,   ITP_HEALING,      0, noone, "Critical Strikes heal you by a portion of the damage they deal."], // 24 | hit_player.gml, user_event0.gml
    ["Ignition Tank",           RTY_VOID,       ITP_CRITICAL,     0, noone, "Critical Strikes deal extra knockback to enemies on fire."], // 25 | Several attacks, hit_player.gml, attack_update.gml, got_hit.gml, death.gml. Becomes uncommon in a user_event0 script
    ["Predatory Instincts",     RTY_UNCOMMON,   ITP_ATTACK_SPEED, 0, noone, "Critical Strikes increase attack speed."], // 26 | update.gml, hit_player.gml, user_event0.gml
    ["Stun Grenade",            RTY_UNCOMMON,   ITP_EXPLOSIVE,    0, noone, "Blast attacks stun enemies briefly."], // 27 | Unimplemented
    ["AtG Missile Mk. 1",       RTY_UNCOMMON,   ITP_KNOCKBACK,    0, noone, "Strongs fire a missile."], // 28 | Unimplemented
    ["Rusty Jetpack",           RTY_UNCOMMON,   ITP_SPEED,        0, noone, "Increase jump height and reduce gravity."], // 29 | user_event0.gml
    ["Legendary Spark",         RTY_UNCOMMON,   ITP_LEGENDARY,    0, noone, "Smite them. Smite them all."], // 30 | Unimplemented
    
    ["Ancient Scepter",         RTY_RARE,       ITP_DAMAGE,       0, noone, "Upgrade your Neutral Special."], // 31 | Unimplemented
    ["Fireman's Boots",         RTY_RARE,       ITP_DAMAGE,       0, noone, "Fight fire with fire.."], // 32 | update.gml, article3, user_event0.gml
    ["AtG Missile Mk. 2",       RTY_RARE,       ITP_KNOCKBACK,    0, noone, "Hooah."], // 33 | Unimplemented
    ["The Ol' Lopper",          RTY_RARE,       ITP_KNOCKBACK,    0, 35,    "Enemies above 120% take massive knockback."], // 34 | update.gml, hit_player.gml, other_post_draw.gml
    ["Shattering Justice",      RTY_RARE,       ITP_KNOCKBACK,    0, 34,    "Enemies above 100% have their Armor shattered."], // 35 | update.gml, hit_player.gml, other_post_draw.gml
    ["Classified Access Codes", RTY_RARE,       ITP_DAMAGE,       0, noone, "Down Special requests extreme reinforcements after 15 seconds."], // 36 | Unimplemented
    ["Photon Jetpack",          RTY_RARE,       ITP_SPEED,        0, 38,    "No hands!"], // 37 | user_event0.gml, update.gml, post_draw.gml
    ["H3AD-5T V2",              RTY_RARE,       ITP_SPEED,        0, 37,    "Jump much higher, and fall much faster."], // 38 | user_event0.gml
    ["Hardlight Afterburner",   RTY_RARE,       ITP_SPEED,        0, noone, "Upgrades your side special."], // 39 | Unimplemented
    ["Laser Scope",             RTY_RARE,       ITP_CRITICAL,     1, 41,    "Critical hits deal massive damage and knockback."], // 40 | Several attacks, user_event0.gml, melee hitbox update (for ignition tank effects)
    ["Laser Turbine",           RTY_RARE,       ITP_ATTACK_SPEED, 0, 40,    "Gunshots charge up a huge laser blast."], // 41 | Unimplemented
    ["Aegis",                   RTY_RARE,       ITP_BARRIER,      0, noone, "All healing also gives you half of its value as barrier."], // 42 | integrated into the healing-applying function (and general barrier utils)
    ["Brilliant Behemoth",      RTY_RARE,       ITP_EXPLOSIVE,    1, noone, "Your gunshots explode!"], // 43 | melee hitbox update, AT_EXTRA_1, attack_update.gml, got_hit.gml, death.gml, update.gml
    ["Dio's Best Friend",       RTY_RARE,       ITP_HEALING,      0, noone, "Cheat death."], // 44 | update.gml, death.gml
    ["Withered Best Friend",    RTY_VOID,       ITP_LEGENDARY,    0, noone, "A spent item with no remaining power."], // 45 | N/A
    ["57 Leaf Clover",          RTY_RARE,       ITP_LEGENDARY,    0, noone, "Luck is on your side."], // 46 | Unimplemented
    
    ["Monster Tooth",           RTY_COMMON,     ITP_HEALING,      0, noone, "Enemies that get launched hard enough spawn healing orbs."], // 47 | hit_player.gml, article3
    ["Wax Quail",               RTY_UNCOMMON,   ITP_SPEED,        0, noone, "Jumping while dashing boosts you forward."], // 48 | update.gml
    ["Filial Imprinting",       RTY_UNCOMMON,   ITP_HEALING,      0, noone, "Hatch a strange creature who drops buffs every 15 seconds."], // 49 | Unimplemented
    ["Energy Cell",             RTY_UNCOMMON,   ITP_ATTACK_SPEED, 0, noone, "Gain attack speed the more you're damaged."], // 50 | user_event0.gml, update.gml
    
]

// Inventory store
inventory_list = [ITEM_SCOPE, ITEM_GASOLINE, ITEM_BEHEMOTH];

// For use by item init (user_event0)
new_item_id = noone;

// Randomizer index stores
rnd_index_store = array_create(3); // 3*num_itp_indices store of lists
rnd_legend_index_store = array_create(3); // store of 3 lists
for (var rty = 0; rty < 3; rty++) {
    rnd_index_store[rty] = array_create(num_itp_indices);
    for (var itp = 0; itp < num_itp_indices; itp++) {
        rnd_index_store[@ rty][@ itp] = [];
    }
    
    rnd_legend_index_store[rty] = [];
}

// Randomizer properties
legendaries_remaining = array_create(3, 0); // to be initialized
rares_remaining = 3; // manual limit, assumes that at least 3 rares exist
uncommons_remaining = 0; // to be initialized
item_seed = player * 5; // max 200, this should hold within the rivals engine

grant_rarity = noone; // for user_event(1). This default value throws an error as a sanity check


// Type values: absolute probability that a category will be rolled within a given rarity.
// Only common is set here; uncommon and rare are generated dynamically based on the
// number of items in each category and their weights.
// Legendary items are handled differently and thus not included here.
type_values = [
    // In order of ITP indices (see above)
    INIT_COMMON_VALUES,  // commons
    array_create(num_itp_indices, 0),     // uncommons
    array_create(num_itp_indices, 0),     // rares
]

// Type weights: the probability weights for any single item of a given rarity and type.
// The type_value of a given type/rarity will be reduced by this value upon pulling it.
// Common items are handled differently and are set to zero.
type_weights = [
    // In order of ITP indices (see above)
    array_create(num_itp_indices, 0),     // commons
    INIT_UNCOMMON_WEIGHTS,  // uncommons
    INIT_RARE_WEIGHTS,  // rares
]

// Populate randomizer info
for (var iid = 0; iid < array_length(item_grid); iid++) {
    var rty = item_grid[iid][IG_RARITY];
    var itp = item_grid[iid][IG_TYPE];
    if (itp == ITP_LEGENDARY && rty > RTY_DUMMY) {
        array_push(rnd_legend_index_store[rty], iid);
        legendaries_remaining[rty]++;
    }
    else if (rty > RTY_DUMMY) {
        for (var n = 0; n < (rty == RTY_UNCOMMON ? 3 : 1); n++) { // add 3 instances to the pool for uncommons
            array_push(rnd_index_store[rty][itp], iid);
            if (rty != RTY_COMMON) {
                type_values[@ rty][@ itp] = type_values[rty][itp] + type_weights[rty][itp];
            }
        }
        if (rty == RTY_UNCOMMON) uncommons_remaining += 3;
    }
}



// Item variables
// Keyword trackers
critical_active = 0;     // enables checks for crit items
explosive_active = 0;    // enables checks for explosive items
attack_speed = 1;        // inits to 1, goes up with attack speed items
move_speed = 0;          // inits to 0, goes up with items like Paul's Goat Hoof
dodge_duration_add = 0;  // inits to 0, adds n frames to shield actions

// Attack overwrites (see set_attack.gml)
ntaunt_index = AT_TAUNT // taunts altered by Ukelele/Warbanner
utaunt_index = AT_TAUNT
dtaunt_index = AT_TAUNT
ustrong_index = AT_USTRONG // altered by Ukelele

// Multipliers and fractional damage (see also: other_init.gml)
u_mult_damage_buffer = 0;
multiplier = 0;
multiplier_base = 0;

// Hitbox data storage (for use by ATG and Behemoth)
hbox_stored_damage = 0; // probably won't see use in practice
hbox_stored_bkb = 0;
hbox_stored_kbg = 0;
hbox_stored_angle = 0; // this one should actually grab the opponent's launch angle
hbox_stored_bhp = 0; // hitpause
hbox_stored_hps = 0;
hbox_stored_lockout = 0; // hit lockout

// Status (see also: other_init.gml; user_event2.gml for indices)
commando_status_state = array_create(7);
commando_status_counter = array_create(7);
commando_status_owner = array_create(7, noone); // for the sake of the ditto

// Dodge duration overrides
dodge_duration_timer = 0;

// Percent tracking / barriers
old_damage = 0;
brooch_barrier = 0;      // Topaz Brooch
heart_barrier = 0;       // Guardian Heart
heart_barrier_endangered = 1;
heart_barrier_timer = 0;
heart_barrier_max = 0;   // see user_event0
jewel_barrier = 0;       // Locked Jewel
jewel_barrier_timer = 0;
aegis_barrier = 0;       // Aegis
aegis_ratio = AEGIS_RATIO_BASE;
hud_barrier_fade_alpha = 0;

// Kill tracking
recently_hit = array_create(20, noone)
num_recently_hit = 0;

// Misc item-specific vars
bungus_active = 0;
bungus_timer = 0;
bungus_vis_timer = 999;
bungus_vis_x = x;
bungus_vis_y = y;

instincts_timer = 0; // Predatory Instincts

do_ignite_hbox = 0; // Ignition Tank

h3ad_lockout_timer = 0; // H3AD-5T, used for fast falling
h3ad_was_fast_falling = false;

fireboots_distance = 0;
fireboots_prev_x = x;
fireboots_lockout = 0;

do_behemoth_hbox = 0;
behemoth_hfx = noone;
behemoth_hfx_hitstop = 0;

pjetpack_fuel = 0;
pjetpack_fuel_max = 75;
pjetpack_available = 0;
pjetpack_hud_alpha = 0;
pjetpack_vis_fuel = 0;
pjetpack_sound = noone;

dios_revive_timer = -999;
dios_stored_damage = 0;

tooth_awaiting_spawn = array_create(20, -1);

quail_do_boost = 0;


//          Sound Effects (gonna use init this time, wanna see if it makes it easier)                //
s_dag_swing = sound_get("cm_dagger_swing");
s_cbar = sound_get("cm_crowbar");
s_dios = sound_get("cm_item_dios");
s_shotty = sound_get("cm_shotgun_blast");
s_reload = sound_get("cm_shotgun_load");

s_gunf = sound_get("cm_shootfast") //fast, multihit
s_gunl = sound_get("cm_shootlight_1"); //light
s_gunm = sound_get("cm_shootlight2"); //med
s_gunh = sound_get("cm_shootmedwav"); //heavy //idk why it got named that lol
s_tap = sound_get("cm_dspec_taptaptap")

s_knifel = sound_get("sfx_knifehit_s")
s_knifem = sound_get("sfx_knifehit_m")
s_crit = sound_get("cm_crit")
s_critheal = sound_get("cm_crit_heal")

s_roll = sound_get("cm_roll")
s_coin = sound_get("cm_shine")
s_slide = sound_get("cm_slide")

s_cd = sound_get("cm_cdend")
s_cfall = sound_get("cm_chestfall")
s_cland = sound_get("cm_chestland")
s_itemw = sound_get("cm_item_white")
s_itemg = sound_get("cm_item_green")
s_itemr = sound_get("cm_item_red")
//


// 

//                      TEMPLATE ATTACK/WINDOW INDEXES                        //

/*
- free attack data indexes technically start at 24 up to 99, went with 30 to
make it look cleaner
*/

// adds once-per-air limit to an attack
AG_ATTACK_AIR_LIMIT             = 30;

// might add ai indexes here later so you can tell the cpu when to use certain
// moves

/*
- free window data indexes technically start at 61 up to 99, went with 70 to
make it look cleaner
*/

// adds looping frames to an attack's charge window, while charging
AG_WINDOW_HAS_CHARGE_LOOP       = 70;   // if the window has a charge anim loop
AG_WINDOW_CHARGE_FRAME_START    = 71;   // anim frame of the start of the loop
AG_WINDOW_CHARGE_FRAMES         = 72;   // total number of frames
AG_WINDOW_CHARGE_LOOP_SPEED     = 73;   // speed of the loop animation

AG_WINDOW_GRAB_OPPONENT         = 74;   // if the window is a grab window (1),
                                        // hold opponent, otherwise let them go
AG_WINDOW_GRAB_POS_X            = 75;   // x position to hold grabbed opponent
AG_WINDOW_GRAB_POS_Y            = 76;   // y position to hold grabbed opponent

AG_WINDOW_CAN_WALLJUMP          = 77;   // if the player can walljump out of the
                                        // window



//                               HITBOX INDEXES                               //

/*
- free hitbox data indexes technically start at 54 up to 99, went with 60 to
make it look cleaner
*/

HG_HAS_GRAB                     = 60;   // makes the hitbox into a command grab
HG_BREAKS_GRAB                  = 61;   // if the grabbed player is hit, they're
                                        // no longer grabbed
HG_GRAB_WINDOW_GOTO             = 62;   // window the grab goes into
                                        // -1 if it continues in the same window
HG_GRAB_WINDOWS_NUM             = 63;   // up to what window the grab goes to
                                        // -1 if it doesnt change window num
HG_HAS_LERP                     = 64;   // if the hitbox has lerp properties
HG_LERP_PERCENT                 = 65;   // how much pull the lerp has
                                        // from 0.0~1.0
HG_LERP_POS_X                   = 66;   // x position that the lerp pulls to
HG_LERP_POS_Y                   = 67;   // y position that the lerp pulls to

HG_PROJECTILE_MULTIHIT          = 70;   // if a projectile multihits
HG_PROJECTILE_MULTIHIT_RATE     = 71;   // rate at which a projectile multihits
                                        // ex.: if 10, hits every 10 frames
                                        // (individual per opponent)
HG_PROJECTILE_MAX_HITS          = 72;   // max number of times the projectile
                                        // can hit before being destroyed
                                        // (individual per opponent)
                                        // put -1 for no limit

// if you're making custom indexes for your character, I recommend starting at
// 80 or 90, as slots up to 79 may be filled in future updates

/*
if you're using multihit properties, be sure to check if the projectile goes 
through enemies, otherwise it might just despawn on hit
*/


//=-(                    ~~//** TEMPLATE VARIABLES **//~~                    )-=//


//                               PRE-SET STUFF                                //
// attack/hitbox index variables
attack_air_limit                = array_create(50, false);
                                        // tracks per-air limit for attacks
attack_air_limit_ver            = false;// if true, will check if air limits
                                        // should be reset
                                        // so that it doesn't go through the big
                                        // array more often than needed
grabbed_player_obj              = noone;// the player that got grabbed
grabbed_player_relative_x       = 0;    // x position in relation to the player, 
                                        // for the grabbed player to be moved to
grabbed_player_relative_y       = 0;    // y position in relation to the player, 
                                        // for the grabbed player to be moved to

// article variables
article_id                      = noone;// id that refers to a spawned article
                                        // change name to whatever you want

// composite vfx array
comp_vfx_array                  = [[{cur_timer: 1, max_timer: 0}]];
                                        // array containing the composite
                                        // vfx
vfx_created                     = false;// checks if the effect was successfully
                                        // created in the array

/* // WIP 
// alt color shade slots
num_base_colors                 = 1;    // how many colors the character has

col_shade_list                  = [
                                [1],
                                [0],
                                [0],
                                [0],
                                [1],
                                [1]
                                ];      // array holding shade values in each
                                        // alt for each color
                                        // as sandbert only has 1 color and 6
                                        // alts, there's 6 arrays with 1 element

*/
/*
- remember that css needs it's own version of these variables, so if you change
it here, change it there too!
*/

// animation stuff
idle_air_loops                  = false;// whether idle air has a looping 
                                        // animation or not
idle_air_looping                = false;// checks if the loop is happening
jump_frames                     = 5;    // how many animation frames the jump 
                                        // has, the loop starts there
idle_air_loop_speed             = 0.25;  // animation speed of the loop
idle_air_platfalls              = false; // if the character has an animation for
                                        // dropping from platforms
idle_air_platfalling            = false;// checks if platfall is happening
idle_air_platfall_speed         = 0.25; // platfall animation speed
idle_air_platfall_frames        = 7;    // how many frames the platfall anim has
                                        // when finished goes to air idle
dash_moonwalks                  = false; // if the character has a moonwalk anim

//=-(                     ~~//** CUSTOM EFFECTS **//~~                     )-=//

//                           --sound effects--                                //
//a

//                           --visual effects--                               //
// full vfx

// NOTE !!!
// while the vfx tool is still a work in progress, I recommend keeping it simple
// and not doing too many effect variants like this, it'll be an absolute hassle 
// to work with otherwise

// plus there's some effects here that I'm gonna remove, and others that need to
// be polished, so you should probs delete those and their sprites and make your
// own

// vfx parts for spawning multiple at a time, for more complex visuals
/*
fx_small_circle1                = hit_fx_create(sprite_get("fx_small_circle1"),14);
fx_small_circle2                = hit_fx_create(sprite_get("fx_small_circle2"),14);
fx_small_circle3                = hit_fx_create(sprite_get("fx_small_circle3"),14);
fx_small_circle4                = hit_fx_create(sprite_get("fx_small_circle4"),14);

fx_small_circle_angled1         = hit_fx_create(sprite_get("fx_small_circle_angled1"),14);

fx_medium_circle1               = hit_fx_create(sprite_get("fx_medium_circle1"),14);

fx_medium_circle_angled1        = hit_fx_create(sprite_get("fx_medium_circle_angled1"),14);
fx_medium_circle_angled2        = hit_fx_create(sprite_get("fx_medium_circle_angled2"),14);

fx_large_circle1                = hit_fx_create(sprite_get("fx_large_circle1"),16);

fx_large_circle_angled1         = hit_fx_create(sprite_get("fx_large_circle_angled1"),16);

fx_small_flare1_0               = hit_fx_create(sprite_get("fx_small_flare1_0"),8);
fx_small_flare1_1               = hit_fx_create(sprite_get("fx_small_flare1_1"),8);
fx_small_flare1_2               = hit_fx_create(sprite_get("fx_small_flare1_2"),8);
fx_small_flare1_3               = hit_fx_create(sprite_get("fx_small_flare1_3"),8);

fx_small_spark1_0               = hit_fx_create(sprite_get("fx_small_spark1_0"),10);
fx_small_spark1_1               = hit_fx_create(sprite_get("fx_small_spark1_1"),10);
fx_small_spark1_2               = hit_fx_create(sprite_get("fx_small_spark1_2"),10);
fx_small_spark1_3               = hit_fx_create(sprite_get("fx_small_spark1_3"),10);

fx_small_centershine            = hit_fx_create(sprite_get("fx_small_centershine"),10);

fx_small_shine0                 = hit_fx_create(sprite_get("fx_small_shine0"),8);
fx_small_shine1                 = hit_fx_create(sprite_get("fx_small_shine1"),8);
fx_small_shine2                 = hit_fx_create(sprite_get("fx_small_shine2"),8);
fx_small_shine3                 = hit_fx_create(sprite_get("fx_small_shine3"),8);

fx_small_flashlight1            = hit_fx_create(sprite_get("fx_small_flashlight1"),14);

// arrays with vfx parts, useful if you want to draw a random one
fx_array_circle_small           = [
                                fx_small_circle1,
                                fx_small_circle2,
                                fx_small_circle3,
                                fx_small_circle4,
                                ];

fx_array_circle_medium          = [
                                fx_medium_circle1
                                ];

fx_array_circle_large           = [
                                fx_large_circle1
                                ];

fx_array_circle_small_angled    = [
                                fx_small_circle_angled1
                                ];

fx_array_circle_medium_angled   = [
                                fx_medium_circle_angled1,
                                fx_medium_circle_angled2,
                                ];

fx_array_circle_large_angled    = [
                                fx_large_circle_angled1
                                ];

fx_array_flare                  = [
                                fx_small_flare1_0,
                                fx_small_flare1_1,
                                fx_small_flare1_2,
                                fx_small_flare1_3
                                ];
                                
fx_array_spark                  = [
                                fx_small_spark1_0,
                                fx_small_spark1_1,
                                fx_small_spark1_2,
                                fx_small_spark1_3
                                ];

fx_array_shine                  = [
                                fx_small_shine0,
                                fx_small_shine1,
                                fx_small_shine2,
                                fx_small_shine3
                                ];

fx_array_flashlight             = [
                                fx_small_flashlight1
                                ];
*/

fx_crit                     = hit_fx_create(sprite_get("vfx_crit"), 24);
fx_crit_blood               = hit_fx_create(sprite_get("vfx_crit_blood"), 24);
fx_crit_shock               = hit_fx_create(sprite_get("vfx_crit_shock"), 24);
fx_crit_shock_long          = hit_fx_create(sprite_get("vfx_crit_shock"), 50);
fx_blast                    = hit_fx_create(sprite_get("vfx_blast"), 17);
fx_item_res                 = hit_fx_create(sprite_get("vfx_item_res"), 160);

fx_small_chest_land         = hit_fx_create(sprite_get("dspec_smallchest_landvfx"), 16);
fx_large_chest_land         = hit_fx_create(sprite_get("dspec_largechest_landvfx"), 16);

//=-(                      ~~//** BASE STATS **//~~                        )-=//

//                              --hurtboxes--                                 //
hurtbox_spr                     = asset_get("ex_guy_hurt_box");
crouchbox_spr                   = asset_get("ex_guy_crouch_box");
air_hurtbox_spr                 = -1;
hitstun_hurtbox_spr             = -1;


//                  --animation speeds + %-arrow offset--                     //
char_height                     = 60;
idle_anim_speed                 = .1;
crouch_anim_speed               = 0.03;
walk_anim_speed                 = 0.125;
dash_anim_speed                 = 0.2;
pratfall_anim_speed             = 0.25;
walk_anim_speed_base            = walk_anim_speed;
dash_anim_speed_base            = dash_anim_speed;

//                      --grounded movement stats--                           //
walk_speed                      = 2.4;
walk_accel                      = 0.2;
walk_turn_time                  = 6;
initial_dash_time               = 12;
initial_dash_speed              = 6;
dash_speed                      = 5.5;
dash_turn_time                  = 10;
dash_turn_accel                 = 1.5;
dash_stop_time                  = 8;
dash_stop_percent               = 0.35;
ground_friction                 = 0.7;
moonwalk_accel                  = 1.4;
walk_speed_base                 = walk_speed;
walk_accel_base                 = walk_accel;
initial_dash_speed_base         = initial_dash_speed;
dash_speed_base                 = dash_speed;


//                       --aerial movement stats--                            //
jump_start_time                 = 5; // minus one
jump_speed                      = 11;
short_hop_speed                 = 6;
djump_speed                     = 10;
jump_speed_base                 = jump_speed;
short_hop_speed_base            = short_hop_speed;
djump_speed_base                = djump_speed;

leave_ground_max                = 7;
max_jump_hsp                    = 6;
air_max_speed                   = 5;
jump_change                     = 3;
max_jump_hsp_base               = max_jump_hsp;
air_max_speed_base              = air_max_speed;

air_accel                       = 0.3;
prat_fall_accel                 = 0.85;
air_friction                    = 0.04;

max_djumps                      = 1;
double_jump_time                = 28;
max_djumps_base                 = max_djumps

walljump_hsp                    = 7;
walljump_vsp                    = 8;
walljump_time                   = 15;
wall_frames                     = 2;
walljump_vsp_base               = walljump_vsp;

max_fall                        = 10;
fast_fall                       = 14;
gravity_speed                   = 0.5;
hitstun_grav                    = 0.5;
max_fall_base                   = max_fall;
fast_fall_base                  = fast_fall;
gravity_speed_base              = gravity_speed;

//                    --character knockback adjustment--                      //
/* 
- higher num = 'lighter' character; 
- lower num = 'heavier' character 
*/
knockback_adj                   = 1.0;
knockback_adj_base              = knockback_adj;

//                           --landing stats--                                //
land_time                       = 4; 
prat_land_time                  = 10;
wave_land_time                  = 8;
wave_land_adj                   = 1.35;
wave_friction                   = 0.12;

//                          --animation frames--                              //
crouch_startup_frames           = 1;
crouch_active_frames            = 2;
crouch_recovery_frames          = 1;

dodge_startup_frames            = 1;
dodge_active_frames             = 2;
dodge_recovery_frames           = 2;

tech_active_frames              = 3;
tech_recovery_frames            = 1;

techroll_startup_frames         = 2
techroll_active_frames          = 2;
techroll_recovery_frames        = 2;


air_dodge_startup_frames        = 1;
air_dodge_active_frames         = 1;
air_dodge_recovery_frames       = 2;

roll_forward_startup_frames     = 1;
roll_forward_active_frames      = 3;
roll_forward_recovery_frames    = 2;

roll_back_startup_frames        = 1;
roll_back_active_frames         = 3;
roll_back_recovery_frames       = 2;

//                        --defensive action speed--                          //
techroll_speed                  = 10;

air_dodge_speed                 = 7.5;

roll_forward_max                = 9; 
roll_backward_max               = 9;

//                      --base movement sound effects--                       //
land_sound                      = asset_get("sfx_land_med");
landing_lag_sound               = asset_get("sfx_land");
waveland_sound                  = asset_get("sfx_waveland_zet");
jump_sound                      = asset_get("sfx_jumpground");
djump_sound                     = asset_get("sfx_jumpair");
air_dodge_sound                 = asset_get("sfx_quick_dodge");

//                       --ranno bubble visual offset--                       //
bubble_x                        = 0;
bubble_y                        = 8;

//win stuff
set_victory_portrait(sprite_get("portrait_base") ) 

// DEBUG | TODO: remove before beta
new_item_id = noone;
user_event(0);
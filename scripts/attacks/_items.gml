// Essentially a dumping ground for random item hitboxes.

var atk             = AT_EXTRA_1;
var window_num      = 1;
var window_length   = 0;

//                        --attack windows--                                  //
set_attack_value(atk, AG_SPRITE                         , sprite_get("null"));
set_attack_value(atk, AG_HURTBOX_SPRITE                 , sprite_get("null"));
set_attack_value(atk, AG_NUM_WINDOWS                    , 1);
set_attack_value(atk, AG_CATEGORY                       , 0);


//                        --attack hitboxes--                                 //
set_num_hitboxes(atk, 0);

// Brilliant Behemoth explosion
var hbox_num = 1;
set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 2);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 1);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 0);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , 0);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 70);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 70);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 3); // this is actually used
set_hitbox_value(atk, hbox_num, HG_EFFECT                   , 0);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 90); // aside from damage, most of the actual stats get overwritten
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 1);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 0);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_mol_norm_explode"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_SPRITE        , sprite_get("null"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_MASK          , -1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DESTROY_EFFECT, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_WALL_BEHAVIOR , 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_GROUND_BEHAVIOR, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_ENEMY_BEHAVIOR, 0);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_UNBASHABLE    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PARRY_STUN    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DOES_NOT_REFLECT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_IS_TRANSCENDENT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PLASMA_SAFE   , true);
set_hitbox_value(atk, hbox_num, HG_IS_BLAST             , true);


// Ol' Lopper hitbox
var hbox_num = 2;
set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 2);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 1);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 0);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , 0);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 60);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 98);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 8);
set_hitbox_value(atk, hbox_num, HG_EFFECT                   , 0);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 90);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 8);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0.5);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 10);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0.5);
set_hitbox_value(atk, hbox_num, HG_HITSTUN_MULTIPLIER       , 1);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , HFX_GEN_BIG);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_heavy1"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_SPRITE        , sprite_get("null"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_MASK          , -1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DESTROY_EFFECT, -1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_WALL_BEHAVIOR , 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_GROUND_BEHAVIOR, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_ENEMY_BEHAVIOR, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_UNBASHABLE    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PARRY_STUN    , true);
set_hitbox_value(atk, hbox_num, HG_EXTENDED_PARRY_STUN      , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DOES_NOT_REFLECT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_IS_TRANSCENDENT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PLASMA_SAFE   , true); // TBD honestly??

// Sticky bomb explosion
var hbox_num = 3;
set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 2);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 1);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 0);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , 0);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 30);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 30);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 3);
set_hitbox_value(atk, hbox_num, HG_EFFECT                   , 0);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 90);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 5);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0.3);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 5);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0.5);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_mol_norm_explode"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_SPRITE        , sprite_get("null"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_MASK          , -1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DESTROY_EFFECT, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_WALL_BEHAVIOR , 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_GROUND_BEHAVIOR, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_ENEMY_BEHAVIOR, 0);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_UNBASHABLE    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PARRY_STUN    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DOES_NOT_REFLECT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_IS_TRANSCENDENT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PLASMA_SAFE   , true);

// Headstompers: falling, air-only
var hbox_num = 4;
set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 1);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 120);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 0);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -16);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 48);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 40);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 1);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 270);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 3);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 2);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , HFX_GEN_OMNI);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , 32);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , 10);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_weak1"));
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , 1);
set_hitbox_value(atk, hbox_num, HG_GROUNDEDNESS             , 2);
set_hitbox_value(atk, hbox_num, HG_EFFECT                   , 9); // polite
set_hitbox_value(atk, hbox_num, HG_HITSTUN_MULTIPLIER       , 0.5);

// Headstompers: falling, ground-only
var hbox_num = 5;
set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 1);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 120);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 0);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -16);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 48);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 40);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 1);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 90);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 3);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 2);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , HFX_GEN_OMNI);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , 10);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_weak1"));
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , 1);
set_hitbox_value(atk, hbox_num, HG_GROUNDEDNESS             , 1);
set_hitbox_value(atk, hbox_num, HG_FORCE_FLINCH             , 1);
set_hitbox_value(atk, hbox_num, HG_EFFECT                   , 12); // crouch armor

// Headstompers: landing, ground-only
var hbox_num = 6;
set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 1);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 3);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 0);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -20);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 1);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 70);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 40);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 2);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 90);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 6);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , .3);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 4);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , HFX_GEN_OMNI);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , 6);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_medium1"));
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , 2);
set_hitbox_value(atk, hbox_num, HG_GROUNDEDNESS             , 1);
set_hitbox_value(atk, hbox_num, HG_EFFECT                   , 12); // crouch armor
set_hitbox_value(atk, hbox_num, HG_HITSTUN_MULTIPLIER       , 0.5);
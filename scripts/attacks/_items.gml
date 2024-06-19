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
set_num_hitboxes(atk, 1);
var hbox_num = 1;

// Fireman's boots fire proc
set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 2);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 1);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 0);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , 0);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 1);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 28);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 38);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 0);
set_hitbox_value(atk, hbox_num, HG_EFFECT                   , 1);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 90);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 0.001);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 0);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0);
set_hitbox_value(atk, hbox_num, HG_HITSTUN_MULTIPLIER       , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_burnapplied"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_SPRITE        , sprite_get("null"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_MASK          , -1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DESTROY_EFFECT, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_WALL_BEHAVIOR , 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_GROUND_BEHAVIOR, 1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_ENEMY_BEHAVIOR, 0);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_UNBASHABLE    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PARRY_STUN    , false);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DOES_NOT_REFLECT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_IS_TRANSCENDENT, true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PLASMA_SAFE   , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_FAKE_HIT      , true);
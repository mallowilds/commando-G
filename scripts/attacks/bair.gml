var atk             = AT_BAIR;
var window_num      = 1;
var window_length   = 0;

//                        --attack windows--                                  //
set_attack_value(atk, AG_SPRITE                         , sprite_get("bair"));
set_attack_value(atk, AG_HURTBOX_SPRITE                 , sprite_get("bair_hurt"));
set_attack_value(atk, AG_NUM_WINDOWS                    , 5); // tampered with (5-7 depending on landing hit, see attack_update.gml)
set_attack_value(atk, AG_CATEGORY                       , 1); // tampered with
set_attack_value(atk, AG_HAS_LANDING_LAG                , 1);
set_attack_value(atk, AG_LANDING_LAG                    , 6);

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0); //startup
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 7);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 0);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 2);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_SFX, true);
set_window_value(atk, window_num                        , AG_WINDOW_SFX, asset_get("sfx_swipe_medium1"));
set_window_value(atk, window_num                        , AG_WINDOW_SFX_FRAME, window_length-1);
window_num++;

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0); //active gunwhip - 2 active 2 endlag
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 4);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 2);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 2);
set_window_value(atk, window_num                        , AG_WINDOW_SFX, asset_get("sfx_swipe_weak1"));
set_window_value(atk, window_num                        , AG_WINDOW_HAS_SFX, true);
set_window_value(atk, window_num                        , AG_WINDOW_SFX_FRAME, window_length-1);
window_num++;


set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0); //gunshot multihit - 2 active 4 endlag
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 6);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 4);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 3);
set_window_value(atk, window_num                        , AG_WINDOW_SFX, asset_get("sfx_swipe_medium2"));
// set_window_value(atk, window_num                        , AG_WINDOW_HAS_SFX, true); // handled manually
set_window_value(atk, window_num                        , AG_WINDOW_SFX_FRAME, window_length-1);
window_num++;


set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0); //active gunshot final
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 2);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 7);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 1);
window_num++;

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0); //endlag
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 14);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 8);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 3);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_WHIFFLAG, 1);
window_num++;

// -- Landing hitboxes --

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0); //active gunshot final
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 2);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 7);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 1);
window_num++;

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0); //endlag
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 14);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 8);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 3);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_WHIFFLAG, 1);
window_num++;



//                        --attack hitboxes--                                 //
set_num_hitboxes(atk, 4);
var hbox_num = 1; //whip hitbox

set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , 1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 2);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 0);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , -32);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -34);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 77);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 27);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 2);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 2);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 45);
set_hitbox_value(atk, hbox_num, HG_ANGLE_FLIPPER            , 5);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 5);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 4);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , -30);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , -10);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_medium2"));

var hbox_num = 2; //gunshot multihit hitbox

set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , -1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 3);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 0);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , -45);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -44);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 67);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 69);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 2);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 1);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 45);
set_hitbox_value(atk, hbox_num, HG_ANGLE_FLIPPER            , 5);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 5);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 4);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , -30);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , -10);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_weak1"));

var hbox_num = 3; //gunshot multihit hitbox

set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , -1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 4);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 0);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , -45);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -44);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 72);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 74);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 2);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 3);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 45);
set_hitbox_value(atk, hbox_num, HG_ANGLE_FLIPPER            , 5);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 7);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , .5);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 6);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , .5);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , -30);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , -10);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_medium3"));
set_hitbox_value(atk, hbox_num, HG_IS_GUNSHOT               , 1);

var hbox_num = 4; //gunshot multihit landing hitbox

set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , -1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 6);
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 0);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , -45);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -44);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 0);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 72);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 74);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 2);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 3);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 45);
set_hitbox_value(atk, hbox_num, HG_ANGLE_FLIPPER            , 5);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 7);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , .5);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 6);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , .5);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , -30);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , -10);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_medium3"));
set_hitbox_value(atk, hbox_num, HG_IS_GUNSHOT               , 1);

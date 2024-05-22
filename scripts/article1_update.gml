//a
state_timer += 1;

switch(state) { // use this one for doing actual article behavior
    case 0: // spawn
        if (state_timer == 25) { // go to idle state after 25 frames
            set_state(1);
        }
        break;
    case 1: // idle
        if (state_timer == 50) { // go to dead state after 50 frames
            set_state(2);
        }
        break;
    case 2: //die
        if (state_timer == 20) { // die after 20 frames
            should_die = true;
        }
        break;
}

switch(state) { // use this one for changing sprites and animating
    case 0: // spawn
        sprite_index = sprite_get("nair");
        image_index = state_timer * anim_speed;
        break;
    case 1: // idle
        sprite_index = sprite_get("idle");
        image_index = state_timer * anim_speed;
        break;
    case 2: //die
        sprite_index = sprite_get("hurt");
        image_index = state_timer * anim_speed;
        break;
}
// don't forget that articles aren't affected by small_sprites

if (should_die) { //despawn and exit script
    instance_destroy();
    exit;
}


#define set_state
var _state = argument0;
state = _state;
state_timer = 0;
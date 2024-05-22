//a



// reset idle_air_looping if the character isn't in air idle anymore
if (!(state == PS_FIRST_JUMP || state == PS_IDLE_AIR)) {
	idle_air_looping = false;
	idle_air_platfalling = false;
}

// remove attack air limit once character lands, respawns, walljumps or is hit
if (attack_air_limit_ver) {
	if ((!free || state == PS_RESPAWN || state == PS_WALL_JUMP || state == PS_HITSTUN) && state_timer == 1) {
		for(var i=0;i<array_length(attack_air_limit);i++) {
			attack_air_limit[i] = false;
		}
		attack_air_limit_ver = false;
	}
}

// character recoloring / applying shade values
// init_shader(); //unused for now
// composite vfx update
update_comp_hit_fx();

#define update_comp_hit_fx
//function updates comp_vfx_array
if comp_vfx_array != null {
    for(var ao=0;ao<array_length(comp_vfx_array);ao++) {
        if (comp_vfx_array[ao][0].cur_timer > comp_vfx_array[ao][0].max_timer) { //if effect is over, skip
            continue;
        }//otherwise go on
        comp_vfx_array[ao][0].cur_timer += 1; //update effect timer
        var check_timer = comp_vfx_array[ao][0].cur_timer; //store in a var for easier access
        for (var ae=1; ae<array_length(comp_vfx_array[ao]);ae++) { //check effect timers
            if (check_timer == comp_vfx_array[ao][ae].delay_timer) { //if timer is the spawn time, spawn it
                var new_fx = spawn_hit_fx(comp_vfx_array[ao][ae].x,comp_vfx_array[ao][ae].y,comp_vfx_array[ao][ae].index);
                new_fx.draw_angle = comp_vfx_array[ao][ae].rotation;
                new_fx.depth = depth+1+comp_vfx_array[ao][ae].depth; //so it appears in front of hit players
                new_fx.spr_dir = comp_vfx_array[ao][ae].spr_dir; // set it's spr dir, in case it should face a specific direction
            }
        }
    }
}

#define spawn_comp_hit_fx
//function takes in an array that contains smaller arrays with the vfx information
// list formatting: [ [x, y, delay_time, index, rotation, depth, force_dir], ..]
var fx_list = argument0;
vfx_created = false;

//temporary array
var temp_array = [{cur_timer: -1, max_timer: 0}];  //first value is an array that constains current and max timer, to detect when to spawn vfx and when to stop and be replaced
                            //later values are the fx
var player_dir = spr_dir;

//first take the arrays from the function, set them into objects, and store them in an array
for (var i=0;i < array_length(fx_list);i++) {
    //create new fx part tracker and add to temp array
    var new_fx_part = {
        x: fx_list[i][0],
        y: fx_list[i][1],
        delay_timer: fx_list[i][2],
        index: fx_list[i][3],
        rotation: fx_list[i][4],
        depth: fx_list[i][5],
        spr_dir: fx_list[i][6] == 0 ? player_dir : fx_list[i][6]
    };
    array_push(temp_array, new_fx_part);
    
    //change max timer if delay is bigger than it
    if (new_fx_part.delay_timer > temp_array[0].max_timer) {
        temp_array[0].max_timer = new_fx_part.delay_timer;
    }
}

//add temp array to final array
for (var e=0;e<array_length(comp_vfx_array);e++) {
    if (vfx_created) { //stop process if effect is created
        break;
    } 
    if (comp_vfx_array[e][0].cur_timer > comp_vfx_array[e][0].max_timer) { //replace finished effects
        comp_vfx_array[e] = temp_array;
        vfx_created = true;
    } else if (e == array_length(comp_vfx_array)-1) { //otherwise add it in the end of the array
        array_push(comp_vfx_array, temp_array);
        vfx_created = true;
    }
}

#define spawn_base_dust // written by supersonic
/// spawn_base_dust(x, y, name, dir = 0)
var dlen; //dust_length value
var dfx; //dust_fx value
var dfg; //fg_sprite value
var dfa = 0; //draw_angle value
var dust_color = 0;
var x = argument[0], y = argument[1], name = argument[2];
var dir = argument_count > 3 ? argument[3] : 0;

switch (name) {
	default: 
	case "dash_start":dlen = 21; dfx = 3; dfg = 2626; break;
	case "dash": dlen = 16; dfx = 4; dfg = 2656; break;
	case "jump": dlen = 12; dfx = 11; dfg = 2646; break;
	case "doublejump": 
	case "djump": dlen = 21; dfx = 2; dfg = 2624; break;
	case "walk": dlen = 12; dfx = 5; dfg = 2628; break;
	case "land": dlen = 24; dfx = 0; dfg = 2620; break;
	case "walljump": dlen = 24; dfx = 0; dfg = 2629; dfa = dir != 0 ? -90*dir : -90*spr_dir; break;
	case "n_wavedash": dlen = 24; dfx = 0; dfg = 2620; dust_color = 1; break;
	case "wavedash": dlen = 16; dfx = 4; dfg = 2656; dust_color = 1; break;
}
var newdust = spawn_dust_fx(x,y,asset_get("empty_sprite"),dlen);
if newdust == noone return noone;
newdust.dust_fx = dfx; //set the fx id
if dfg != -1 newdust.fg_sprite = dfg; //set the foreground sprite
newdust.dust_color = dust_color; //set the dust color
if dir != 0 newdust.spr_dir = dir; //set the spr_dir
newdust.draw_angle = dfa;
return newdust;

if (bufferStore == undefined) {
	draw_text(10, 10, "No store loaded. Press down to load 500 byte block store.");
	
	if (keyboard_check_pressed(vk_down)) {
		bufferStore = bs_create("visualTest", 500, 2000, false);
	}

	return 0;
} 

draw_set_color(c_white);
draw_text(10, 10, bufferStore.source_filename + " active.\n"+string(ds_map_size(bufferStore.loaded_blocks)) + " active blocks.\nLeft to store random 5-50 byte block\nRight to remove random block\nUp to load random block");

var lh = 32;
var pad = 32;
var lw = display_get_gui_width()-pad*2;
var curH = 100;

var blocksize = bufferStore.blocksize;

var key = ds_map_find_first(bufferStore.loaded_blocks);
while (key != undefined) {
	draw_set_color(c_white);
	draw_rectangle(pad, curH, lw+pad, curH+lh, 1);
	fkey = ds_map_find_first(bufferStore._fat_map);
	while (fkey != undefined) {
		var fitem = bufferStore._fat_map[? fkey];
		if (fitem[@ 0] == key) {
			draw_set_color(c_green);
			var off = (fitem[@ 1] / blocksize)*lw;
			var siz = (fitem[@ 2] / blocksize)*lw;
			
			var x1 = pad+off;
			var x2 = pad+off+siz;
			
			var y1 = curH;
			var y2 = curH+lh;
			
			var mx = window_mouse_get_x();
			var my = window_mouse_get_y();
			
			if (mx > x1 && mx < x2 && my > y1 && my < y2) {
				draw_rectangle(x1, y1, x2, y2, 0);
				draw_set_color(c_white);
				draw_text(500, 10, "Selected:\nBlock: "+string(key)+"\nBuffer: " + string(fkey) + "\n" + string(fitem[@ 2]) + " bytes" );
				draw_set_color(c_green);
			}
			
			draw_rectangle(x1, y1, x2, y2, 1);
		}
		fkey = ds_map_find_next(bufferStore._fat_map, fkey);
	}

	var elist = bufferStore._empty_list[| round(key)];
	for (var _em = 0; _em < ds_list_size(elist); _em++) {
		draw_set_color(c_blue);
		var eitem = elist[| _em];
		var off = (eitem[@ 0] / blocksize)*lw;
		var siz = (eitem[@ 1] / blocksize)*lw;
			
		var x1 = pad+off;
		var x2 = pad+off+siz;
			
		var y1 = curH;
		var y2 = curH+lh;
			
		var mx = window_mouse_get_x();
		var my = window_mouse_get_y();
			
		if (mx > x1 && mx < x2 && my > y1 && my < y2) {
			draw_rectangle(x1, y1, x2, y2, 0);
			draw_set_color(c_white);
			draw_text(500, 10, "Selected:\nBlock: "+string(key)+"\Empty space record " + string(_em) + "\n" + string(eitem[@ 1]) + " bytes" );
			draw_set_color(c_blue);
		}
			
		draw_rectangle(x1, y1, x2, y2, 1);
	}
	
	key = ds_map_find_next(bufferStore.loaded_blocks, key);
	curH += lh + pad/2;
	
	if (bufferStore.__storing_buffer) {
		draw_text(500, room_height-20, "SAVING ASYNC!!");
	}
	
}


if (keyboard_check_pressed(ord("S"))) {
	bs_persist(bufferStore);
}


if (keyboard_check_pressed(vk_left)) {
	bSize = round(random_range(5, 50));
	buffer = buffer_create(bSize, buffer_fixed, 1);
	repeat (bSize) {
		buffer_write(buffer, buffer_u8, bSize);
	}
	bs_save(bufferStore, buffer, string(get_timer())+"/"+string(random(500000)));
	buffer_delete(buffer);
}

if (keyboard_check_pressed(vk_right)) {
	
	var tlist = ds_list_create();
	fkey = ds_map_find_first(bufferStore._fat_map);
	while (fkey != undefined) {
		ds_list_add(tlist, fkey);
		fkey = ds_map_find_next(bufferStore._fat_map, fkey);
	}
	
	ds_list_shuffle(tlist);
	
	bs_delete(bufferStore, tlist[| 0]);
	ds_list_destroy(tlist);
}

if (keyboard_check_pressed(vk_up)) {
	var tlist = ds_list_create();
	fkey = ds_map_find_first(bufferStore._fat_map);
	while (fkey != undefined) {
		ds_list_add(tlist, fkey);
		fkey = ds_map_find_next(bufferStore._fat_map, fkey);
	}
	
	ds_list_shuffle(tlist);
	
	var temp = bs_load(bufferStore, tlist[| 0]);
	show_debug_message("Loaded block @ " + string(buffer_get_size(temp))+ " bytes, content:" + string(buffer_read(temp, buffer_u8)));
	buffer_delete(temp);
	ds_list_destroy(tlist);
}


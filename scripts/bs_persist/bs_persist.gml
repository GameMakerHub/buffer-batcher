///@param bufferStore
var bufferStore = argument0;

//Save
with (bufferStore) {
	if (__storing_buffer) {
		show_debug_message("Store is already being saved...");
		return 0;
	}
	if (!validation) {
		show_debug_message(" ------ START PERSIST ");
		__storing_buffer_starttime = get_timer();
		var start = get_timer();
		file_text_close(_meta_file);
	
		_meta_file = file_text_open_write(source_meta_filename);
		file_text_write_string(_meta_file, "bsm");
		file_text_writeln(_meta_file);
		file_text_write_string(_meta_file, blocksize);
		file_text_writeln(_meta_file);
		file_text_write_string(_meta_file, blocks); //blocks
		file_text_writeln(_meta_file);
		file_text_write_string(_meta_file, ds_map_write(_fat_map));
		file_text_writeln(_meta_file);
		
		for (var i = 0; i < blocks; i++) {
			file_text_write_string(_meta_file, ds_list_write(_empty_list[| i]));
			file_text_writeln(_meta_file);
		}

		file_text_close(_meta_file);
		show_debug_message("Bufferstore: Stored bufferstore FAT: " + source_meta_filename + " blocksize: "+string(init_blocksize));
		_meta_file = file_text_open_read(source_meta_filename);
		show_debug_message(" ------ PERSISTED META IN " +string((get_timer()-start)/1000) + "ms");
		show_debug_message(" ------ START PERSIST BLOCKS");
		var startBlock = get_timer();
		
		var key = ds_map_find_first(loaded_blocks);
		if (key != undefined) {
			__storing_buffer = true;
			buffer_async_group_begin(source_filename);
			while (key != undefined) {
				buffer_save_async(loaded_blocks[? key], string(key)+".bsd", 0, buffer_get_size(loaded_blocks[? key]));
				key = ds_map_find_next(loaded_blocks, key);
			}
			__storing_buffer_id = buffer_async_group_end();
		}
		show_debug_message(" ------ PERSIST CALL "+string(ds_map_size(loaded_blocks))+" BLOCKS IN " +string((get_timer()-startBlock)/1000) + "ms");
		
	}
}
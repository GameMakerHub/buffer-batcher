///Initialze the buffer store

source_meta_filename = source_filename + "/meta.bsm";

if (!file_exists(source_meta_filename)) {
	_meta_file = file_text_open_write(source_meta_filename);
	file_text_write_string(_meta_file, "bsm");
	file_text_writeln(_meta_file);
	file_text_write_string(_meta_file, init_blocksize);
	file_text_writeln(_meta_file);
	file_text_write_string(_meta_file, 0); //blocks
	file_text_writeln(_meta_file);
	file_text_close(_meta_file);
	if (debug) show_debug_message("Bufferstore: Created new bufferstore FAT: " + source_meta_filename + " blocksize: "+string(init_blocksize));
} else {
	if (debug) show_debug_message("Bufferstore: Loaded bufferstore FAT: " + source_meta_filename + " blocksize: "+string(init_blocksize));	
}
_meta_file = file_text_open_read(source_meta_filename);

var check = file_text_read_string(_meta_file); file_text_readln(_meta_file);
if (check != "bsm") {
	if (debug) show_debug_message("Bufferstore: Not a bufferstore FAT: " + source_meta_filename + "("+check+")");
	instance_destroy();
	return false;
}

blocksize = real(file_text_read_string(_meta_file)); file_text_readln(_meta_file);
if (debug) show_debug_message("Bufferstore: Loaded blocksize: " + string(blocksize));

//@todo load blocks from meta file
blocks = real(file_text_read_string(_meta_file)); file_text_readln(_meta_file);
loaded_blocks = ds_map_create();
if (debug) show_debug_message("Bufferstore: DB Contains blocks: " + string(blocks));

_fat_map = ds_map_create();
var str = file_text_read_string(_meta_file); file_text_readln(_meta_file);
if (string_length(str) > 0) {
	ds_map_read(_fat_map, str);
}

if (debug) show_debug_message("Bufferstore: FATMAP: " + string(ds_map_size(_fat_map)));

_empty_list = ds_list_create();
for (var i = 0; i < blocks; i++) {
	var str = file_text_read_string(_meta_file); file_text_readln(_meta_file);
	if (string_length(str) > 0) {
		_empty_list[| i] = ds_list_create();
		ds_list_read(_empty_list[| i], str);
	}	
}

if (debug) show_debug_message("Bufferstore: EMPTYLIST: " + string(ds_list_size(_empty_list)));
/*
if (blocks == 0) {
	ds_list_add(loaded_blocks, buffer_create(blocksize, buffer_fast, 1));
	_empty_list[| 0] = ds_list_create();
	ds_list_add(_empty_list[| 0], [0, blocksize]); //empty from 0 to end
	show_debug_message("Bufferstore: No blocks yet exist so created first empty block");
}*/
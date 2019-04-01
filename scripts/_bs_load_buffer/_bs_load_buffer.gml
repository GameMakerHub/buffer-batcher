///@param bufferStore
///@param name
///@return buffer or -1

var bufferStore = argument0;
var name = argument1;

//Find file
with (bufferStore) {
	var item = _fat_map[? name];
	if (is_undefined(item)) {
		show_debug_message("Not found:"+string(name));
		return -1;
	}

	var storageBlock = _bs_load_block(item[@ 0]);

	var buffer = buffer_create(item[@ 2], buffer_fixed, 1);
	buffer_copy(storageBlock, item[@ 1], item[@ 2], buffer, 0);
	return buffer;
}
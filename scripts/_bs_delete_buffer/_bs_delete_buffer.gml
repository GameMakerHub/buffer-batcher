///@param bufferStore
///@param name

var bufferStore = argument0;
var name = argument1;

with (bufferStore) {

	var item = _fat_map[? name];
	if (is_undefined(item)) {
		show_debug_message("Trying to delete non-existing:"+string(name));
		return false;
	}

	var storageBlock = _bs_load_block(item[@ 0]);
	
	buffer_fill(storageBlock, item[@ 1], buffer_u8, 255, item[@ 2]);

	
	var _blockEmptySpace = [item[@ 1], item[@ 2]];
	//Find neighbouring empty spaces
	
	if (!_bs_combine_empty(bufferStore, item[@ 0], _blockEmptySpace)) {
		ds_list_add(_empty_list[| item[@ 0]], _blockEmptySpace); //empty from 0 to end
	}
	
	//Remove from fat list
	ds_map_delete(_fat_map, name);
	
	return true;
}

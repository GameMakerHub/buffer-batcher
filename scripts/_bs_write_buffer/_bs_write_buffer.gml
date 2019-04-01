///@param bufferStore
///@param name
///@param buffer

var bufferStore = argument0;
var name = argument1;
var buffer = argument2;

if (bs_exists(bufferStore, name)) {
	bs_delete(bufferStore, name);
}

var bSize = buffer_get_size(buffer);
var position = _bs_find_empty(bufferStore, bSize);
var _block = position[@ 0];
var _blockEmptySpace = position[@ 1];
//return [_block, __i];

with (bufferStore) {
	//Open right file buffer
	var storageBlock = _bs_load_block(_block);
	
	buffer_copy(buffer, 0, bSize, storageBlock, _blockEmptySpace[@ 0]);
	//show_debug_message("Copied "+string(bSize)+" to position "+string(_blockEmptySpace[@ 0])+" of block "+string(_block));

	//Add to fat list
	ds_map_add(_fat_map, name, [_block, _blockEmptySpace[@ 0], bSize]);

	//Shift old entry
	_blockEmptySpace[@ 0] += bSize;
	_blockEmptySpace[@ 1] -= bSize;	
}
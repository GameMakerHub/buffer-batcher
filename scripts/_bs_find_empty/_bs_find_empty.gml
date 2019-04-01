///@param bufferStore
///@param bufferSize
///@return [empty starting position, filename]
var bufferStore = argument0;
var bSize = argument1;

//loop through fatmap
with (bufferStore) {
	
	var blockNumber = 0;
	for (var _block = 0; _block<blocks; _block++) {
		var _blockEmptyList = _empty_list[| _block];
		var _blockEmptySize = ds_list_size(_blockEmptyList);
		if (_blockEmptySize > 0) {
			//show_debug_message("Block #"+string(_block)+" has empty space");
			for (var __i = 0; __i < _blockEmptySize; __i++) {
				var _blockEmptySpace = _blockEmptyList[| __i];
				//show_debug_message("Checking empty space in unallocated space #"+string(__i)+": "+string(_blockEmptySpace[@ 1]));
				if (_blockEmptySpace[@ 1] >= bSize) {
					//show_debug_message("Found fitting space in block #"+string(_block)+" emptyalloc #"+string(__i));
					return [_block, _blockEmptySpace];
				}
			}
		}
	}
	//show_debug_message("Could not find empty blocks, creating new block");
	
	//Creating new block
	ds_map_add(loaded_blocks, blocks, buffer_create(blocksize, buffer_fast, 1));
	_empty_list[| blocks] = ds_list_create();
	var _blockEmptySpace = [0, blocksize];
	ds_list_add(_empty_list[| blocks], _blockEmptySpace); //empty from 0 to end
	show_debug_message("Created block number "+string(blocks));
	
	blocks++;
	return [blocks-1, _blockEmptySpace]; //First empty space is always it
}
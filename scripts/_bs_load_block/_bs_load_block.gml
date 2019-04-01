///@param _blockId
///@return buffer
var _blockId = argument0;

//Find file

var block = loaded_blocks[? _blockId];
if (is_undefined(block)) {
	show_debug_message("Loading unloaded block: "+string(_blockId));
	block = buffer_load(source_filename + "/"+string(_blockId)+".bsd");
	ds_map_add(loaded_blocks, _blockId, block);
}

return block;
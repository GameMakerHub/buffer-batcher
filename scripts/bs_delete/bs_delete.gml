///@param bufferStore
///@param name
function bs_delete(argument0, argument1) {
	var bufferStore = argument0;
	var name = argument1;
	if (bufferStore.validation) {
		return file_delete(bufferStore.source_filename + "/" + name);
	} else {
		return _bs_delete_buffer(bufferStore, name);
	}
}
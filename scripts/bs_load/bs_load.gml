///@param bufferStore
///@param name
function bs_load(argument0, argument1) {
	var bufferStore = argument0;
	var name = argument1;
	if (bufferStore.validation) {
		return buffer_load(bufferStore.source_filename + "/" + name);
	} else {
		return _bs_load_buffer(bufferStore, name);
	}
}
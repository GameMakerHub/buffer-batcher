///@param bufferStore
///@param name
var bufferStore = argument0;
var name = argument1;
if (bufferStore.validation) {
	return file_delete(bufferStore.source_filename + "/" + name);
} else {
	return _bs_delete_buffer(bufferStore, name);
}
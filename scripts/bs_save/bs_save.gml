///@param bufferStore
///@param buffer
///@param name
var bufferStore = argument0;
var buffer = argument1;
var name = argument2;
if (bufferStore.validation) {
	return buffer_save(buffer, bufferStore.source_filename + "/" + name);
} else {
	return _bs_write_buffer(bufferStore, name, buffer);
}
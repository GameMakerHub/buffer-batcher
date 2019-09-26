///@param filename
///@param blocksize
///@param memory limit in bytes
///@param validation (true = use real ondisk for comparison)

var bufferStore;

bufferStore = instance_create_depth(0, 0, 0, bs_obj_store);
bufferStore.source_filename = string(argument0);
bufferStore.init_blocksize = argument1;
bufferStore.memory_limit = argument2;
bufferStore.validation = argument3;
bufferStore.debug = false;
bufferStore.__storing_buffer = false;
bufferStore.__storing_buffer_id = undefined;

if (!bufferStore.validation) {
	with (bufferStore) {
		_bs_init();
	}
}

return bufferStore;
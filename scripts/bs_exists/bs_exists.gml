///@param bufferStore
///@param name
function bs_exists(argument0, argument1) {
	var bufferStore = argument0;
	var name = argument1;
	if (bufferStore.validation) {
		return file_exists(bufferStore.source_filename + "/" + name);
	} else {
		with (bufferStore) {
			var item = _fat_map[? name];
			if (is_undefined(item)) {
				return false;
			}
			return true;
		}
	}
}
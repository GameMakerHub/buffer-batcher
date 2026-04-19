///@param bufferStore
function bs_destroy(argument0) {
	var bufferStore = argument0;

	//Destroy
	with (bufferStore) {
		instance_destroy();
	}
}
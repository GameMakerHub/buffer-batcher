//Check all

if (__storing_buffer) {
	if (async_load[? "id"] == __storing_buffer_id) {
		__storing_buffer_id = undefined;
		if (async_load[? "status"]) {
			show_debug_message(" ------ ASYNC SUCCESS SAVED PART");
		} else {
			show_debug_message(" ------ ASYNC FAILED SAVE PART");
		}
		__storing_buffer = false;
		show_debug_message(" ------ ASYNC PERSISTED TOTAL IN " +string((get_timer()-__storing_buffer_starttime)/1000) + "ms");
	}
}
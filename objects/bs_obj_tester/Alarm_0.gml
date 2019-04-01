randomize();
var bsize = 256*1024;
bufferStore = bs_create("newstore", bsize, bsize*4, validation);
var randomVal = random(123873492);
writeOps = 0;
readOps = 0;
var totalstart = get_timer();
var start = get_timer();
for (var number = 0; number < 500; number++) {
	var buffer = buffer_create(1024, buffer_fixed, 1);
	repeat (256) {
		buffer_write(buffer, buffer_u32, randomVal);
	}
	bs_save(bufferStore, buffer, "testing/buffer/number/"+string(number)+".blk");
	writeOps ++;
	buffer_delete(buffer);
}

show_debug_message("Written 500 1kb files in " +string((get_timer()-start)/1000) + "ms");

start = get_timer();
for (var number = 0; number < 500; number++) {
	var buffer = buffer_create(1024, buffer_fixed, 1);
	repeat (50) {
		buffer_write(buffer, buffer_u32, randomVal);
	}
	buffer_resize(buffer, buffer_tell(buffer));
	bs_save(bufferStore, buffer, "testing/buffer/number/cropped_"+string(number)+".blk");
	writeOps ++;
	buffer_delete(buffer);
}

show_debug_message("Written 500 smaller files in " +string((get_timer()-start)/1000) + "ms");

var start = get_timer();
for (var number = 0; number < 500; number++) {
	var buffer = bs_load(bufferStore, "testing/buffer/number/"+string(number)+".blk");
	readOps ++;
	repeat (256) {
		buffer_read(buffer, buffer_u32);
	}
	buffer_delete(buffer);
}

show_debug_message("Loaded 500 1kb files in " +string((get_timer()-start)/1000) + "ms");

start = get_timer();
for (var number = 0; number < 500; number++) {
	var buffer = bs_load(bufferStore, "testing/buffer/number/cropped_"+string(number)+".blk");
	readOps ++;
	repeat (50) {
		buffer_read(buffer, buffer_u32);
	}
	buffer_delete(buffer);
}

show_debug_message("Loaded 500 smaller files in " +string((get_timer()-start)/1000) + "ms");

start = get_timer();
for (var number = 0; number < 2500; number++) {
	var buffer = bs_load(bufferStore, "testing/buffer/number/"+string(floor(random(500)))+".blk");
	readOps ++;
	repeat (256) {
		buffer_read(buffer, buffer_u32);
	}
	buffer_delete(buffer);
}

show_debug_message("Loaded 2500 random files in " +string((get_timer()-start)/1000) + "ms");

//Content validation
show_debug_message("Content validation");

start = get_timer();
for (var number = 0; number < 50; number++) {
	str1[number] = string(random(20))+"random"+string(random(500));
	str2[number] = string(random(20))+"random"+string(random(500));
	str3[number] = string(random(20))+"rAAAndom"+string(random(500));
	num1[number] = round(random(200));
	num2[number] = -40000 + round(random(20000));
	num3[number] = round(random(20000));
	file[number] = "testing/buffer/random/"+string(get_timer())+string(random(50))+".blk";
	var buffer = buffer_create(1024, buffer_fixed, 1);
	
	buffer_write(buffer, buffer_string, str1[number]);
	buffer_write(buffer, buffer_string, str2[number]);
	buffer_write(buffer, buffer_u8, num1[number]);
	buffer_write(buffer, buffer_s32, num2[number]);
	buffer_write(buffer, buffer_u32, num3[number]);
	buffer_write(buffer, buffer_string, str3[number]);
	buffer_resize(buffer, buffer_tell(buffer));
	bs_save(bufferStore, buffer, file[number]);
	writeOps ++;
	buffer_delete(buffer);
}

for (var number = 0; number < 50; number++) {
	var buffer = bs_load(bufferStore, file[number]);

	var val = buffer_read(buffer, buffer_string);
	var valid = str1[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}

	val = buffer_read(buffer, buffer_string);
	valid = str2[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	
	val = buffer_read(buffer, buffer_u8);
	valid = num1[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}

	val = buffer_read(buffer, buffer_s32);
	valid = num2[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	
	val = buffer_read(buffer, buffer_u32);
	valid = num3[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	
	val = buffer_read(buffer, buffer_string);
	valid = str3[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	readOps++;
	buffer_delete(buffer);
}

show_debug_message("Validated 50 random buffers in " +string((get_timer()-start)/1000) + "ms");

show_debug_message("Total write ops: " +string(writeOps));
show_debug_message("Total read ops: " +string(readOps));
//show_debug_message("Total write ops: " +string(writeOps));
//show_debug_message("Total read ops: " +string(readOps));

show_debug_message("Persist destroy loading new");
start = get_timer();
bs_persist(bufferStore);
bs_destroy(bufferStore);
bufferStore = bs_create("newstore", bsize, bsize*4, validation);
show_debug_message("Done in " +string((get_timer()-start)/1000) + "ms");

for (var number = 0; number < 50; number++) {
	var buffer = bs_load(bufferStore, file[number]);

	var val = buffer_read(buffer, buffer_string);
	var valid = str1[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}

	val = buffer_read(buffer, buffer_string);
	valid = str2[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	
	val = buffer_read(buffer, buffer_u8);
	valid = num1[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}

	val = buffer_read(buffer, buffer_s32);
	valid = num2[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	
	val = buffer_read(buffer, buffer_u32);
	valid = num3[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	
	val = buffer_read(buffer, buffer_string);
	valid = str3[number];
	if (val != valid) {
		show_error("Invalid data from buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
	readOps++;
	buffer_delete(buffer);
}
show_debug_message("Validated 50 newly loaded buffers in " +string((get_timer()-start)/1000) + "ms");
bs_destroy(bufferStore);

bufferStore = bs_create("overwriting", bsize, bsize*4, validation);
for (var number = 0; number < 50; number++) {
	//var buffer = bs_load(bufferStore, file[number]);
	str1[number] = string(random(20))+"random"+string(random(500));
	file[number] = "testing/buffer/overwriting/"+string(str1[number])+".blk";
	var buffer = buffer_create(1024, buffer_fixed, 1);

	buffer_write(buffer, buffer_string, string(random(20))+"random"+string(random(500)));
	buffer_resize(buffer, buffer_tell(buffer));
	bs_save(bufferStore, buffer, file[number]);
	buffer_delete(buffer);
}

bs_persist(bufferStore);
bs_destroy(bufferStore);


bufferStore = bs_create("overwriting", bsize, bsize*4, validation);
for (var number = 0; number < 50; number++) {
	//var buffer = bs_load(bufferStore, file[number]);
	file[number] = "testing/buffer/overwriting/"+string(str1[number])+".blk";
	var buffer = buffer_create(1024, buffer_fixed, 1);

	buffer_write(buffer, buffer_string, str1[number]);
	buffer_resize(buffer, buffer_tell(buffer));
	bs_save(bufferStore, buffer, file[number]);
	buffer_delete(buffer);
}

bs_persist(bufferStore);
bs_destroy(bufferStore);


bufferStore = bs_create("overwriting", bsize, bsize*4, validation);
for (var number = 0; number < 50; number++) {
	var buffer = bs_load(bufferStore, file[number]);
	var val = buffer_read(buffer, buffer_string);
	var valid = str1[number];
	if (val != valid) {
		show_error("Invalid data from overwritten buffer ("+string(val)+" != "+string(valid)+")!", false);
	}
}

bs_persist(bufferStore);
bs_destroy(bufferStore);

bufferStore = bs_create("deletion", bsize, bsize*4, validation);

var buffer = buffer_create(1024, buffer_fixed, 1);
buffer_write(buffer, buffer_string, string(random(20))+"random"+string(random(500)));
buffer_resize(buffer, buffer_tell(buffer));
bs_save(bufferStore, buffer, "deletethis");
buffer_delete(buffer);

if (!bs_exists(bufferStore, "deletethis")) {
	show_error("Newly created one doesn't exist", false);
}

bs_persist(bufferStore);
bs_destroy(bufferStore);

bufferStore = bs_create("deletion", bsize, bsize*4, validation);

if (!bs_exists(bufferStore, "deletethis")) {
	show_error("Newly created / loaded one doesn't exist", false);
}

bs_delete(bufferStore, "deletethis");

if (bs_exists(bufferStore, "deletethis")) {
	show_error("Deleted still exists", false);
}

bs_persist(bufferStore);
bs_destroy(bufferStore);

bufferStore = bs_create("deletion", bsize, bsize*4, validation);

if (bs_exists(bufferStore, "deletethis")) {
	show_error("Created deleted persisted should be gone", false);
}

bs_persist(bufferStore);
bs_destroy(bufferStore);

show_debug_message("                    TOTAL: " +string((get_timer()-totalstart)/1000) + "ms");
show_debug_message("");
show_debug_message("");
show_debug_message("");
show_debug_message("");

/*
bufferstore
Written 500 smaller files in 6.03ms
Loaded 500 1kb files in 11.61ms
Loaded 500 smaller files in 6.70ms
Loaded 2500 random files in 59.76ms
Total write ops: 1000
Total read ops: 3500

loose
Written 500 1kb files in 80.89ms
Written 500 smaller files in 63.41ms
Loaded 500 1kb files in 27.66ms
Loaded 500 smaller files in 19.54ms
Loaded 2500 random files in 144.28ms
Total write ops: 1000
Total read ops: 3500

ini
Written 500 1kb files in 17.69ms
Written 500 smaller files in 10.05ms
Loaded 500 1kb files in 30.20ms
Loaded 500 smaller files in 6.90ms
Loaded 2500 random files in 142.67ms
Total write ops: 1000
Total read ops: 3500

binary
Written 500 1kb files in 6922.91ms
Written 500 smaller files in 16367.75ms
Loaded 500 1kb files in 24.02ms
Loaded 500 smaller files in 5.18ms
Loaded 2500 random files in 122.45ms
Total write ops: 1000
Total read ops: 3500

*/


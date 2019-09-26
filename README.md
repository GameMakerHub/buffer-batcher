# buffer-batcher
Store and manage multiple small buffers into a bigger one, much like a FAT.

A store contains "blocks" and a "mapping" for buffers. Blocks are big buffers containing multiple 
smaller buffers. These are persisted on disk, along with a mapping.

This greatly improves the speed of reading lots of tiny buffers, particulary useful for saving / 
loading chunked worlds. 

## Example usage
```gml 
// Setup a store with 8MB blocks, and try to keep memory usage under 32 megabytes.
var mb = 1024*1024; // 1 megabyte in bytes
bufferStore = bs_create("world_123", 8 * mb, 32 * mb, false);

// Create a buffer in GM
var myBuffer = buffer_create(10, buffer_grow, 1);
buffer_write(myBuffer, buffer_string, "Some value into a buffer!");
buffer_write(myBuffer, buffer_u32, 123456);

// Save it into the store
bs_save(bufferStore, myBuffer, "real_gm_buffer");

// Destroy the GM buffer
buffer_destroy(myBuffer);

bs_persist(); // Save the bufferstore on disk!

var newBuffer = bs_load(bufferStore, "real_gm_buffer");
show_debug_message(buffer_read(newBuffer, buffer_string)); // "Some value into a buffer!"
show_debug_message(buffer_read(newBuffer, buffer_u32)); // 123456
```

## Functions
```gml 
bs_create(filename, blocksize, memory_limit_bytes, validation); //Returns BufferStore instance
// Creates a bufferstore at <filename>. If validation is true, real on-disk buffers are used (only for 
testing purposes!)

bs_save(bufferStore, buffer, name); // Store a buffer with a certain name into the bufferstore.

bs_load(bufferStore, name); // Return a stored buffer from the store

bs_set_debug(bufferstore, enable_debug); // Enable or disable debugging

bs_persist(bufferStore); // This asynchronously perists the bufferstore on disk

bs_destroy(bufferStore); // This destroys a bufferstore, freeing memory.

bs_exists(bufferStore, name); // Check if a buffer exists in a store

bs_delete(bufferStore, name); // Delete a buffer from the store

```

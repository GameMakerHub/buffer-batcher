///@param bufferStore
///@param block
///@param emptySpace
var bufferStore = argument0;
var blockId = argument1;
var _blockEmptySpace = argument2;

with (bufferStore) {
	var eli = _empty_list[| blockId];
	var done = false;
	var elis = ds_list_size(eli);
	for (var _i = 0; _i < elis; _i++) {
		var _em = eli[|_i];

		if (_em[@ 0]+_em[@ 1] == _blockEmptySpace[@ 0]) {
			_em[@ 1] += _blockEmptySpace[@ 1];
			_blockEmptySpace[@ 0] = _em[@ 0];
			_blockEmptySpace[@ 1] = _em[@ 1];
			if (_bs_combine_empty(bufferStore, blockId, _blockEmptySpace)) {
				ds_list_delete(eli, _i);
			}
			return true;
			break;
		}
		
		if (_em[@ 0] == _blockEmptySpace[@ 0]+_blockEmptySpace[@ 1]) {
			_em[@ 0] = _blockEmptySpace[@ 0];
			_em[@ 1] += _blockEmptySpace[@ 1];
			_blockEmptySpace[@ 0] = _em[@ 0];
			_blockEmptySpace[@ 1] = _em[@ 1];
			if (_bs_combine_empty(bufferStore, blockId, _blockEmptySpace)) {
				ds_list_delete(eli, _i);
			}
			return true;
			break;
		}		
	}

	return false;
}
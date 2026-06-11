function binary_search(array, check, target){
	var low = 0;
	var high = array_length(array) - 1;
	
	var middle = low + (high - low) / 2;
	
	repeat (high) {
		var result = check(middle, target);
		
		switch (result){
		case -1:
			high = middle - 1;
			continue;
		case 1:
			low = middle + 1;
			continue;
		default:
			return middle;
		}
	}
	
	return -1;	//nothing was found :(
}


/* Example check function
var exampleArray = [1, 2, 3, 4, 5, 6, 7, 8, 9];

function example_binary_search_check(x, target){
	if (x < target) return 1; //target is bigger
	if (x > target) return -1; //target is smaller
	
	return 0;	//target is just right
}
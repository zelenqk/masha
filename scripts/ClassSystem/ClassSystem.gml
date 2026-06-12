<<<<<<< HEAD
function ClassSystem() constructor{
=======
function ClassSystem(p) constructor{
	parent = p;
>>>>>>> 9b41c21 (optimizations + refactoring)
	list = [];
	number = 0;
	
	static add = function(){
		
	}
	
	static remove = function(){
		
	}
	
<<<<<<< HEAD
	static toggle = function(){
		
	}
=======
	static toggle = function(class, state = true){
		var cache = parse_class(class);
		var index = array_get_index(list, cache);
		
		if (state and index == -1) {
			array_push(list, cache);
			array_sort(list, class_sort);

			parent.render();
			return;
		}
		
		if (!state and index != -1){
			array_delete(list, index, 1);
			array_sort(list, class_sort);

			parent.render();
		}
	}
}

function class_sort(a, b){
	return a.weight - b.weight;
>>>>>>> 9b41c21 (optimizations + refactoring)
}
function ClassSystem(p) constructor{
	parent = p;
	list = [];
	
	static add = function(class){
		if (array_get_index(list, class) != -1)  return;
		
		array_push(list, parent.parse_calculations(class));
		parent.render()
	}
	
	static remove = function(class){
		var index = array_get_index(list, class);
		if (index == -1) return;
		
		array_delete(list, class, 1);		
		parent.render()
	}
	
	static toggle = function(class, state = (array_get_index(list, class) == -1)){
		var cache = parent.parse_calculations(class);
		var index = array_get_index(list, cache);
		
		if (index == -1 and state){
			array_push(list, cache);
			parent.render();
		}
		
		if (index != -1 and !state){
			array_delete(list, index, 1);
			parent.render();
		}
	}
}
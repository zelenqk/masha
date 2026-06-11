function get_default(class, name, fallback = undefined){
	var value = class[$ name];
	
	if (value == undefined) return fallback;
	return value;
}

function get_overwrite(class){
	var i = 1;
	var fallback = argument[argument_count - 1];
	
	repeat (argument_count - i){
		var name = argument[i++];
		var value = class[$ name];
		
		if (value != undefined) return value;
	}
	
	return fallback;
}

function get_overwrite_struct(class, struct){
	var i = 2;
	var fallback = argument[argument_count - 1];
	
	if (class[$ struct] == undefined) return fallback;
	
	repeat (argument_count - i - 1){
		var name = argument[i++];
		var value = class[$ struct][$ name];
		
		if (value != undefined) return value;
	}
	
	return fallback;
}

function resolve_variable(name, fallback){
	var value = main[$ name];
	fallback = (value == undefined) ? fallback : value;
	
	for(var i = array_length(self.class.list) - 1; i >= 0 ; i--){
		var class = self.class.list[i];
		var value = class[$ name];
		
		if (value != undefined) return value;
	}
	
	return fallback;
}

function resolve_variable_struct(struct, name, fallback){
	var value = main[$ struct];
	if (value == undefined) return fallback;
	
	value = main[$ struct][$ name];
	fallback = (value == undefined) ? fallback : value;
	
	for(var i = array_length(self.class.list) - 1; i >= 0 ; i--){
		var class = self.class.list[i];
		value = class[$ struct][$ name];
		if (fallback != undefined) return value;
	}
	
	return fallback;
}
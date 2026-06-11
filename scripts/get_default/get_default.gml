function get_default(properties, name, fallback = undefined){
	var value = properties[$ name];
	if (value == undefined) return fallback;
	return value;
}

function get_overwrite(){
	var properties = argument[0];
	var fallback = argument[argument_count - 1];
	
	for(var i = 1; i < argument_count - 1; i++){
		var value = properties[$ argument[i]];
		
		if (value != undefined) return value;
	}
	
	return fallback;
}

function get_overwrite_struct(){
	var properties = argument[0];
	var struct = argument[1];
	
	var fallback = argument[argument_count - 1];
	
	if (!is_struct(properties[$ struct])) return fallback;
	
	for(var i = 2; i < argument_count - 1; i++){
		var value = properties[$ struct][$ argument[i]];
		
		if (value != undefined) return value;
	}
	
	return fallback;
}

function resolve_variable(name, fallback, main = {}, classes = []){
	fallback = (main[$ name] == undefined) ? fallback : main[$ name];
	
	for(var i = array_length(classes) - 1; i >= 0; i--){
		var class = classes[i];
		
		var v = class[$ name];
		if (v != undefined) return v;
	}
	
	return fallback;
}

function resolve_struct(struct, name, fallback, main = {}, classes = []){
	fallback = (main[$ struct] == undefined or main[$ struct][$ name] == undefined) ? fallback : main[$ struct][$ name];
	
	for(var i = array_length(classes) - 1; i >= 0; i--){
		var class = classes[i];
		
		var v = class[$ struct][$ name];
		if (v != undefined) return v;
	}
	
	return fallback;	
}
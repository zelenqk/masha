globalvar CONTAINER_CACHE;
CONTAINER_CACHE = {};

//direction
#macro column 0
#macro row 1

function ContainerUtil(p) constructor{
	//hierarchy
	parent = p;
	root = (parent == self) ? self : parent.root;
	
	//systems
	class = new ClassSystem(self);
	layout = new Layout(self);

	//caches
	hover = noone;
	hovering = false;
	holding = false;
	
	mouse = -1;
	
	target = pointer_null;
	efficient = {x:0, y: 0, width: 0, height: 0};
	
	pipeline = new Pipeline();
	
	main = pointer_null;
	
	//render cache
	vertex = new Vertex();
	
	children = {
		list: [],
		number: 0,
		vertex: {},
	}
	
	//util methods
	hover_check = function(){
		if (root.hover == self and hovering == false){
			class.toggle(main.hover, true);
			hovering = true;
			mouse = 0;
		}
		
		var inside = point_in_rectangle(
			device_mouse_x_to_gui(0),
			device_mouse_y_to_gui(0),
			
			efficient.x, efficient.y,
			efficient.x + efficient.width,
			efficient.y + efficient.height,
		);
		
		if (!inside and root.hover == self){
			root.hover = noone;
			class.toggle(main.hover, false);
			hovering = false;
			
			if (holding == false) mouse = -1;
		}
		
		if (inside and (root.hover == noone or root.hover != self)) root.hover = self;	
	}
	
	hold_check = function(){
		if (root.hover == self and holding == false) {
			if (device_mouse_check_button_pressed(mouse, mb_left)){
				holding = true;
				class.toggle(main.hold, true);
			}
			
			return;
		}
		
		if (holding and device_mouse_check_button_released(mouse, mb_left)){
			holding = false;
			class.toggle(main.hold, false);
			
			if (root.hover != self) mouse = -1;
		}
	}
	
	//render pipeline
	static parse_calculations = function(class, fallback = undefined){
		var hash =  variable_get_hash(class);
		var cache = CONTAINER_CACHE[$ hash];
		
		if (cache != undefined) return cache;
		
		//background parsing
		var background = get_default(class, "background", fallback);
		var image = get_default(class, "image", 0);
		
		var color = get_default(class, "tint", undefined);
		var alpha = get_default(class, "alpha", (background == -1 ? undefined : 1));

		var texture = get_default(class, "texture", undefined);
		var uvs = get_default(class, "uv", undefined);
		
		if (asset_get_type(background) == asset_sprite){
			texture = sprite_get_texture(background, image);	
			uvs = sprite_get_uvs(background, image);
		}else {
			if (is_handle(background)) show_debug_message("[MASHA_RS][ERROR] cannot proccess handle " + string(background));
		}
		
		cache = {	
			//dimensions
			width: get_calculation(get_default(class, "width", fallback)),
			height: get_calculation(get_default(class, "height", fallback)),
			
			padding : {
				left: get_calculation(get_overwrite_struct(class, "padding", "left", "inline", get_overwrite(class, "paddingLeft", "paddingInline", "padding", fallback))),
				right: get_calculation(get_overwrite_struct(class, "padding", "right", "inline", get_overwrite(class, "paddingRight", "paddingInline", "padding", fallback))),
				top: get_calculation(get_overwrite_struct(class, "padding", "top", "block", get_overwrite(class, "paddingTop", "paddingBlock", "padding", fallback))),
				bottom: get_calculation(get_overwrite_struct(class, "padding", "bottom", "block", get_overwrite(class, "paddingBottom", "paddingBlock", "padding", fallback))),
			},
			
			border : {
				left: get_calculation(get_overwrite_struct(class, "border", "left", "inline", get_overwrite(class, "borderLeft", "borderInline", "border", fallback))),
				right: get_calculation(get_overwrite_struct(class, "border", "right", "inline", get_overwrite(class, "borderRight", "borderInline", "border", fallback))),
				top: get_calculation(get_overwrite_struct(class, "border", "top", "block", get_overwrite(class, "borderTop", "borderBlock", "border", fallback))),
				bottom: get_calculation(get_overwrite_struct(class, "border", "bottom", "block", get_overwrite(class, "borderBottom", "borderBlock", "border", fallback))),
			},
			
			margin : {
				left: get_calculation(get_overwrite_struct(class, "margin", "left", "inline", get_overwrite(class, "marginLeft", "marginInline", "margin", fallback))),
				right: get_calculation(get_overwrite_struct(class, "margin", "right", "inline", get_overwrite(class, "marginRight", "marginInline", "margin", fallback))),
				top: get_calculation(get_overwrite_struct(class, "margin", "top", "block", get_overwrite(class, "marginTop", "marginBlock", "margin", fallback))),
				bottom: get_calculation(get_overwrite_struct(class, "margin", "bottom", "block", get_overwrite(class, "marginBottom", "marginBlock", "margin", fallback))),
			},
			
			//layout
			direction: get_default(class, "direction", fallback),
			
			//visuals
			background: {
				texture: texture,
				tint: color,
				alpha: alpha,
				uvs: uvs,
			},
		}
		
		CONTAINER_CACHE[$ hash] = cache;
		
		return cache;
	}
	
	static prepare = function(){
		main.hover = get_default(properties, "hover", -1);
		main.hold = get_default(properties, "hold", -1);
		
		efficient.width = calculate_value(resolve_variable("width", 0, main, class.list), parent.efficient.width);
		efficient.height = calculate_value(resolve_variable("height", 0, main, class.list), parent.efficient.height);
		
		
		parent.layout.position(self);
		if (root != self) parent.layout.increment(efficient.width, efficient.height)
		
		efficient.background = {
			texture: resolve_struct("background", "texture", -1, main, class.list),	
			tint: resolve_struct("background", "tint", c_white, main, class.list),	
			alpha: resolve_struct("background", "alpha", 1, main, class.list),	
			uvs: resolve_struct("background", "uvs", [0, 0, 1, 1], main, class.list),	
		}
		
		layout.reset();
		array_foreach(children.list, function(child){
			child.render();
		})
	}
	
	static build = function(){
		vertex.purge();
		vertex.quad(efficient.x, efficient.y, efficient.width, efficient.height, efficient.background.tint, efficient.background.alpha, efficient.background.uvs);
		vertex.texture = efficient.background.texture;
	}
	
	static populate = function(){
		pipeline = new Pipeline();
		if (main.hover != -1 or main.hold != -1) pipeline.push(hover_check);
		if (main.hold != -1) pipeline.push(hold_check);
		
		pipeline.push(vertex.submit);
	}
	
	static render = function(){
		prepare();
		build();
		
		populate();
	}
	
	static draw = function(){
		pipeline.step();
	}
}


function Pipeline() constructor{
	stack = [];
	length = 0;
	
	static push = function(e){
		array_push(stack, e)
		length++;
	}
	
	static step = function(){
		var i = 0;
		
		repeat(length){
			var work = stack[i++];
			work();
		}
	}
}

function Layout(p) constructor {
	parent = p;
	
	x = 0;
	y = 0;
	
	static reset = function() {
		x = 0;
		y = 0;
	}
	
	static position = function(container) {
			
	}
	
	static increment = function(width, height) {
		
	}
}

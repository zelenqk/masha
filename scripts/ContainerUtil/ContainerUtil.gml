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
	efficient = {x:0, y: 0, width: 0, height: 0, background: {texture: -1, tint: c_white, alpha: 1, uvs: [0, 0, 1, 1]}};
	
	pipeline = new Pipeline();
	main = pointer_null;
	
	//render cache
	vertex = new Vertex();
	
	children = {
		list: [],
		number: 0,
		batch: [],
		
		submit: function(){
			var i = 0;
			repeat (array_length(batch)){
				var group = batch[i++];
				group.vertex.submit(group.texture);
			}
		}
	}
	
	group = pointer_null;
	offset = parent.children.number;
	
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
	
	static add = function(styles) {
		if (!is_array(styles)) {
			var container = new Container(styles, self);
			
			array_push(children.list, container);
			children.number++;
			
			container.render();
			return container;
		}
		
		var res = [];
		
		for(var i = 0; i < array_length(styles); i++){
			var style = styles[i];
			var container = new Container(style, self);
			
			array_push(children.list, container);
			children.number++;
			
			array_push(res, container);
		}
		return res;
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
		var alpha = get_default(class, "alpha", undefined);

		var texture = get_default(class, "texture", undefined);
		var uvs = get_default(class, "uv", undefined);
		
		if (asset_get_type(background) == asset_sprite){
			texture = sprite_get_texture(background, image);	
			uvs = sprite_get_uvs(background, image);
			alpha = (alpha == undefined ? 1 : alpha);
		}else {
			if (is_handle(background)) show_debug_message("[MASHA_RS][ERROR] cannot proccess handle " + string(background));
			else if (background != undefined){
				texture = -1;
				color = background;
				alpha = (alpha == undefined ? 1 : alpha);
			}
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
				left: get_calculation(get_overwrite_struct(class, "border", "left", "inline", get_overwrite(class, "borderWidth", "border", fallback))),
			},
			
			margin : {
				left: get_calculation(get_overwrite_struct(class, "margin", "left", "inline", get_overwrite(class, "marginLeft", "marginInline", "margin", fallback))),
				right: get_calculation(get_overwrite_struct(class, "margin", "right", "inline", get_overwrite(class, "marginRight", "marginInline", "margin", fallback))),
				top: get_calculation(get_overwrite_struct(class, "margin", "top", "block", get_overwrite(class, "marginTop", "marginBlock", "margin", fallback))),
				bottom: get_calculation(get_overwrite_struct(class, "margin", "bottom", "block", get_overwrite(class, "marginBottom", "marginBlock", "margin", fallback))),
			},
			
			//layout
			visible: get_default(class, "visible", true),
			direction: get_default(class, "direction", fallback),
			depth: get_default(class, "depth", parent.children.number),
			
			//visuals
			background: {
				texture: texture,
				tint: color,
				alpha: alpha,
				uvs: uvs,
			},
			
			//class stuff
			weight: get_default(class, "weight", 0),
		}
		
		CONTAINER_CACHE[$ hash] = cache;
		
		return cache;
	}
	
	static prepare = function(){
		main.hover = get_default(properties, "hover", -1);
		main.hold = get_default(properties, "hold", -1);
		
		efficient.width = display_get_gui_width();
		efficient.height = display_get_gui_height();
				
		efficient.wrap = resolve_variable("wrap", false, main, class.list);
		efficient.direction = resolve_variable("direction", column, main, class.list);
		
		layout.reset();
		parent.layout.position(self);
		
		efficient.width = calculate_value(resolve_variable("width", 0, main, class.list), parent.efficient.width);
		efficient.height = calculate_value(resolve_variable("height", 0, main, class.list), parent.efficient.height);
		
		if (root != self) parent.layout.increment(efficient.width, efficient.height)
		
		efficient.background.texture = resolve_struct("background", "texture", -1, main, class.list);
		efficient.background.tint = resolve_struct("background", "tint", c_white, main, class.list);
		efficient.background.alpha = resolve_struct("background", "alpha", 0, main, class.list);
		efficient.background.uvs = resolve_struct("background", "uvs", [0, 0, 1, 1], main, class.list);
		
		array_foreach(children.list, function(child){
			child.render();
		})
	}
	
	static build = function(){
		vertex.purge();
		
		vertex.start();
		vertex.quad(efficient.x, efficient.y, efficient.width, efficient.height, efficient.background.tint, efficient.background.alpha, efficient.background.uvs);
		vertex.finish();
		
		vertex.texture = efficient.background.texture;
	}
	
	static populate = function(){
		pipeline = new Pipeline();
		
		if (main.hover != -1 or main.hold != -1) pipeline.push(hover_check);
		if (main.hold != -1) pipeline.push(hold_check);
		
		if (root == self){
			pipeline.push(vertex.submit);
			pipeline.push(children.submit);
		}else{
			var index = array_find_index(parent.children.batch, function(group){
				return (group.texture == efficient.background.texture);
			});
			
			var group = {texture: efficient.background.texture, vertex: new Vertex(), free: []};
			
			if (index == -1) array_push(parent.children.batch, group);
			else group = parent.children.batch[index];
			
			if (group != self.group){
				self.group = group;
				vertex_update_buffer_from_vertex(group.vertex.buffer, offset * 6, vertex.buffer);
			} 
		}
	}
	
	static render = function(){
		prepare();
		populate();
		build();
	}
	
	draw = function(){
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
		array_foreach(stack, function(work){
			work();
		});
	}
}

function Layout(p) constructor {
	parent = p;
	
	x = 0;
	y = 0;
	
	line = {
		x: 0,
		y: 0,
		width: 0,
		height: 0,
	}
	
	direction = column;
	
	static reset = function() {
		line.x = 0;
		line.y = 0;
		line.width = 0;
		line.height = 0;
		
		direction = parent.efficient.direction;
	}
	
	static position = function(container) {
		if (direction == row ) container.efficient.x = x + line.width;
		else container.efficient.y = y + line.height;
	}
	
	static increment = function(width, height) {
		var ewidth = parent.efficient.width// - parent.efficient.padding.left - parent.efficient.padding.right;
		var eheight = parent.efficient.height// - parent.efficient.padding.top - parent.efficient.padding.bottom;
		
		if (direction == row){
			if (parent.efficient.wrap and x + width > ewidth){
				y += line.height;
				
				line.width = 0;
				line.height = 0;
			}
			
			line.width += width;
			line.height = max(line.height, height);
		}else {
			if (parent.efficient.wrap and y + height > eheight){
				x += line.width;
				
				line.width = 0;
				line.height = 0;
			}
			
			line.height += height;
			line.width = max(line.width, width);
		}
	}
}

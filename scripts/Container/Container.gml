<<<<<<< HEAD
globalvar CLASS_CACHE;
CLASS_CACHE = {};

function Container(style, p = self) constructor{
	properties = style;
	
=======
#macro fa_allow 0
#macro fa_scroll 1

function Container(style, p = self) constructor {
	//main style
	main = parse_class(style);
	
	//hierarchy
>>>>>>> 9b41c21 (optimizations + refactoring)
	parent = p;
	root = (parent == self) ? self : parent.root;
	
	//systems
<<<<<<< HEAD
	class = new ClassSystem();
	pipeline = new Pipeline();
	layout = new Layout(self);
	
	//caches
	efficient = {x: 0, y: 0, width: 0, height: 0, background: {texture: -1, color: c_white, alpha: 1, uv: [0, 0, 1, 1]}};
	
	vertex = new Vertex();
	group = pointer_null;
	
=======
	vertex = new Vertex();
	
	pipeline = new Pipeline();
	layout = new Layout(self);
	class = new ClassSystem(self);

	//mouse events cache
	mouse = -1;
	hold = -1;
	holding = false;
	onClick = -1;
	
	hover = -1;
	hovered = false;
	hovering = noone;		//root container stores the last container being hovered
	
	//cache
	scissor = pointer_null;
	boundaries = {x: 0, y: 0, w: 0, h: 0};
	
	offset = 0;
	group = pointer_null;
	
	target = pointer_null;
	efficient = new BaseContainer();
	
	//children system
>>>>>>> 9b41c21 (optimizations + refactoring)
	children = {
		list: [],
		number: 0,
		batch: [],
<<<<<<< HEAD
	
		submit: function(){
			for(var i = 0; i < array_length(batch); i++){
				var group = batch[i];
				group.vertex.submit(group.texture);
=======
		
		submit: function(){
			var i = 0;
			var length = array_length(batch);
			
			repeat(length){
				var group = batch[i++];
				group.vertex.submit();
>>>>>>> 9b41c21 (optimizations + refactoring)
			}
		}
	}
	
<<<<<<< HEAD
	offset = parent.children.number;
	
	//calculations
	static parse_calculations = function(class){
		var hash = variable_get_hash(class);
		var cache = CLASS_CACHE[$ hash];
		
		if (cache != undefined) return cache;
		
		var texture = undefined;
		var background = get_default(class, "background");
		var tint = get_default(class, "tint");
		var alpha = get_default(class, "alpha");
		var image = get_default(class, "image", 0);
		var uv = get_default(class, "uv");
		
		if (asset_get_type(background) == asset_sprite){
			texture = sprite_get_texture(background, image);
			alpha = (alpha == undefined) ? 1 : alpha;
			uv = sprite_get_uvs(background, image);
		}else{
			if (is_handle(background)) show_debug_message("[MASHA][ERROR] Cant process handles other than sprites");
			else {
				if (background != undefined){
					texture = -1;
					tint = (tint == undefined) ? background : merge_colour(tint, color, 0.5);
					alpha = (alpha == undefined ? 1 : alpha);
				}
				
				if (tint != undefined) {
					alpha = (alpha == undefined ? 1 : alpha);
				}
			}
		}
		
		cache = {
			//dimensions
			width: get_calculation(get_default(class, "width")),
			height: get_calculation(get_default(class, "height")),
			
			depth: get_default(class, "depth"),
			
			margin: {
				left: get_overwrite_struct(class, "margin", "left", "inline", get_overwrite(class, "marginLeft", "marginInline", "margin", 0)),	
				right: get_overwrite_struct(class, "margin", "right", "inline", get_overwrite(class, "marginRight", "marginInline", "margin", 0)),	
				top: get_overwrite_struct(class, "margin", "top", "block", get_overwrite(class, "marginTop", "marginBlock", "margin", 0)),	
				bottom: get_overwrite_struct(class, "margin", "bottom", "block", get_overwrite(class, "marginBottom", "marginBlock", "margin", 0)),	
			},
			
			padding: {
				left: get_overwrite_struct(class, "padding", "left", "inline", get_overwrite(class, "paddingLeft", "paddingInline", "padding", 0)),	
				right: get_overwrite_struct(class, "padding", "right", "inline", get_overwrite(class, "paddingRight", "paddingInline", "padding", 0)),	
				top: get_overwrite_struct(class, "padding", "top", "block", get_overwrite(class, "paddingTop", "paddingBlock", "padding", 0)),	
				bottom: get_overwrite_struct(class, "padding", "bottom", "block", get_overwrite(class, "paddingBottom", "paddingBlock", "padding", 0)),	
			},
			
			//layout
			gap: get_default(class, "gap"),
			
			//background
			background: {texture, tint, alpha, uv},
		}
		
		hash = variable_get_hash(cache);
		CLASS_CACHE[$ hash] = cache;
		
		return cache;
	}
	
	static prepare = function(){
		efficient.width = display_get_gui_width();
		efficient.height = display_get_gui_height();
		
		efficient.width = calculate_value(resolve_variable("width", 0), parent.efficient.width);	
		efficient.height = calculate_value(resolve_variable("height", 0), parent.efficient.height);	
		
		parent.layout.position(self);
		if (root != self) parent.layout.increment(efficient.width, efficient.height);
		
		efficient.depth = resolve_variable("depth", 0);
	
		efficient.background.texture = resolve_variable_struct("background", "texture", -1);
		efficient.background.tint = resolve_variable_struct("background", "tint", c_white);
		efficient.background.alpha = resolve_variable_struct("background", "alpha", 1);
		efficient.background.uv = resolve_variable_struct("background", "uv", [0, 0, 1, 1]);
	
		//layout
		layout.gap = resolve_variable("gap", 0);
	}
	
	static build = function(){
		vertex.purge();
		vertex.texture = efficient.background.texture;
		
		vertex.start();
		vertex.quad(efficient);
		vertex.finish();
	}
	
	static render = function(){
		pipeline.reset();
		main = parse_calculations(properties);
		
		prepare();
		build();
		
		
		//populate pipeline
		if (root == self) pipeline.push(vertex.submit);
		else {
			var index = array_find_index(parent.children.batch, function(e){
				return e.texture == efficient.background.texture;
			});	
		
			var group = {texture: efficient.background.texture, vertex: new Vertex(), length: 0, free: []};
			
			if (index != -1) group = parent.children.batch[index];
			else{
				group.vertex.start();
				group.vertex.finish();
				group.vertex.texture = group.texture;
				
				array_push(parent.children.batch, group);
			}
			
			if (group != self.group){
				if (self.group != pointer_null){
					array_push(self.group.free, offset);
				}
				
				self.group = group;
				offset = (array_length(group.free) > 0) ? group.free[0] : group.length++;
				vertex_update_buffer_from_vertex(group.vertex.buffer, offset * 6, vertex.buffer);
			}
		}
		
		pipeline.push(children.submit);
=======
	//setup
	static calculate = function(){
		resolve_target();
		
		boundaries.x = efficient.x;
		boundaries.y = efficient.y;
		boundaries.w = efficient.width;
		boundaries.h = efficient.height;
		
		hover = (main.hover ?? -1);
		hold = (main.hold ?? -1);
		onClick = (main.onClick ?? -1);
	}
	
	static build = function(){
		vertex.texture = efficient.background.texture;
		
		vertex.purge() {
			vertex.start();
			vertex.quad(efficient);
			vertex.finish();
		}
	}
	
	static render = function(){
		calculate();
		build();
		
		//batch everything up madafaka
		if (self.group == pointer_null or self.group.texture != efficient.background.texture) {
			//find a group sharing the same texture or create one
			var index = array_find_index(parent.children.batch, function(group){
				return group.texture == efficient.background.texture;
			});
			
			if (index == -1){
				var group = {texture: efficient.background.texture, length: 0, vertex: new Vertex(), free: []};
				group.vertex.texture = group.texture;
				
				array_push(parent.children.batch, group);
			}else var group = parent.children.batch[index];

			if (self.group != pointer_null){
				array_push(self.group.free, offset);
				free_from_group();
			}
			
			offset = 0;
			if (array_length(group.free) > 0) {
				offset = group.free[0];
				array_delete(group.free, 0, 1);
			}else offset = group.length++;

			self.group = group;
		}
		
		apply_to_group();
		
		//checks
		if (hover != -1 or hold != -1 or onClick != -1) root.pipeline.push(hover_check, SECTOR.CHECK);
		if (hold != -1 or onClick != -1) root.pipeline.push(hold_check, SECTOR.CHECK);
		
		//draw
		if (efficient.overflow != fa_allow) root.pipeline.push(function(){
			scissor = gpu_get_scissor();
			
			//draw_rectangle(boundaries.x, boundaries.y, boundaries.x + boundaries.w, boundaries.y + boundaries.h, true);
			gpu_set_scissor(boundaries);
		}, SECTOR.CHECK);
		
		if (root == self) pipeline.push(children.submit, SECTOR.DRAW);
		
		if (efficient.overflow != fa_allow) pipeline.slip(function(){
			gpu_set_scissor(scissor);
		}, SECTOR.DRAW);
	}
	
	//util methods
	hover_check = function(){
		if (root.hovering == self and hovered == false) {
			if (hover != -1) class.toggle(hover, true);
			
			hovered = true;
			mouse = 0;
		}
		
		var pir = point_in_rectangle(
			device_mouse_x_to_gui(0),
			device_mouse_y_to_gui(0),
			boundaries.x, boundaries.y,
			boundaries.x + boundaries.w,
			boundaries.y + boundaries.h,
		);
		
		if (pir) root.hovering = self;
		else if (root.hovering == self) {
			root.hovering = noone;
			hovered = false;
			
			if (hover != -1) class.toggle(hover, false);
			if (holding == false) mouse = -1;
		}
	}
	
	hold_check = function(){
		if (root.hovering == self and device_mouse_check_button_pressed(mouse, mb_left)) {
			holding = true;
			if (hold != -1) class.toggle(hold, true);
		}
		
		if (device_mouse_check_button_released(mouse, mb_left) and holding) {
			holding = false;
			
			if (hold != -1) class.toggle(hold, false);
			if (root.hovering != self) mouse = -1;
		}
	}
	
	//group util methods
	static free_from_group = function(){
		vertex_update_buffer_from_vertex(group.vertex.buffer, offset + 2, vertex.buffer, 0, 1);
		vertex_update_buffer_from_vertex(group.vertex.buffer, offset + 5, vertex.buffer, 0, 1);
	}
	
	static apply_to_group = function(){
		vertex_update_buffer_from_vertex(group.vertex.buffer, offset, vertex.buffer);
>>>>>>> 9b41c21 (optimizations + refactoring)
	}
	
	//methods
	static add = function(style){
<<<<<<< HEAD
		var container = new Container(style, self);
		array_push(children.list, container);
		
		children.number++;
		
		return container;
	}
	
	render();
	draw = pipeline.step;
=======
		
	}
	
	static remove = function(){
		
	}
	
	static visible = function(state = !efficient.visible){
		if (state) apply_to_group();
		else free_from_group();
		
		efficient.visible = state;
	}
	
	static draw = function(){
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
		
		pipeline.step();
		
		gpu_set_ztestenable(false);
		gpu_set_zwriteenable(false);
	}
	
	//finish
	render();
>>>>>>> 9b41c21 (optimizations + refactoring)
}
globalvar CLASS_CACHE, EMPTY_UV;
CLASS_CACHE = {};
EMPTY_UV = [0, 0, 1, 1];

function parse_class(class){
	var hash = variable_get_hash(class);
	var cache = CLASS_CACHE[$ hash];
	
	if (cache != undefined) return cache;
	
	var texture = -1;
	var uv = EMPTY_UV;
	var image = get_default(class, "image", 0);
	
	var background = get_default(class, "background");
	var tint = get_default(class, "tint");
	var alpha = get_default(class, "alpha");
	
	if (asset_get_type(background) == asset_sprite) {
		tint = tint ?? c_white;
		alpha = (alpha == undefined ? 1 : alpha);
		texture = sprite_get_texture(background, image);
		uv = sprite_get_uvs(background, image);
	}else{
		if (is_handle(background)) show_debug_message("Unable to handle the handle " + string(background));
		else if (background != undefined) {
			alpha = (alpha == undefined ? 1 : alpha);
			tint = background;
		}
	}
	
	cache = {
		//dimensions
		width: get_calculation(get_default(class, "width")),
		height: get_calculation(get_default(class, "height")),
		
		//borders
		padding: {
			left: get_calculation(get_overwrite_struct(class, "padding", "left", "inline", get_overwrite(class, "paddingLeft", "paddingInline", "padding", undefined))),
			right: get_calculation(get_overwrite_struct(class, "padding", "right", "inline", get_overwrite(class, "paddingRight", "paddingInline", "padding", undefined))),
			top: get_calculation(get_overwrite_struct(class, "padding", "top", "block", get_overwrite(class, "paddingTop", "paddingBlock", "padding", undefined))),
			bottom: get_calculation(get_overwrite_struct(class, "padding", "bottom", "block", get_overwrite(class, "paddingBottom", "paddingBlock", "padding", undefined))),
		},
		
		margin: {
			left: get_calculation(get_overwrite_struct(class, "margin", "left", "inline", get_overwrite(class, "marginLeft", "marginInline", "margin", undefined))),
			right: get_calculation(get_overwrite_struct(class, "margin", "right", "inline", get_overwrite(class, "marginRight", "marginInline", "margin", undefined))),
			top: get_calculation(get_overwrite_struct(class, "margin", "top", "block", get_overwrite(class, "marginTop", "marginBlock", "margin", undefined))),
			bottom: get_calculation(get_overwrite_struct(class, "margin", "bottom", "block", get_overwrite(class, "marginBottom", "marginBlock", "margin", undefined))),
		},
		
		overflow: get_default(class, "overflow"),

		//events
		hover: get_default(class, "hover"),
		hold: get_default(class, "hold"),
		onClick: get_default(class, "onClick"),

		//background
		background: {texture, tint, alpha, uv},
		
		//layout
		depth: get_default(class, "depth"),
		visible: get_default(class, "visible"),
		direction: get_default(class, "direction"),
		
		gap: get_default(class, "gap"),
		wrap: get_default(class, "wrap"),
		
		//class sorting
		weight: get_default(class, "weight", 0),
	};
	
	CLASS_CACHE[$ hash] = cache;
	return cache;
}
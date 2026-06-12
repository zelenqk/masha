function resolve_target(){
	efficient.width = display_get_gui_width();
	efficient.height = display_get_gui_height();
	
	efficient.width = calculate_value(resolve_variable("width", 0), parent.efficient.width);	
	efficient.height = calculate_value(resolve_variable("height", 0), parent.efficient.height);

	efficient.overflow = resolve_variable("overflow", fa_allow);
	
	efficient.background = {
		alpha: resolve_variable_struct("background", "alpha", 0),
		uv: resolve_variable_struct("background", "uv", EMPTY_UV),
		tint: resolve_variable_struct("background", "tint", c_white),	
		texture: resolve_variable_struct("background", "texture", -1),	
	}
	
	efficient.depth = resolve_variable("depth", 0);
	efficient.visible = resolve_variable("visible", true);
	efficient.direction = resolve_variable("direction", column);
	
	efficient.gap = resolve_variable("gap", 0);
	efficient.wrap = resolve_variable("wrap", false);
}
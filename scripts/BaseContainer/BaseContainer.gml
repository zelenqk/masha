function BaseContainer() constructor {
	x = 0;
	y = 0;
	
	//dimensions
	width = display_get_gui_width();
	height = display_get_gui_height();
	
	//borders
	padding = {
		left: 0,
		right: 0,
		top: 0,
		bottom: 0,
	}
	
	margin = {
		left: 0,
		right: 0,
		top: 0,
		bottom: 0,
	}
	
	//background
	background = {
		texture: -1,
		tint: c_white,
		alpha: 1,
		uv: EMPTY_UV,
	}
	
	//layout
	depth = 0;
	visible = true;
	direction = column;

	gap = 0;
	wrap = false;
}
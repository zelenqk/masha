draw_set_font(LiberationSans);

globalvar fontInfo;
fontInfo = [];

var fonts = asset_get_ids(asset_font);
for(var i = 0; i < array_length(fonts); i++){
	var fnt = fonts[i];
	fontInfo[fnt] = font_get_info(fnt);	
}

function TextSystem(parent = {}) constructor{
	text = "Hello world";
	font = 0;
	texture = font_get_texture(font);
	
	color = c_white;
	alpha = 1;
	
	vertex = new Vertex();
	vertex.texture = texture;
	
	start = 0;
	length = -1;
	
	caret = [[]];
	line = 0;
	
	size = 24;
	scale = (size / fontInfo[font].size);
	
	frame = {
		x: 0,
		y: 0,
		width: 0,
		height: 0,
	}
	
	static render = function(){
		vertex.start();
		
		var len = (length == -1 ? string_length(text) : 0);
		string_foreach(text, append_character, start, len - start);
		vertex.finish();
	}
	
	submit = vertex.submit;
}

function append_character(character){
	var charInfo = fontInfo[font].glyphs[$ character];
	var tw = texture_get_texel_width(texture);
	var th = texture_get_texel_height(texture);
	
	var cx = charInfo.x;
	var cy = charInfo.y;
	
	var uv = [
	    (cx) * tw,
	    (cy) * th,
	    (cx + charInfo.w) * tw,
	    (cy + charInfo.h) * th
	];
	
	var tx = frame.x + charInfo.offset;
	var ty = frame.y + charInfo.yoffset
	
	vertex.quad(tx, ty, charInfo.w * scale, charInfo.h * scale, color, alpha, uv);
	caret[line] = [tx, ty];
	
	frame.x += charInfo.shift * scale;
}
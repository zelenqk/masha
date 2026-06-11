globalvar BASE_VERTEX_FORMAT, BASE_VERTEX_FORMAT_INFO;

vertex_format_begin()

vertex_format_add_position();
vertex_format_add_color();
vertex_format_add_texcoord();

BASE_VERTEX_FORMAT = vertex_format_end();
BASE_VERTEX_FORMAT_INFO = vertex_format_get_info(BASE_VERTEX_FORMAT);

function Vertex() constructor{
	buffer = vertex_create_buffer();
	texture = -1;
	vertex_begin(buffer, BASE_VERTEX_FORMAT);
	vertex_end(buffer);
	
	//methods
	static purge = function(){
		vertex_delete_buffer(buffer);
		buffer = vertex_create_buffer();
		vertex_begin(buffer, BASE_VERTEX_FORMAT);
		vertex_end(buffer);
	}
	
	submit = function(tex = texture){
		vertex_submit(buffer, pr_trianglelist, tex);
	}
		
	static start = function(){
		vertex_begin(buffer, BASE_VERTEX_FORMAT);	
	}
	
	static finish = function(){
		vertex_end(buffer);	
	}
		
	//prefabs
	static quad = function(tx, ty, width, height, color = c_white, alpha = 1, uvs = [0, 0, 1, 1]){
		vertex_position(buffer, tx, ty); // top left
		vertex_color(buffer, color, alpha);
		vertex_texcoord(buffer, uvs[0], uvs[1]);
		
		vertex_position(buffer, tx + width, ty); // top right
		vertex_color(buffer, color, alpha);
		vertex_texcoord(buffer, uvs[2], uvs[1]);
		
		vertex_position(buffer, tx + width, ty + height); // bottom right
		vertex_color(buffer, color, alpha);
		vertex_texcoord(buffer, uvs[2], uvs[3]);
		
		vertex_position(buffer, tx, ty); // top left
		vertex_color(buffer, color, alpha);
		vertex_texcoord(buffer, uvs[0], uvs[1]);
		
		vertex_position(buffer, tx + width, ty + height); // bottom right
		vertex_color(buffer, color, alpha);
		vertex_texcoord(buffer, uvs[2], uvs[3]);
		
		vertex_position(buffer, tx, ty + height); // bottom left
		vertex_color(buffer, color, alpha);
		vertex_texcoord(buffer, uvs[0], uvs[3]);
	}
}
globalvar BASE_FORMAT;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_texcoord();
BASE_FORMAT = vertex_format_end();

function Vertex() constructor{
	texture = -1;
	primitive = pr_trianglelist;
	buffer = vertex_create_buffer();
	
	submit = function(){
		vertex_submit(buffer, primitive, texture)	
	}
	
	static purge = function(){
		vertex_delete_buffer(buffer);
		buffer = vertex_create_buffer();
	}
	
	static start = function(){
		vertex_begin(buffer, BASE_FORMAT);
	}
	
	static finish = function(){
		vertex_end(buffer);
	}
	
	//primitives
	static quad = function(box){
		vertex_position_3d(buffer, box.x, box.y, box.depth);
		vertex_color(buffer, box.background.tint, box.background.alpha);
		vertex_texcoord(buffer, box.background.uv[0], box.background.uv[1]);
		
		vertex_position_3d(buffer, box.x + box.width, box.y, box.depth);
		vertex_color(buffer, box.background.tint, box.background.alpha);
		vertex_texcoord(buffer, box.background.uv[2], box.background.uv[1]);

		vertex_position_3d(buffer, box.x + box.width, box.y + box.height, box.depth);
		vertex_color(buffer, box.background.tint, box.background.alpha);
		vertex_texcoord(buffer, box.background.uv[2], box.background.uv[3]);
		
		vertex_position_3d(buffer, box.x, box.y, box.depth);
		vertex_color(buffer, box.background.tint, box.background.alpha);
		vertex_texcoord(buffer, box.background.uv[0], box.background.uv[1]);
		
		vertex_position_3d(buffer, box.x + box.width, box.y + box.height, box.depth);
		vertex_color(buffer, box.background.tint, box.background.alpha);
		vertex_texcoord(buffer, box.background.uv[2], box.background.uv[3]);
		
		vertex_position_3d(buffer, box.x, box.y + box.height, box.depth);
		vertex_color(buffer, box.background.tint, box.background.alpha);
		vertex_texcoord(buffer, box.background.uv[0], box.background.uv[3]);
	}
}
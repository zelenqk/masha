#macro column 0
#macro row 1

<<<<<<< HEAD
function Layout() constructor{
=======
function Layout(p) constructor{
	parent = p;
	
	align = fa_left;
	justify = fa_top;
	
>>>>>>> 9b41c21 (optimizations + refactoring)
	gap = 0;
	wrap = false;
	direction = column;

	//position
	x = 0; y = 0;
	
<<<<<<< HEAD
	//line cache
	line = {
		x: 0, y: 0,
		
		width: 0,
		height: 0,
	}
	
	static reset = function(){
		line.x = 0;
		line.y = 0;
		line.width = 0;
		line.height = 0;
		
=======
	lines = [];
	
	//line cache
	line = new LayoutLine();
	
	static correct_layout = function(){
>>>>>>> 9b41c21 (optimizations + refactoring)
		switch (direction){
		case column:
			increment = (wrap) ? increment_column_wrap : increment_column;
			position = position_column;
			break;
		case row:
		
			break;
<<<<<<< HEAD
		}
	}
	
	//util
	static position_column = function(container){
		container.efficient.x = line.x;
		container.efficient.y = line.y + line.height;
=======
		}	
	}
	
	static reset = function(){
		x = parent.efficient.x + parent.efficient.padding.left;
		y = parent.efficient.y + parent.efficient.padding.top;
		
		line.x = 0;
		line.y = 0;
		line.width = 0;
		line.height = 0;
		
		correct_layout();
	}
	
	//column util
	static position_column = function(container){
		if (container.efficient.position == absolute){
			var l = new LayoutLine();
			container.line = l;
			
			var ax = 0;	//align
			var jy = 0;	//justify
			
			container.efficient.x = x + ax;
			container.efficient.y = y + jy;
			
			array_push(lines, l);
			return;
		}
		
		container.line = line;
		container.efficient.x = x + line.x;
		container.efficient.y = y + line.y + line.height;
		
		array_push(line.elements, container);
>>>>>>> 9b41c21 (optimizations + refactoring)
	}
	
	static increment_column = function(width, height){
		line.width = max(line.width, width);
		line.height += height + gap;
	}
	
	static increment_column_wrap = function(width, height){
		if (line.y + height > frame.height){
<<<<<<< HEAD
			line.x += line.width;
			
			line.width = 0;
			line.height = 0;
=======
			array_push(lines, line);
			line = new LayoutLine();
>>>>>>> 9b41c21 (optimizations + refactoring)
		}
		
		line.width = max(line.width, width);
		line.height += height;
	}
	
<<<<<<< HEAD
	//done
	reset();
=======
	correct_layout();
}

function LayoutLine() constructor{
	x = 0;
	y = 0;
	width = 0;
	height = 0;
	
	elements = [];
>>>>>>> 9b41c21 (optimizations + refactoring)
}
#macro column 0
#macro row 1

function Layout() constructor{
	gap = 0;
	wrap = false;
	direction = column;

	//position
	x = 0; y = 0;
	
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
		
		switch (direction){
		case column:
			increment = (wrap) ? increment_column_wrap : increment_column;
			position = position_column;
			break;
		case row:
		
			break;
		}
	}
	
	//util
	static position_column = function(container){
		container.efficient.x = line.x;
		container.efficient.y = line.y + line.height;
	}
	
	static increment_column = function(width, height){
		line.width = max(line.width, width);
		line.height += height + gap;
	}
	
	static increment_column_wrap = function(width, height){
		if (line.y + height > frame.height){
			line.x += line.width;
			
			line.width = 0;
			line.height = 0;
		}
		
		line.width = max(line.width, width);
		line.height += height;
	}
	
	//done
	reset();
}
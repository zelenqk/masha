<<<<<<< HEAD
function Pipeline() constructor{
	stack = [];
	
	static push = function(work){
		array_push(stack, work)
	}
	
	step = function(){
		array_foreach(stack, function(work){
			work();	
=======
enum SECTOR { CHECK, DRAW, POP };

function Pipeline() constructor{
	stack = [];
	
	static slip = function(work, sector = 0){
		if (array_length(stack) - 1 < sector) stack[sector] = [];
		if (array_get_index(stack[sector], work) == -1) array_insert(stack[sector], 0, work);
	}
	
	static push = function(work, sector = 0){
		if (array_length(stack) - 1 < sector) stack[sector] = [];
		if (array_get_index(stack[sector], work) == -1) array_push(stack[sector], work);
	}
	
	step = function(){
		array_foreach(stack, function(sector){
			for(var i = 0; i < array_length(sector); i++){
				var work = sector[i];
				work();
			}
>>>>>>> 9b41c21 (optimizations + refactoring)
		});
	}
	
	reset = function(){
		stack = [];	
	}
}
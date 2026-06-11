function Pipeline() constructor{
	stack = [];
	
	static push = function(work){
		array_push(stack, work)
	}
	
	step = function(){
		array_foreach(stack, function(work){
			work();	
		});
	}
	
	reset = function(){
		stack = [];	
	}
}
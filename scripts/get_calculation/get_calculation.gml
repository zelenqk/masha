enum UNIT { PIXEL, PERCENT };

//show_message(ord("0")); 48
//show_message(ord("9")); 57
//show_message(ord("1"));

function get_calculation(value){
	if (value == undefined) return undefined;
	if (is_real(value)) return [value, UNIT.PIXEL];
	
	var number = "";
	var unit = "";
	
	for(var i = string_length(value); i > 0; i--){
		var character = string_char_at(value, i);
		var ordinal = ord(character);
		
		if !(ordinal >= 48 and ordinal <= 57) unit = character + unit;
		else {
			number = real(string_copy(value, 1, i));
			break;
		}
	}

	switch (unit){
	case "%":
		unit = UNIT.PERCENT;
		break;
	default:
		unit = UNIT.PIXEL;
		break;
	}

	return [number, unit];
}

function calculate_value(calculation, target){
	var value = calculation[0];
<<<<<<< HEAD
=======
	
>>>>>>> 9b41c21 (optimizations + refactoring)
	switch (calculation[1]){
	case UNIT.PERCENT:
		return target * (value / 100);
	default:
		return value;
	}
}
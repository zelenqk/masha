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

	
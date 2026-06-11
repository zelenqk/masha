function calculate_value(calculation, target){
	if (!is_array(calculation)) show_message(json_stringify(class.list, true));
	
	var value = calculation[0];
	
	switch (calculation[1]){
	case UNIT.PERCENT:
		return target * (value / 100);
	default:
		return value;
	}
	
}
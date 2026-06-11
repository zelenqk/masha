function calculate_value(calculation, target){
	var value = calculation[0];
	
	switch (calculation[1]){
	case UNIT.PERCENT:
		return target * (value / 100);
	default:
		return value;
	}
	
}
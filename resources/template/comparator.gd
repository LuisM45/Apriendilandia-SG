extends Resource
class_name Comparator

enum Operator {LESS_THAN,LESS_EQUAL_THAN,EQUAL_THAN,GREATER_THAN,GREATER_EQUAL_THAN,DIFFERENT_THAN}

@export var operator: Operator
@export var reference_value: float
	
func compare(compare_value):
	match operator:
		Operator.LESS_THAN: return reference_value < compare_value
		Operator.LESS_EQUAL_THAN: return reference_value <= compare_value
		Operator.EQUAL_THAN: return reference_value == compare_value
		Operator.GREATER_THAN: return reference_value > compare_value
		Operator.GREATER_EQUAL_THAN: return reference_value > compare_value
		Operator.DIFFERENT_THAN: return reference_value != compare_value
	return false
	


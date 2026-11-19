extends Button
class_name UpgradeIndicator

var indicator : String
var tool_tip : String

func _process(_delta: float) -> void:
	if indicator:
		text = indicator
	if tool_tip:
		tooltip_text = tool_tip
		

extends Control

@export var p1_kb_options : OptionButton
@export var p2_kb_options : OptionButton
@export var p1_joy_options : OptionButton
@export var p2_joy_options : OptionButton

@export var cont_btn : Button
@export var warning_label:Label

func _ready() -> void:
	print(Input.get_connected_joypads())


	if not Input.get_connected_joypads().is_empty():
		warning_label.hide()
		for joy in Input.get_connected_joypads():
			p1_joy_options.add_item(str(joy))
			p2_joy_options.add_item(str(joy))
	else :
		warning_label.show()
	cont_btn.pressed.connect(assign_mult_controls)
	cont_btn.pressed.connect(UIpressSfx.play)
	cont_btn.focus_entered.connect(UIfocusSfx.play)
	p1_joy_options.focus_entered.connect(UIfocusSfx.play)
	p2_joy_options.focus_entered.connect(UIfocusSfx.play)
	p1_joy_options.pressed.connect(UIpressSfx.play)
	p2_joy_options.pressed.connect(UIpressSfx.play)



func assign_mult_controls():
	var actionList = InputMap.get_actions()
	
	for act in range(actionList.size()):
		if(actionList[act].begins_with("ui_")):
			continue
		if actionList[act].begins_with("P1") and p1_joy_options.selected != -1:
			var actionEventList = InputMap.action_get_events(actionList[act])
			for event in range(actionEventList.size()):
				if actionEventList[event] is InputEventJoypadButton or actionEventList[event] is InputEventJoypadMotion:
					actionEventList[event].set_device(int(p1_joy_options.get_item_text(p1_joy_options.selected)))
					print(actionList[act],":",actionEventList[event]," : ",actionEventList[event].device)
		if actionList[act].begins_with("P2") and p2_joy_options.selected != -1:
			var actionEventList: = InputMap.action_get_events(actionList[act])
			for event in range(actionEventList.size()):
					if actionEventList[event] is InputEventJoypadButton or actionEventList[event] is InputEventJoypadMotion:
						actionEventList[event].set_device(int(p2_joy_options.get_item_text(p2_joy_options.selected)))
						print(actionList[act],":",actionEventList[event]," : ",actionEventList[event].device)

	get_tree().change_scene_to_file("res://Scenes/multiplayer_court.tscn")

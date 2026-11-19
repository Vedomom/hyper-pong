extends Button


@export var title : Label

@export var description : Label

var ugd_scene : PackedScene
var player_1 : Player_1
var player_2 : Player_2
signal finished_job()

func _ready() -> void:
	pressed.connect(add_upgrade)
	if get_parent().get_parent().get_parent().get_parent().get_parent():
		for node in get_parent().get_parent().get_parent().get_parent().get_parent().get_children():
			if node is Player_1:
				player_1 = node
			elif node is Player_2:
				player_2 = node


func add_upgrade():
	if ugd_scene:
		var scene = ugd_scene.instantiate()
		var container 
		var indicator_container
		if name.contains("P1"):
			container = player_1.get_child(2)
			indicator_container = player_1.upgrades_container
		else :

			container = player_2.get_child(2)
			indicator_container = player_2.upgrades_container

		var indicator = load("res://Scenes/Upgrade_indicator.tscn").instantiate()
		indicator_container.add_child(indicator)
		indicator.indicator = title.text[0]
		indicator.tool_tip = title.text + "\n \n" + description.text
		indicator.size_flags_horizontal = SIZE_SHRINK_BEGIN
		container.add_child(scene)
		print(container.get_child(-1))
		finished_job.emit()

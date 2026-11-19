extends Button


@export var title : Label

@export var description : Label

var ugd_scene : PackedScene
var player : Player



func _ready() -> void:
	pressed.connect(add_upgrade)
	if get_parent().get_parent().get_parent().get_parent():
		for node in get_parent().get_parent().get_parent().get_parent().get_children():
			if node is Player:
				player = node


func add_upgrade():
	if ugd_scene:
		var scene = ugd_scene.instantiate()
		var container = player.get_child(2)
		container.add_child(scene)
		var indicator = load("res://Scenes/Upgrade_indicator.tscn").instantiate()
		player.upgrades_container.add_child(indicator)
		indicator.indicator = title.text[0]
		indicator.tool_tip = title.text + "\n \n" + description.text
		indicator.size_flags_horizontal = SIZE_SHRINK_BEGIN
		player.round_up.emit()
		TextAnimation.slide_out(get_parent(), Vector2(get_parent().position.x, -2000))

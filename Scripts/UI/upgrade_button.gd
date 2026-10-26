extends Button


@export var title : Label

@export var description : Label

var ugd_scene : PackedScene
var player : Player


func _ready() -> void:
	pressed.connect(add_upgrade)
	if get_parent().get_parent().get_parent():
		for node in get_parent().get_parent().get_parent().get_children():
			if node is Player:
				player = node


func add_upgrade():
	if ugd_scene:
		var scene = ugd_scene.instantiate()
		var container = player.get_child(2)
		container.add_child(scene)
		player.round_up.emit()
		get_parent().queue_free()

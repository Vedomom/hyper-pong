extends OptionButton

@export var opposite_btn: OptionButton

func _process(delta: float) -> void:
    if opposite_btn.selected == selected :
        selected = -1
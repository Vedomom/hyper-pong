# MIT License - free to use, modify, redistribute.
# hit_stop.gd - autoload as "HitStop"
extends Node

## Speed the game drops to during a freeze. 0.0 = full freeze.
@export var freeze_scale: float = 0.05

var _until_msec: int = 0      # real-time end of the current freeze
var _active := false

## Freeze (or heavily slow) the game for `duration` real seconds.
## Overlapping calls extend the freeze to whichever ends later, never stack.
func hit_stop(duration: float = 0.06, scale: float = -1.0) -> void:
    if duration <= 0.0:
        return
    var end := Time.get_ticks_msec() + int(duration * 1000.0)
    _until_msec = maxi(_until_msec, end)
    Engine.time_scale = freeze_scale if scale < 0.0 else scale
    if _active:
        return
    _active = true
    _run()

func _run() -> void:
    while Time.get_ticks_msec() < _until_msec:
        # process_always = true, process_in_physics = false, ignore_time_scale = true
        await get_tree().create_timer(0.005, true, false, true).timeout
    Engine.time_scale = 1.0
    _active = false

func _exit_tree() -> void:
    Engine.time_scale = 1.0
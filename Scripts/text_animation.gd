extends Node

var subject_array : Array
var initial_font_size_array : Array

var rot_array : Array

<<<<<<< HEAD
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
=======
var slide_weight : float
var slide_array : Array



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	Input.set_custom_mouse_cursor(load("res://Resources/images/tile_0026.png"))
	





# Load the custom images for the mouse cursor.



	

#animation

>>>>>>> 1b7ed48 (added sound effects , and a pause menu)
func pop_animation(subject : Label, amount : int , initial_fs : int):
	initial_font_size_array.append(initial_fs)
	subject.label_settings.font_size += amount
	subject.label_settings.font_size = clamp(subject.label_settings.font_size, initial_fs-amount, initial_fs+amount)
	if subject in subject_array:
		subject_array.erase(subject)
	subject_array.append(subject)
	
func rot_animation(subject : Label, amount : float):
	subject.rotation += amount
	subject.rotation = clampf(subject.rotation, subject.rotation + amount, 0.0)
	if subject in rot_array:
		rot_array.erase(subject)
	rot_array.append(subject)

func goal_particle_animation(gp: GPUParticles2D, direction : int):
	gp.process_material.direction.x = direction
	gp.restart()
	

func _process(_delta: float) -> void:
	var exec = execute_pop_animation()
	execute_rot_animation(10*_delta)
	if exec != OK:
		for index in  range(subject_array.size()):
			subject_array[index].label_settings.font_size = initial_font_size_array[index]
			subject_array.remove_at(index)
			initial_font_size_array.remove_at(index)
 

func execute_pop_animation():
	
	if subject_array.size() > 0:
		for index in  range(subject_array.size()):
			if subject_array[index].label_settings.font_size > initial_font_size_array[index]:
				subject_array[index].label_settings.font_size -= 1
			if subject_array[index].label_settings.font_size < initial_font_size_array[index]:
				subject_array[index].label_settings.font_size += 1
			if subject_array[index].label_settings.font_size <= initial_font_size_array[index] + 2 and subject_array[index].label_settings.font_size >= initial_font_size_array[index] - 2:
				subject_array[index].label_settings.font_size = initial_font_size_array[index]
				subject_array.remove_at(index)
				initial_font_size_array.remove_at(index)
	return OK

func round_end_release():
	for index in  range(subject_array.size()):
		subject_array[index].label_settings.font_size = initial_font_size_array[index]
	subject_array.clear()
	initial_font_size_array.clear()


func execute_rot_animation(_delta):
	if !rot_array.is_empty():
		for subject in rot_array:
			subject.rotation = lerp(subject.rotation, 0.0, _delta)
			if subject.rotation == 0.0 :
				rot_array.erase(subject)

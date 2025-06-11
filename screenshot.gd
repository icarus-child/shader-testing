extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		take_screenshot()


func take_screenshot() -> void:
	var scene: String = get_tree().current_scene.name
	var time: String = Time.get_datetime_string_from_system()
	var image_name: String = "res://screenshots/%s.%s.png" % [scene, time]
	get_viewport().get_texture().get_image().save_png(image_name)
	print("Taking Screenshot: %s" % image_name)

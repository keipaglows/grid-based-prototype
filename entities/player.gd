extends "base_pawn.gd"
export(bool) var rotation_enabled = true

onready var Grid = get_parent()
onready var ZOOM_STEP = float(0.02)


func _ready():
	update_look_direction(Vector2(1, 0))


func _process(delta):
	var input_direction = get_input_direction()

	if input_direction:
		var target_position = Grid.request_move(self, input_direction)

		if target_position:
			move_to(target_position)
			update_look_direction(input_direction)
		else:
			bump()
	# TODO: handle this outside _process, and Player?
	if Input.is_action_pressed("ui_page_up"):
		update_camera_zoom(-ZOOM_STEP)
	if Input.is_action_pressed("ui_page_down"):
		update_camera_zoom(+ZOOM_STEP)
	if Input.is_action_pressed("ui_home"):
		restore_camera()


func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)


func update_look_direction(direction):
	update_camera_position(direction)

	if rotation_enabled:
		$Pivot/Sprite.rotation = direction.angle()


func update_camera_position(direction):
	$Pivot/CameraWrapper.rotation = direction.angle()


func update_camera_zoom(delta: float):
	var current_zoom = $Pivot/CameraWrapper/Offset/Camera.zoom
	var zoom_value = current_zoom.x + delta  # TODO: also handle y?
	
	if zoom_value > GameGlobals.MIN_CAMERA_ZOOM and zoom_value < GameGlobals.MAX_CAMERA_ZOOM:
		$Pivot/CameraWrapper/Offset/Camera.zoom = Vector2(zoom_value, zoom_value)


func restore_camera():
	$Pivot/CameraWrapper/Offset/Camera.zoom = Vector2(1, 1)


func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("walk")

	# Animate the pivot with the sprite moving to the intended cell
	var move_direction = (target_position - position).normalized()
	var move_length = GameGlobals.TILE_WIDTH

	# setting move_length 1.5 longer if we move diagnolly
	if abs(move_direction[0]) == abs(move_direction[1]):
		move_length = GameGlobals.TILE_WIDTH * 1.5

	$Tween.interpolate_property(
		$Pivot,
		"position",
		Vector2(),
		move_direction * move_length,
		$AnimationPlayer.current_animation_length,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

	$Tween.start()
	# Stop the function execution until the tween interpolatio nis finished
	yield($Tween, "tween_completed")

	# Set both actual position of node to cell where "pivot now is"
	# and at the same time setting pivot position bact to the origin,
	# where it's parent node now is (where pivot was before)
	position = target_position
	$Pivot.position = Vector2()

	set_process(true)


func bump():
	set_process(false)
	$AnimationPlayer.play("bump")
	yield($AnimationPlayer, "animation_finished")
	set_process(true)

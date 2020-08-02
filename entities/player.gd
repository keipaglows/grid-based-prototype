extends "base_pawn.gd"
export(bool) var rotation_enabled = true

onready var Grid = get_parent()

const DEFAULT_CAMERA_SMOOTHING = 2
const DIAGONAL_CAMERA_SMOOTHING = 4


func _ready():
	update_look_direction(Vector2(1, 0))


func _process(delta):
	var input_direction = get_input_direction()

	if input_direction:
		update_look_direction(input_direction)

		var target_position = Grid.request_move(self, input_direction)

		if target_position:
			move_to(target_position)
		else:
			bump()


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


func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("walk")

	# Animate the pivot with the sprite moving to the intended cell
	var move_direction = (target_position - position).normalized()
	var move_length = GameGlobals.TILE_SIZE

	# diagonal movement fixes
	if abs(move_direction[0]) == abs(move_direction[1]):
		move_length = GameGlobals.TILE_SIZE * 1.5
		$Pivot/CameraWrapper/Offset/Camera.smoothing_speed = DIAGONAL_CAMERA_SMOOTHING

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

	if $Pivot/CameraWrapper/Offset/Camera.smoothing_speed != DEFAULT_CAMERA_SMOOTHING:
		$Pivot/CameraWrapper/Offset/Camera.smoothing_speed = DEFAULT_CAMERA_SMOOTHING

	set_process(true)


func bump():
	set_process(false)
	$AnimationPlayer.play("bump")
	yield($AnimationPlayer, "animation_finished")
	set_process(true)

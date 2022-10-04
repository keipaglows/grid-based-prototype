extends Node2D


class_name ZLabel

var label: Label


func _init(text: String, margint_left: int, margin_top: int):
	self.label = Label.new()
	self.label.text = text
	self.label.margin_left = margint_left
	self.label.margin_top = margin_top
	# TODO: add these as possible args
	self.label.modulate =  Color( 0.12, 0.56, 1, 1 ).lightened(5)
	self.z_index = GameGlobals.GUI_LAYER
	
	self.add_child(self.label)


func add_to_scene(scene: Node):
	scene.add_child(self)

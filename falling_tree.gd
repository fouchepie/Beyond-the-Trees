extends Area2D

signal _on_body_entered_name(tree_name)

func _on_body_entered(body):
	$FallingTreeBody/AnimatedTree.play()
	$FallingTreeAudio.play()
	_on_body_entered_name.emit(self.name.c_escape())

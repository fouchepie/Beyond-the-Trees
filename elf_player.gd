extends CharacterBody2D

@export var speed:float = 500.0
var in_transition:bool = false
var in_pause:bool = false

func handleInput():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction.normalized() * speed


func updateAnimation():
	if velocity.length() == 0 or in_transition or in_pause:
		$ElfAnimations.play("idle")
		$Footsteps.stop()
	else:
		if velocity.x > 0: 
			$ElfAnimations.flip_h = false
			$ElfAnimations.play("side walk")
		elif velocity.x < 0: 
			$ElfAnimations.flip_h = true
			$ElfAnimations.play("side walk")
		elif velocity.y > 0: 
			$ElfAnimations.play("front walk")
		elif velocity.y < 0: 
			$ElfAnimations.play("back walk")
		if not $Footsteps.playing:
			$Footsteps.play()


func _physics_process(_delta):
	if not (in_transition or in_pause):
		handleInput()
		move_and_slide()
	updateAnimation()


func _on_help_area_body_entered(_body):
	in_pause = true
	print("Start pause")
	$HelpBubble.visible = true

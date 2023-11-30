extends Node2D

@onready var elf_scene = load("res://elf_scene.tscn").instantiate()
@onready var giant_scene = load("res://giant_scene.tscn").instantiate()
var end_scene = preload("res://end_scene.tscn")

@onready var is_elf_scene: bool = true
var tween_music : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	add_child(elf_scene)
	
	# fade in the music in 5 seconds
	tween_music = create_tween()
	$MusicBiome1.volume_db = -15
	tween_music.tween_property($MusicBiome1, "volume_db", 0, 5)
	$MusicBiome1.play()
	
	# Directly transition to elf view with simulated space key
	#Input.action_press("ui_select")
	#Input.action_release("ui_select")
	
	elf_scene.get_node("FallingTree1")._on_body_entered_name.connect(_on_falling_tree)
	elf_scene.get_node("FallingTree2")._on_body_entered_name.connect(_on_falling_tree)
	elf_scene.get_node("FallingTree3")._on_body_entered_name.connect(_on_falling_tree)
	giant_scene.take_tree.connect(_on_take_tree)
	
	elf_scene.get_node("Goggles").body_entered.connect(_on_goggles_entered)
	
func _physics_process(delta):
	change_scene(delta)


func compute_giant_position(elf_position:Vector2) -> Vector2:
	var x_giant_position = elf_position[0] / 17.4 + (1920-1139)/2
	var y_giant_position = elf_position[1] / 17.4 + (1080-772)/2 
	return Vector2(x_giant_position, y_giant_position)


func _on_falling_tree(tree_name):
	print("FALLING TREE " + tree_name)
	giant_scene.get_node('MiniFallingTree').visible = true
	giant_scene.get_node('MiniFallingTree/CollisionTree').disabled = false
	giant_scene.get_node('MiniFallingTree').position = compute_giant_position(elf_scene.get_node(tree_name).get_position())
	giant_scene.current_falling_tree = tree_name


func _on_take_tree(current_falling_tree):
	elf_scene.get_node(current_falling_tree).queue_free()


func _on_goggles_entered(body):
	elf_scene.get_node('ElfPlayer').in_pause = true
	await get_tree().create_timer(1).timeout
	SceneTransition.change_scene(end_scene)


func change_scene(delta):
	if Input.is_action_just_pressed('ui_select') and not elf_scene.get_node('ElfPlayer').in_transition:
		elf_scene.get_node('ElfPlayer').in_transition = true
		if is_elf_scene:
			elf_scene.get_node('ElfPlayer').get_node('HelpBubble').visible = false
			elf_scene.get_node('ElfPlayer').in_pause = false
			
			# Set Elf position for the giant view
			giant_scene.get_node('MiniElf').position = compute_giant_position(elf_scene.get_node('ElfPlayer').get_position())
			$ElfHeHo.play()
			await elf_scene.get_node('CanvasLayer').get_node('ElfCamera').zoom_out(delta)
			#await get_tree().create_timer(5).timeout
			
			# Change view
			remove_child(elf_scene)
			add_child(giant_scene)
			#$ElfHeHo.play()
			await giant_scene.get_node('GiantCamera').zoom_out(delta)
			
			is_elf_scene = false
			elf_scene.get_node('ElfPlayer').in_transition = false
			
		else:
			await giant_scene.get_node('GiantCamera').zoom_in(delta)
			#await get_tree().create_timer(5).timeout
			
			# Change view
			remove_child(giant_scene)
			add_child(elf_scene)
			
			await elf_scene.get_node('CanvasLayer').get_node('ElfCamera').zoom_in(delta)

			is_elf_scene = true
			elf_scene.get_node('ElfPlayer').in_transition = false

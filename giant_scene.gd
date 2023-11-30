extends Node2D

var onElfPosition:bool = false
var onTreePosition:bool = false
var current_falling_tree:String

signal take_tree(current_falling_tree)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if $GiantHand/AnimatedHand.frame == 0:
		$GiantHand.position = get_viewport().get_mouse_position()

	if Input.is_action_just_pressed('ui_left_mouse_button') and onElfPosition and not onTreePosition:
		$MiniElf/ElfHeHo.play()
		
	click_on_tree()


func click_on_tree():
	if Input.is_action_just_pressed('ui_left_mouse_button') and onTreePosition:
		$GiantHand/HandSprite.visible = false
		$GiantHand/AnimatedHand.play('take_tree')
		await get_tree().create_timer(0.67).timeout
		$MiniFallingTree.visible = false
		$MiniFallingTree/CollisionTree.disabled = true
		
		await $GiantHand/AnimatedHand.animation_finished
		$GiantHand/HandSprite.visible = true
		$GiantHand/AnimatedHand.frame = 0
		onTreePosition = false
		
		take_tree.emit(current_falling_tree)


func _on_mini_elf_area_entered(_area):
	onElfPosition = true


func _on_mini_elf_area_exited(_area):
	onElfPosition = false


func _on_mini_falling_tree_area_entered(_area):
	onTreePosition = true
	$MiniFallingTree/MiniTreeHL.visible = true
	

func _on_mini_falling_tree_area_exited(_area):
	onTreePosition = false
	$MiniFallingTree/MiniTreeHL.visible = false

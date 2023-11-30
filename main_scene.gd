extends Node2D

@onready var title_scene = load("res://title_scene.tscn").instantiate()


func _ready():
	$IntroCutscene.play("intro_cutscene")
	await $IntroCutscene.animation_finished
	SceneTransition.add_scene(title_scene)
	


func _physics_process(_delta):
	if $IntroCutscene.frame == 28 or title_scene.get_node('AnimatedGiant').frame == 28:
		$SighGiant.play()

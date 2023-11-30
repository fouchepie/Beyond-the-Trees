extends Node2D

var biome1 = preload("res://biome_1.tscn")


func _on_play_the_wood_pressed():
	SceneTransition.change_scene(biome1)
	

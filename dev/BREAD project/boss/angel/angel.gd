extends CharacterBody2D

@export var health := 77


func damage(hp):
	health -= hp

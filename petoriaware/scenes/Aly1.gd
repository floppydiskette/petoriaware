extends Node2D

@onready var camera = $"../../Camera2D"
@onready var aly_sprite = $Aly
@onready var music = $Music
@onready var explosion_timer = $ExplosionTimer

@onready var boom_sound = $Boom
@onready var win_sound = $Win

var normal_aly = load("res://sprites/aly1/aly.png")
var loss_aly = load("res://sprites/aly1/golden_aly_shocked.jpg")
var win_aly = load("res://sprites/aly1/green_aly.jpg")

var loss_center = Vector2(0.0, 0.0)

var mouse_inside = false
var drag = false

var inside_bad_area = true

var won = false

func _input(event):
	if drag:
		if event is InputEventMouseMotion:
			aly_sprite.position += event.relative

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_inside:
			drag = true
	else:
		drag = false

func _on_visibility_changed():
	if self.visible:
		music.play()
		explosion_timer.start()
		aly_sprite.position = Vector2(0.0, 0.0)
		aly_sprite.texture = normal_aly


func _on_explosion_timer_timeout():
	if !inside_bad_area:
		# win
		win_sound.play()
		aly_sprite.texture = win_aly
		won = true
	else:
		# loss
		boom_sound.play()
		aly_sprite.texture = loss_aly
		won = false


func _on_area_2d_mouse_entered():
	mouse_inside = true


func _on_area_2d_mouse_exited():
	mouse_inside = false


func _on_bad_entered(area):
	inside_bad_area = true


func _on_bad_exited(area):
	inside_bad_area = false


func _on_music_finished():
	var interm = $"../.."
	interm.microgame_finished(interm.Microgame.ALY1, won)

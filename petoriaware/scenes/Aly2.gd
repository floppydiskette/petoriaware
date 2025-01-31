extends Node2D

@onready var camera = $"../../Camera2D"
@onready var music = $Music
@onready var explosion_timer = $ExplosionTimer

@onready var dragon_kick = $"Dragon Kick"
@onready var twin_snakes = $"Twin Snakes"
@onready var demolish = $Demolish
@onready var abilities: Array[Area2D] = [dragon_kick, twin_snakes, demolish]

var mouse_over_dk = false
var mouse_over_twin = false
var mouse_over_demo = false

var locked = true
@onready var slots: Array[Sprite2D] = [
	$"First Slot",
	$"Second Slot",
	$"Third Slot"
]
var original_transforms = [null, null, null]
var slot_holders = [null, null, null]

@onready var parse_result = $"Parse Result"

@onready var boom_sound = $Boom
@onready var win_sound = $Win

var gold_parse = load("res://sprites/aly2/gold_parse.png")
var grey_parse = load("res://sprites/aly2/grey_parse.png")

var won = false

var BH3 = Solar.new(5, 0)
var BH1 = Solar.new(3, 4)
var chosen_bh = null

@onready var buff_info = $"First Slot/Buff Info"
@onready var twin_image = $"First Slot/Buff Info/Twin Image"
@onready var twin_timer = $"First Slot/Buff Info/Twin Timer"
@onready var demo_image = $"First Slot/Buff Info/Demo Image"
@onready var demo_timer = $"First Slot/Buff Info/Demo Timer"

func _on_dragon_kick_mouse_entered() -> void:
	mouse_over_dk = true

func _on_dragon_kick_mouse_exited() -> void:
	mouse_over_dk = false

func _on_twin_snakes_mouse_entered() -> void:
	mouse_over_twin = true

func _on_twin_snakes_mouse_exited() -> void:
	mouse_over_twin = false

func _on_demolish_mouse_entered() -> void:
	mouse_over_demo = true

func _on_demolish_mouse_exited() -> void:
	mouse_over_demo = false

func update_buff_info():
	var open_slot = slot_holders.find(null)
	if open_slot == -1:
		buff_info.visible = false
	else:
		buff_info.reparent(slots[open_slot], false)
		buff_info.visible = true
	
	chosen_bh.update_twin_timer(abilities, slot_holders, open_slot, twin_image, twin_timer)
	chosen_bh.update_demo_timer(abilities, slot_holders, open_slot, demo_image, demo_timer)

func toggle_slot(ability):
	var ability_idx = abilities.find(ability)
	var slot_idx = slot_holders.find(ability)
	if slot_idx != -1:
		slot_holders[slot_idx] = null
		ability.transform = original_transforms[ability_idx]
	else:
		var open_idx = slot_holders.find(null)
		slot_holders[open_idx] = ability
		original_transforms[ability_idx] = ability.transform
		ability.transform = slots[open_idx].transform
	
	update_buff_info()

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !locked:
		if mouse_over_dk:
			toggle_slot(dragon_kick)
		if mouse_over_twin:
			toggle_slot(twin_snakes)
		if mouse_over_demo:
			toggle_slot(demolish)

func _on_visibility_changed():
	if self.visible:
		locked = false
		parse_result.visible = false
		music.play()
		explosion_timer.start()
		if randi_range(0, 1) == 0:
			chosen_bh = BH1
		else:
			chosen_bh = BH3
		update_buff_info()
	else:
		for slot in slot_holders:
			if slot != null:
				toggle_slot(slot)


func _on_explosion_timer_timeout():
	locked = true
	won = chosen_bh.verify(abilities, slot_holders)
	if won:
		# win
		win_sound.play()
		won = true
		parse_result.texture = gold_parse
		parse_result.visible = true
	else:
		# loss
		boom_sound.play()
		won = false
		parse_result.texture = grey_parse
		parse_result.visible = true

func _on_music_finished():
	var interm = $"../.."
	interm.microgame_finished(interm.Microgame.ALY2, won)

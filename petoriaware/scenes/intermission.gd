extends Node2D

@onready var win_music = $WinMusic
@onready var loss_music = $LossMusic
@onready var interm_music = $IntermissionMusic

@export var top_anim: AnimationPlayer
@export var bot_anim: AnimationPlayer

@onready var instruction_anim = $Instruction/AnimationPlayer

@onready var mg_trans_timer = $MinigameTransitionTimer
@onready var mg_start_timer = $MinigameStartTimer

@onready var mg_aly1 = $Minigame/Aly1
@onready var in_aly1 = $Instruction/Aly1

@onready var mg_aly2 = $Minigame/Aly2
@onready var in_aly2 = $Instruction/Aly2

@onready var life1 = $"Intermission Bottom/Lives/l1c/Life1"
@onready var life2 = $"Intermission Bottom/Lives/l2c/Life2"
@onready var life3 = $"Intermission Bottom/Lives/l3c/Life3"
@onready var life4 = $"Intermission Bottom/Lives/l4c/Life4"

enum Microgame {
	ALY1,
	ALY2
}

func load_microgame(mg: Microgame):
	match mg:
		Microgame.ALY1:
			mg_aly1.visible = true
		Microgame.ALY2:
			mg_aly2.visible = true

func load_instruction(mg: Microgame):
	match mg:
		Microgame.ALY1:
			in_aly1.visible = true
		Microgame.ALY2:
			in_aly2.visible = true
	instruction_anim.play("show_instruction")

func _on_minigame_start():
	load_microgame(Microgame.ALY2)

func _on_minigame_transition():
	top_anim.play("exit_up")
	bot_anim.play("exit_down")
	load_instruction(Microgame.ALY2)

func microgame_finished(mg: Microgame, win: bool):
	match mg:
		Microgame.ALY1:
			mg_aly1.visible = false
			in_aly1.visible = false
		Microgame.ALY2:
			mg_aly2.visible = false
			in_aly2.visible = false
	bot_anim.play("enter_down")
	if win:
		win_music.play()
		life1.win()
		life2.win()
		life3.win()
		life4.win()
	else:
		loss_music.play()
		life1.loss()
		life2.loss()
		life3.loss()
		life4.loss()

func post_mg_music_done():
	life1.normal_anim()
	life2.normal_anim()
	life3.normal_anim()
	life4.normal_anim()
	mg_trans_timer.start()
	mg_start_timer.start()
	interm_music.play()

func _on_win_music_finished():
	post_mg_music_done()

func _on_loss_music_finished():
	post_mg_music_done()

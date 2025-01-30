extends Sprite2D

@onready var anim = $AnimationPlayer

func normal_anim():
	anim.play("bounce_1")

func win():
	anim.play("win")

func loss():
	anim.play("loss")

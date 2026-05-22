extends Node3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
var play_idle = Callable(self, "anim_idle")
var play_run = Callable(self, "anim_run")
var play_shoot = Callable(self, "anim_shoot")
var play_gangnam = Callable(self, "anim_gangnam")

func anim_idle():
	anim_player.play("OK IDLE", 0.3)

func anim_run():
	anim_player.play("OK RUN", 0.3)

func anim_shoot():
	anim_player.play("OK SHOOTING")

func anim_gangnam():
	anim_player.play("OK GANGAMSTYLE", 0.5)

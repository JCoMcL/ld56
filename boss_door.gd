extends AnimatedSprite2D

var closed = true
func open():
	$AnimationPlayer.play("open",-1,0,closed)
	closed = !closed

func _ready() -> void:
	$ClickDetector.interact.connect(open)

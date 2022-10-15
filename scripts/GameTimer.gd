extends Timer
signal count_down(count)
export var count = 180

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout",self,"_on_timeout")
	emit_signal("count_down",count)

func _on_timeout():
	emit_signal("count_down",count)
	count -= 1
	if(count < 0):
		stop()

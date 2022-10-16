extends AudioStreamPlayer2D

onready var tween = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

func fade_out():
	# tween music volume down to 0
	tween.connect("tween_completed",self,"_on_tween_completed")
	tween.interpolate_property(self, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween.start()
	# when the tween ends, the music will be stopped

func _on_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
	tween.disconnect("tween_completed",self,"_on_tween_completed")

func fade_in():
	self.volume_db = -80
	self.play()
	tween.interpolate_property(self, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween.start()

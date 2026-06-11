extends AudioStreamPlayer

var menu_music = preload("res://Audio/Music/Valley Music 1.wav")
var ambience = preload("res://Audio/Music/Valley Ambience.wav")
var end_music = preload("res://Audio/Music/Valley Music 2.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, 5).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(5).timeout
	self.stop()
	
func play_music_menu():
	_play_music(menu_music)
	
func play_valley_ambience():
	_play_music(ambience, -20)
	
func play_end_music():
	_play_music(end_music, -10)

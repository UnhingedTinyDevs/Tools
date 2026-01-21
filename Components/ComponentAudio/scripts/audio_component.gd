extends IAudioComponent
class_name AudioComponent

@export var effects: Array[AudioCue] = []
@export var dialog: Array[AudioCue] = []
@export var music: Array[AudioCue] = []

func play(sound: String) -> void:
	pass

func stop() -> void:
	pass

func raise_volume( bus: Bus, v: float) -> void:
	pass

func lower_volume(bus: Bus, v: float) -> void:
	pass

func is_playing(bus: Bus, sound: String = "") -> bool:
	return false

extends Resource
class_name AudioCue
## A resource that holds all the info needed to play an audio stream
##
## Made to be used with the audio component

@export var id: StringName
@export var stream: AudioStream
@export var bus: int
@export var volume_db: float = 0.0
@export var pitch_min: float = 1.0
@export var pitch_max: float = 1.0

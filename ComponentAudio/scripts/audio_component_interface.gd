@abstract
extends Node
class_name IAudioComponent
## The interface that different audio components must implement.
##
## Must be implemented so that you can interact with certian other tools.

## An enum holding the bus names
enum Bus {
	MASTER = 0, 
	MUSIC = 1, 
	DIALOG = 2, 
	SFX = 3
	}


## Given a Bus return the name.
static func bus_name(bus: Bus) -> StringName:
	match bus:
		Bus.MASTER: return &"Master"
		Bus.MUSIC: return &"Music"
		Bus.SFX: return &"SFX"
		Bus.DIALOG: return &"Dialog"
		_: return &"Master"


#region Abstract methods
@abstract func play(sound: String) -> void;
@abstract func stop() -> void;
@abstract func lower_volume(bus: Bus, v: float) -> void;
@abstract func raise_volume( bus: Bus, v: float) -> void;
@abstract func is_playing(bus: Bus, sound: String = "") -> bool;
#endregion Abstract

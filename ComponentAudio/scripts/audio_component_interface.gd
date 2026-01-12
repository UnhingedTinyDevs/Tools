@abstract
extends Node
class_name IAudioComponent
## The interface that different audio components must implement.
##
## Must be implemented so that you can interact with certian other tools.

@abstract func play(sound: String) -> void;
@abstract func stop() -> void;
@abstract func lower_volume(v: float) -> void;
@abstract func raise_volume(v: float) -> void;
@abstract func is_playing(sound: String = "") -> bool;

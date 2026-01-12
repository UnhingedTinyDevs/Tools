@abstract
extends Node
class_name IAnimationComponent
## An interface the animation component must implement.
##
## The animation component can be given 3 Different Types of animatable things.
## Which ones you use and how you animate things is up to the implementer. 
## But the following functions must be implemented in order to interface with
## Certian other tools.

# The different types of animated types we can have in out component
@export var sprite: AnimatedSprite2D
@export var player: AnimationPlayer
@export var tree: AnimationTree

@abstract func play(animation: String) -> void;
@abstract func stop() -> void;
@abstract func is_playing() -> bool;
@abstract func has_animation(animation: String) -> bool;
@abstract func flip_sprite(expression: bool) -> void;
@abstract func is_sprite_flipped() -> bool;
@abstract func set_sprite_frames(frame: SpriteFrames) -> void;

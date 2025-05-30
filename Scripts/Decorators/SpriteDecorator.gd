extends RefCounted  # Lightweight class in Godot 4.x for reference counting

class_name SpriteDecorator

func decorate(character: Character):
	# Base class does nothing, subclasses will override this
	pass

func release(character: Character):
	pass

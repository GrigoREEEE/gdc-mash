class_name AnimatedSpriteDecorator extends SpriteDecorator

var animation_name: String

func _init(name: String = "default"):
	animation_name = name
	

func decorate(character: Character):
	var sprite_node: AnimatedSprite2D = AnimatedSprite2D.new()
	var collision_shape: CollisionShape2D = CollisionShape2D.new()
	if animation_name == "BlackSilhouette" || animation_name == "default":
		var sprite_frames = load("res://Assets/Characters/BlackSilhouette/SpriteFrame.tres") as SpriteFrames
		sprite_node.sprite_frames = sprite_frames
		sprite_node.autoplay = "idle"
		
		var shape = load("res://Assets/Characters/BlackSilhouette/CollisionShape.tres") as Shape2D
		collision_shape.shape = shape
	
		
	character.add_child(sprite_node)
	character.add_child(collision_shape)
	
	return sprite_node

class_name  Player extends CharacterBody2D 

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

signal DirectionChanged( new_direction: Vector2 ) 


func _ready():
	state_machine.InitPlayerStateMachine(self)
	pass 



func _process(_delta):
	#direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	#direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	direction = Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down"),
	).normalized()
	pass
	

func _physics_process(_delta):
	move_and_slide()




func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
	
		return false
	
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true




func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass



func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

extends KinematicBody2D


var groundVector: Vector2 = Vector2(0,1)
var jumps:int = 0


const GRAVITY:float = 9.81

export var maxJumps:int
export var gravFactor:int
export var jumpHeight:int
export var moveSpeed: int

onready var ray:RayCast2D = $Ray
onready var move:Vector2 = Vector2(0,0)
onready var cam:Camera2D = $Cam


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	
	movement()



func jump() -> void:
	
	if jumps < maxJumps:
		if Input.is_action_just_pressed("jump"):
			setAnimation("jump")
			move.y = 0
			move.y = -jumpHeight
			jumps += 1

func setAnimation(newAnimation:String) -> void:
	$Sprite.set_animation(newAnimation)

func setDirection(flip:bool) -> void:
	$Sprite.set_flip_h(flip)
	
	if flip:
		cam.set_h_offset(-1)
	else:
		cam.set_h_offset(1)
	

func movement() -> void:
	
	if !is_on_ceiling():
		jump()
		move.y += GRAVITY*gravFactor
	else:
		setAnimation("walk")
		jumps = 0
		jump()
	
	if Input.is_action_pressed("ui_left"):
		setDirection(true)
		move.x = -moveSpeed
	elif Input.is_action_pressed("ui_right"):
		setDirection(false)
		move.x = moveSpeed
	else:
		move.x = 0	
	# Actual Movement
	var ok = move_and_slide(move,groundVector)
	
	if ray.is_colliding():
		var collision =  ray.get_collider()
		playerDead(collision)

func playerDead(wall:Object) -> void:
	queue_free()


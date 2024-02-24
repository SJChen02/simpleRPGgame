extends KinematicBody2D

export var acc = 500
export var max_speed = 80
export var friction = 500
export var roll_speed = 120

enum {
	MOVE,
	ATTACK,
	ROLL,
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStat

func _ready():
	stats.connect("no_hp",self ,"queue_free")
	aniTree.active = true 
	Swordbox.knock_vector = roll_vector
	
onready var aniPlayer = $AnimationPlayer2
onready var aniTree = $AnimationTree2
onready var aniState = aniTree.get("parameters/playback")
onready var Swordbox = $HitboxPivot/SwordHitBox

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
		ROLL:
			roll_state(delta)
			
func move_state(delta):
	var input_vector = Vector2.ZERO
	var v = Vector2(position.direction_to(get_global_mouse_position()).normalized())
	
	roll_vector = input_vector
	input_vector.x = Input.get_action_strength("right-key") - Input.get_action_strength("left-key")
	input_vector.y = Input.get_action_strength("down-key") - Input.get_action_strength("up-key")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		Swordbox.knock_vector = v.round().normalized()

		aniTree.set("parameters/idle/blend_position", input_vector)
		aniTree.set("parameters/Run/blend_position", input_vector)
		aniTree.set("parameters/Attack/blend_position", position.direction_to(get_global_mouse_position()).normalized())
		aniTree.set("parameters/Roll/blend_position", input_vector)  
		aniState.travel("Run")
		velocity = velocity.move_toward(input_vector*max_speed,acc *delta)
	else:
		aniState.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO,friction *delta)
	
	move()
	if Input.is_action_pressed("sprint"):
		pass
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	if Input.is_action_just_pressed("attack"):
		aniTree.set("parameters/Attack/blend_position", position.direction_to(get_global_mouse_position()).normalized())
		state = ATTACK


func roll_state(delta):
	if roll_vector != Vector2.ZERO:
		velocity = roll_vector * roll_speed
		aniState.travel("Roll")
		move()
	else: 
		state = MOVE
	
		
func attack_state():
	velocity = Vector2.ZERO
	aniState.travel("Attack")

func attack_state_finnish():
	state = MOVE
	
func roll_animation_finnished():
	state = MOVE

func move():
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	stats.hp -= area.dps
	print(stats.hp)


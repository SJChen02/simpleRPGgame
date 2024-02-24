extends KinematicBody2D
class_name PLAYER


export(PackedScene) var BLADESWIPE: PackedScene = preload("res://Ability/Ability[BladeSwipe].tscn")
export(PackedScene) var WINDBLADE: PackedScene = preload("res://Ability/windBlade.tscn")


export var acc = 500 #sets how much speed to accerlerate
export var max_speed = 80 #sets the maximum speed the character can go
export var friction = 500 #sets the friction it is used to allow the character to have a slightly sliding effect
export var roll_speed = 120#sets the speed of a roll
export var Roll_cooldown = 1 # cooldown for rolling

enum { #used to make  a bunch of related constant.
	MOVE, #constant
	ATTACK,#constant
	ROLL,#constant
	ABILITY,#Constant
	BLOCK,#Constant
}

var state = MOVE #variable use to check the state of my character
var velocity = Vector2.ZERO #set velocity to 0
var roll_vector = Vector2.DOWN #Will set the direction of roll downward inorder to determine what direction to knock the enemy back.
var stats = PlayerStat #my characters' stat
var roll_available = true #condition for if roll is available or not


func _ready():#when node is ready this function will run
	stats.connect("no_hp",self ,"queue_free")#connects to node called "no_hp" and if it return true the character will be removed from the game.
	aniTree.active = true #activate animation tree
	Swordbox.knock_vector = roll_vector #direction of knockback
	
onready var aniPlayer = $AnimationPlayer #load my character animation 
onready var aniTree = $AnimationTree #load my animation tree used to play animation depend on the condition i set.
onready var aniState = aniTree.get("parameters/playback") #load animation
onready var Swordbox = $HitboxPivot/SwordHitBox #load hitbox of my character
onready var hurtbox = $Hurtbox #load hurtbox of my character
onready var timer = $RollTimer #allow you to get the timer node when the program starts

func _physics_process(delta):
	match state:#state machine
		MOVE:#one of the state
			move_state(delta)#function for the state of "MOVE"
		ATTACK:#one of the state
			attack_state()#function for the state of "ATTACK"
		ROLL:#one of the state
			roll_state()#function for the state of "ROLL"
		ABILITY:#one of the state
			ability_state()
		BLOCK:
			Block_state()

func move_state(delta):
	var input_vector = Vector2.ZERO #Initial input vector sets to (0,0)
	var v = Vector2(position.direction_to(get_global_mouse_position()).normalized()) #used to get my mouse position
	
	roll_vector = input_vector #an input used to dertermine which way my character roll
	input_vector.x = Input.get_action_strength("right-key") - Input.get_action_strength("left-key") #used to determine if my character move left or right.
	input_vector.y = Input.get_action_strength("down-key") - Input.get_action_strength("up-key")#used to determine if my character move up or down.
	input_vector = input_vector.normalized()#normalise the x and y value of the vector so it have the same speed for all direction.
	
	
	if input_vector != Vector2.ZERO:#if the component is not 0
		roll_vector = input_vector#roll vector will become the vector i inputed
		Swordbox.knock_vector = v.round().normalized()#the knockback direction will be from my character to my mouse position

		aniTree.set("parameters/idle/blend_position", input_vector) #will plays animation for idle depend on my input vector
		aniTree.set("parameters/Run/blend_position", input_vector) #will plays animation for run depend on my input vector
		aniTree.set("parameters/Attack/blend_position", position.direction_to(get_global_mouse_position()).normalized()) #will plays animation for attack depend on my position of my mouse
		aniTree.set("parameters/Roll/blend_position", input_vector)  #will plays animation for roll depend on my input vector
		aniTree.set("parameters/Casting/blend_position", position.direction_to(get_global_mouse_position()).normalized()) #will plays animation for ability depend on my position of my mouse
		aniState.travel("Run")#get the animation name "Run" from the animation tree 
		velocity = velocity.move_toward(input_vector*max_speed,acc *delta) #sets the velocity of my character moving.
	else:
		aniState.travel("idle")#gets the animation name "idle" from the animation tree
		velocity = velocity.move_toward(Vector2.ZERO,friction *delta)#will try to stop my character by slowing it down rather than stop it instantaneously
	move() #allow character to slide when collide with an object
	if Input.is_action_pressed("Rally"):#function when button for "Rally" is pressed.
		pass
		
	if Input.is_action_just_pressed("Roll"):#function when button for "roll" is pressed.
		state = ROLL#change state to ROLL
	if Input.is_action_just_pressed("attack"):#function when button for "attack" is pressed.
		aniTree.set("parameters/Attack/blend_position", position.direction_to(get_global_mouse_position()).normalized())#checks my mouse position and plays according animation for it.
		state = ATTACK#change state to ATTACK

	if Input.is_action_just_pressed("Q_ability"):
		var blade_direction = self.global_position.direction_to(get_global_mouse_position())
		BladeSwipe(blade_direction)
	
	if Input.is_action_just_pressed("E_ability"):
		var blade_direction = self.global_position.direction_to(get_global_mouse_position())
		windblade(blade_direction)
		

		
	if Input.is_action_just_pressed("Block"):
		aniTree.set("parameters/Block/blend_position", position.direction_to(get_global_mouse_position()).normalized())#checks my mouse position and plays according animation for it.
		state = BLOCK

		
func ability_state():#function for character skill.
	velocity = Vector2.ZERO #velocity set to 0 so you can't move when attacking
	aniState.travel("Casting")#play an animation for magic attack

func roll_state():#function for rolling
	if roll_vector != Vector2.ZERO and roll_available == true:#checks if roll is available and if vector is not zero(so you can't roll if you standing still)
		set_collision_mask(64)
		velocity = roll_vector * roll_speed #the roll speed and direction
		aniState.travel("Roll")#plays the animation for roll
		move()#slide along if collide with anything
		timer.start(Roll_cooldown)#start the timer for cooldown
		set_collision_mask(1)
	else: 
		state = MOVE #state change to MOVE

func Block_state():
	get_node("Hurtbox/CollisionShape2D").disabled = true 
	velocity = Vector2.ZERO
	aniState.travel("Block")
	if Input.is_action_just_released("Block"):
		get_node("Hurtbox/CollisionShape2D").disabled = false
		state = MOVE

	
	
func attack_state():#function for attack
	velocity = Vector2.ZERO #velocity set to 0 so you can't move when attacking
	aniState.travel("Attack")#play animation for attack
	
func attack_state_finnish(): #change state to MOVE if attack is finnish
	state = MOVE
	
func ability_state_finnish(): #change state to MOVE if attack is finnish
	state = MOVE
	
func roll_animation_finnished(): #change roll_available to false and state to MOVE once the character have rolled
	roll_available = false #roll available set to false
	state = MOVE

func move():#allow character to slide when colliding with an object
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):#function for the hurtbox of the character
	if state != ROLL:#check if you are rolling
		stats.hp -= area.dps#damages player by the value of "dps" from the mob
		hurtbox.start_invincible(0.5)#character will be invincible for 0.5s
		hurtbox.hit_effect() #play the hit effect
		print(stats.hp) 


func _on_Timer_timeout(): #a function that activate when the timer runs out
	roll_available = true #character will be able to roll
	


func BladeSwipe(blade_direction:Vector2):
	if BLADESWIPE:
		var blade = BLADESWIPE.instance()
		get_tree().current_scene.add_child(blade)
		blade.global_position = self.global_position
		
		var blade_rotation = blade_direction.angle()
		blade.rotation = blade_rotation#

func windblade(blade_direction:Vector2):
	if WINDBLADE:
		var blade = WINDBLADE.instance()
		get_tree().current_scene.add_child(blade)
		blade.global_position = self.global_position
		
		var blade_rotation = blade_direction.angle()
		blade.rotation = blade_rotation


	



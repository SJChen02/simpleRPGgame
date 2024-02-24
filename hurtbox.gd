extends Area2D

const HitEffect  = preload ("res://Effects/HitEffect.tscn")#loading the hiteffect i created.

var invincible = false setget set_invincible #character will be able to be damaged when invincible is false. 
#setget allows me to get the new value when this variable change to true
onready var timer = $Timer #allow you to get the timer node(on_timer_timeout in this case) when the program starts

signal invincible_started #signal for character to not be able to be attacked
signal invincible_ended #signal for character to be able to be attacked

func set_invincible(value): #function for invincible
	invincible = value #value can only be true of false in this case.
	if invincible == true: #checks if "invincible" is true or false.
		emit_signal("invincible_started")#emits signal that invinciblility started
	else:#if "if" statement is false this activates.
		emit_signal("invincible_ended")#emits signal that invinciblility ended
		
func start_invincible(duration):
	self.invincible = true #character will not be damaged
	timer.start(duration)#starts timer
	

func hit_effect(): #creates hit effect
	var effect = HitEffect.instance()#returns a nodes that can be used as my a child of the "Hurtbox" node
	var main = get_tree().current_scene#a manager class that takes care of updating and managing all the nodes in it while 
	#                                   running in an infinite loop until the game is exitted.
	main.add_child(effect)#will add "effect" as a child node to the scene called "main"
	effect.global_position = global_position
	#gets the position of where the "effect" animation will play.


func _on_Timer_timeout(): #a function that activate when the timer runs out
	self.invincible = false #sets "invincible" to false for the character in this case.(this allows the character to be damaged)


func _on_Hurtbox_invincible_started():
	set_deferred("monitorable",false)#sets the variable "monitorable" to false at end of the program
	monitorable = false #this basically turns off the hurtbox

func _on_Hurtbox_invincible_ended():
	monitorable = true #this basically turns on the hurtbox

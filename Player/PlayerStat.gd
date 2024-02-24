extends Node

export(int) var max_hp = 1 #health stat
onready var hp = max_hp setget set_hp #gets the newest value for health

signal no_hp #sent out signal for other node to react

func set_hp(value):#gets the value from other script
	hp = value #the current hp of whatever character the script is attached to
	if hp <= 0:#if health is lower than or equal 0
		emit_signal("no_hp")#emit the signal "no_hp"

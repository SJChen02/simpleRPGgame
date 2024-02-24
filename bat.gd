extends KinematicBody2D

var knock = Vector2.ZERO
var velocity = Vector2.ZERO

export var accel = 300
export var max_speed = 50
export var fric = 200
const Enemy_death = preload("res://Effects/Death_effect.tscn")

onready var stats = $BotStats
onready var PlayerDetection = $PlayerDetection
onready var sprite = $Sprite
onready var hurtbox = $Hurtbox

enum {
	IDLE,
	WANDER,
	CHASE,
}

var state = CHASE

func _physics_process(delta):
	knock = knock.move_toward(Vector2.ZERO, fric*delta)
	knock = move_and_slide(knock)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO,fric*delta)
			search_player()
		WANDER:
			pass
		CHASE:
			var player = PlayerDetection.player
			if player != null:
				var magnetude  = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(magnetude * max_speed,accel*delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
func search_player():
	if PlayerDetection.see_player():
		state = CHASE



func _on_stats_no_hp():
	var enemy_death = Enemy_death.instance()
	get_parent().add_child(enemy_death)
	enemy_death.global_position = global_position
	queue_free()



func _on_Hurtbox_area_entered(area):
	stats.hp -= area.dps
	hurtbox.hit_effect()
	print(stats.hp)
	knock = area.knock_vector * 120

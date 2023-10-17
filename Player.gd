extends CharacterBody3D

var global_delta = 0.0
var keys = {
	"w":KEY_W,
	"a":KEY_A,
	"s":KEY_S,
	"d":KEY_D,
	"space":KEY_SPACE
}

const mouse_sensitivity = 0.5
const speed = 7.0
const friction = 0.8
const air_friction = 1
const jump = 12
const gravity = -0.5

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(delta):
	if is_multiplayer_authority():
		$Camera.current = true
	else:
		return
	
	
	global_delta = delta
	
	if is_on_floor():
		if Input.is_key_pressed(keys["space"]):
			velocity.y = jump
		else:
			velocity.y = 0
		
		velocity *= friction
		
		var input = get_axis("w", "a", "s", "d")
		velocity.x += local(input).x
		velocity.z += local(input).z
		
	else:
		velocity.y += gravity
		velocity *= Vector3(air_friction, 1, air_friction)
	
	clamp_rotation()
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y += (event.relative.x * -mouse_sensitivity * global_delta)
		rotation.x += (event.relative.y * -mouse_sensitivity * global_delta)

func get_axis(w, a, s, d):
	var joy = Vector3.ZERO
	
	if Input.is_key_pressed(keys[w]):
		joy += Vector3.FORWARD
	if Input.is_key_pressed(keys[a]):
		joy += Vector3.LEFT
	if Input.is_key_pressed(keys[s]):
		joy += Vector3.BACK
	if Input.is_key_pressed(keys[d]):
		joy += Vector3.RIGHT
	
	return joy

func local(vector):
	return (vector.x * transform.basis.x) + (vector.z * transform.basis.z) * Vector3(1, 0, 1)

func clamp_rotation():
	rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))

extends Node2D

onready var transition = $UI/Transition
onready var tilemap = $WorldMap

var requests_ratio = 0

func _ready():
	Global.text_box = ""
	calculate_switch_blocks()
	var _error = Global.connect("blocks_switched",self,"calculate_switch_blocks")
	transition.open()
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	
func _physics_process(delta): #process every frame
	#print(Global.on_sign_lbl)
	if Global.on_sign_lbl == false: #walk right if not on sign
		Global.walk = 1 #cf player.gd
	elif Global.on_sign_lbl == true: #if sign: stop walk
		Global.walk = 0
		requests_ratio = requests_ratio+1
		if requests_ratio >= 59: #runs every 60 frames on sign stopped
			$HTTPRequest.request("http://127.0.0.1:8080/index.html")
			requests_ratio = 0
		
func _on_request_completed(result, response_code, headers, body): #$HTTPRequest
	if response_code == 200:
		print(body.get_string_from_utf8())

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause"):
		var _error = get_tree().change_scene("res://UI/Menu.tscn")

func calculate_switch_blocks():
	if Global.block_switch:
		#4 to 2
		for b in tilemap.get_used_cells_by_id(4):
			tilemap.set_cellv(b,2)
		#3 to 5
		for b in tilemap.get_used_cells_by_id(3):
			tilemap.set_cellv(b,5)
	else:
		#2 to 4
		for b in tilemap.get_used_cells_by_id(2):
			tilemap.set_cellv(b,4)
		#5 to 3
		for b in tilemap.get_used_cells_by_id(5):
			tilemap.set_cellv(b,3)

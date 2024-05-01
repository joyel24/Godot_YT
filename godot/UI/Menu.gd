extends CanvasLayer

onready var transition = $Transition

var requests_ratio = 0

func _ready():
	transition.open(1.0,0.25)
	get_tree().change_scene("res://World/World.tscn") #DEBUG Run World without menu...
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	Global.walk = 0
	
func _physics_process(delta):
	requests_ratio += 1
	if requests_ratio >= 59:
		$HTTPRequest.request("http://127.0.0.1:8080/index.html?&started")
		requests_ratio = 0

func _on_request_completed(result, response_code, headers, body):
	if response_code == 299: #START GAME if http response code is 299
		_on_Load_timeout();

func _on_Play_button_down():
	transition.close(1.0)
	$Load.start(1.0)

func _on_Load_timeout():
	Global.max_coins = 0
	Global.current_coins = 0
	Global.block_switch = true
	var _error = get_tree().change_scene("res://World/World.tscn")

extends Area2D

export(String, MULTILINE) var text = ""

var temp_text: String
var decreasing_counter = 5
var temp_string: String
var completed_request = false

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	

func _on_DialogArea_body_entered(body):
	if body.has_method("is_player"):
		Global.on_sign_lbl = true #Tell you're in label (to wait cf world.gd)
		Global.text_box = text
		temp_text = text
		#print (temp_text)

func _on_DialogArea_body_exited(body):
	if body.has_method("is_player"):
		Global.on_sign_lbl = false
		#if Global.text_box == text:
		Global.text_box = ""
		temp_text = ""
			#temp_text = ""

func _physics_process(delta):
#	print ("Global.temp_text: '" + Global.temp_text + "'")
#	print ("Global.vote_score: '" + Global.vote_score + "'")
#	print ("Global.text_box: '" + Global.text_box + "'")
	if temp_text != "" && Global.vote_score != "":
		decreasing_counter = decreasing_counter-1
#		print (decreasing_counter)
#		print (Global.temp_text)
#		print (Global.vote_score)
		Global.text_box = temp_text +" "+ Global.vote_score
		#print (Global.temp_text)
#		#text = text + "test"
		Global.vote_score = ""
		#Global.temp_text = ""
		if decreasing_counter == 0:
			decreasing_counter = 5
			$HTTPRequest.request("http://127.0.0.1:8080/index.html?&vote_sum")
			yield(get_tree().create_timer(0.2), "timeout") #sleep
			#print(Global.vote_sum)
			if Global.vote_sum >= 0:
#				print ("continue")
				Global.on_sign_lbl = false
			elif Global.vote_sum < 0:
#				print ("teleport")
				Global.teleport = true
				Global.on_sign_lbl = false
			$HTTPRequest.request("http://127.0.0.1:8080/index.html?&!reset")
			
		
func _on_request_completed(result, response_code, headers, body): #$HTTPRequest
	if response_code == 200:
		temp_string = body.get_string_from_utf8()
		temp_string.erase(0,15) #remove "<!DOCTYPE html>"
		#temp_string = "[" + temp_string + "]" #score temp_string looks [0:0]
		Global.vote_sum = temp_string.to_int()
		#print(temp_string)
		temp_string = ""
		completed_request = true
		#print(Global.vote_score)

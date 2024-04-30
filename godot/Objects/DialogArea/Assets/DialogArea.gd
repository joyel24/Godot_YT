extends Area2D

export(String, MULTILINE) var text = ""

var temp_text: String

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
		#print (text)
#		print (Global.temp_text)
#		print (Global.vote_score)
		Global.text_box = temp_text +" "+ Global.vote_score
		#print (Global.temp_text)
#		#text = text + "test"
		Global.vote_score = ""
		#Global.temp_text = ""
		

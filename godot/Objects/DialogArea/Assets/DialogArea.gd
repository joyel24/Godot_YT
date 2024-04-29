extends Area2D

export(String, MULTILINE) var text = ""

func _on_DialogArea_body_entered(body):
	if body.has_method("is_player"):
		Global.on_sign_lbl = true
		Global.text_box = text

func _on_DialogArea_body_exited(body):
	if body.has_method("is_player"):
		Global.on_sign_lbl = false
		if Global.text_box == text:
			Global.text_box = ""

extends Popup

signal btnOpcionClick(valor, indiceDado)

func _on_opcionMov1_pressed():
	hide()
	emit_signal("btnOpcionClick", int(get_child(0).get_text()), get_child(0).get_index())

func _on_opcionMov2_pressed():
	hide()
	emit_signal("btnOpcionClick", int(get_child(1).get_text()), get_child(1).get_index())

func _on_opcionMov3_pressed():
	hide()
	emit_signal("btnOpcionClick", int(get_child(2).get_text()), get_child(2).get_index())

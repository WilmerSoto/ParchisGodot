extends Button

signal btnOpcionClick(valor)



func _on_opcionMov1_pressed():
	hide()
	print("BOTON1 presionado")
	emit_signal("btnOpcionClick", int(get_parent().get_child(0).get_text()))

func _on_opcionMov2_pressed():
	hide()
	print("BOTON2 presionado")
	emit_signal("btnOpcionClick", int(get_parent().get_child(1).get_text()))

func _on_opcionMov3_pressed():
	hide()
	print("BOTON3 presionado")
	emit_signal("btnOpcionClick", int(get_parent().get_child(2).get_text()))

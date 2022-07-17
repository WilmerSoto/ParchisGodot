extends Control



func _on_BtnInicio_pressed():
	var jugadores = int($VBoxContainer/OpcJugadores.get_item_text($VBoxContainer/OpcJugadores.get_selected_id()))
	var fichas = int($VBoxContainer/OpcFichas.get_item_text($VBoxContainer/OpcFichas.get_selected_id()))
	set_JugadoresFichas(jugadores, fichas)
	
	if jugadores < 5:
		get_tree().change_scene("res://Scenes/Parchis.tscn")
	else:
		get_tree().change_scene("res://Scenes/Parchis 6 Jugadores.tscn")

func set_JugadoresFichas(jugadores, fichas):
	Variablesjuego.set_numJugadores(jugadores)
	Variablesjuego.set_numFichas(fichas)

func _on_BtnCerrar_pressed():
	get_tree().quit()

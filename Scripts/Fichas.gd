extends Node2D

class_name Turnos

var ficha_actual
var ordenInicioJuego = true
var dados_inicio = 0
var juegoInicio = false
var repetirTurno = false
var colorTurno
var contadorDados = 0
var listaGanadores = []

func set_repetirTurno(turno):
	repetirTurno = turno

func get_repetirTurno():
	return repetirTurno

func iniciarTurnos():
	colorTurno = get_parent().get_node("InterfazTurno/ColorTurno")
	ficha_actual = self.get_child(0)
	colorTurno.color = ficha_actual.get_colorTurno()
	juegoInicio = true

func dadoDeshabilitado(boolean):
	var botonNode = get_parent().get_node("DadoBoton")
	if boolean == true:
		botonNode.set_default_cursor_shape(Control.CURSOR_ARROW)
	else:
		botonNode.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
	botonNode.set_disabled(boolean)

func _on_Dado_resultado_dado(dado1, dado2, suma):
	turnos(dado1,dado2,suma)

func turnos(dado1, dado2, suma):
	if ordenInicioJuego:
		dados_inicio += 1
		match dados_inicio:
			1:
				$FichasVerdes.set_dadosInicio(suma)
			2:
				$FichasRojas.set_dadosInicio(suma)
			3:
				$FichasAzules.set_dadosInicio(suma)
			4:
				$FichasAmarillas.set_dadosInicio(suma)
		if dados_inicio == Variablesjuego.get_numJugadores():
			organizar_fichas()
			iniciarTurnos()
			ordenInicioJuego = false
			for x in Variablesjuego.get_numJugadores():
				for i in Variablesjuego.get_numFichas():
					self.get_child(x).get_child(i).connect("area_entered", self, "matarFicha")
		else:
			get_parent().get_node("InterfazTurno/ColorTurno").color = get_child(dados_inicio).get_colorTurno()
			
	elif juegoInicio:
		if not ficha_actual in listaGanadores:
			ficha_actual.set_turnoEnCurso(true)
			yield(ficha_actual.play_turn(dado1, dado2, suma), "completed")
			
			if ficha_actual.get_fichasEnMeta().size() == Variablesjuego.get_numFichas():
				listaGanadores.append(ficha_actual.get_nombre())
			if listaGanadores.size() == Variablesjuego.get_numJugadores() - 1:
				var contador = 0
				for x in listaGanadores:
					var listaFichas = get_children()
					if x != listaFichas[contador].get_nombre():
						listaGanadores.append(listaFichas[contador].get_nombre())
						break
					contador += 1
				Variablesjuego.set_listaGanadores(listaGanadores)
				get_tree().change_scene("res://Scenes/ListaGanadores.tscn")
				
			if repetirTurno == false or contadorDados == 2:
				var index = (ficha_actual.get_index() + 1) % get_child_count()
				ficha_actual = get_child(index)
				colorTurno.color = ficha_actual.get_colorTurno()
				contadorDados = 0
			else:
				contadorDados += 1
		else:
			var index = (ficha_actual.get_index() + 1) % get_child_count()
			ficha_actual = get_child(index)
			colorTurno.color = ficha_actual.get_colorTurno()
			contadorDados = 0

func organizar_fichas():
	var todoFichas = get_children()
	todoFichas.sort_custom(self,"sort_fichas")
	for ficha in todoFichas:
		ficha.raise()

func sort_fichas(a,b):
	return b.get_dadosInicio() < a.get_dadosInicio()


#	var listaVerde = []
#	var listaRoja = []
#	var listaAzul = []
#	var listaAmarilla = []
#
#	for x in Variablesjuego.get_numJugadores():
#		match x:
#			0:
#				listaVerde = get_child(0).get_listaFichasJuego()
#			1:
#				listaRoja = get_child(1).get_listaFichasJuego()
#			2:
#				listaAzul = get_child(2).get_listaFichasJuego()
#			3:
#				listaAmarilla = get_child(3).get_listaFichasJuego()
#
#	if not listaVerde.empty():
#		var parentVerde = $FichasVerdes
#		for x in listaVerde:
#			if area == x:
#				parentVerde.moverACarcel(x.get_index())
#				break
#
#	elif not listaRoja.empty():
#		var parentRojo = $FichasRojas
#		for x in listaRoja:
#			if area == x:
#				parentRojo.moverACarcel(x.get_index())
#				break
#
#	elif not listaAzul.empty():
#		var parentAzul = $FichasAzules
#		for x in listaAzul:
#			if area == x:
#				parentAzul.moverACarcel(x.get_index())
#				break
#
#	elif not listaAmarilla.empty():
#		var parentAmarillo = $FichasAmarillas
#		for x in listaAmarilla:
#			if area == x:
#				parentAmarillo.moverACarcel(x.get_index())
#				break
				
				
func _on_SalidaVerde_area_entered(area):
	area.set_monitoring(false)

func _on_SalidaRojo_area_entered(area):
	area.set_monitoring(false)

func _on_SalidaAzul_area_entered(area):
	area.set_monitoring(false)

func _on_SalidaAmarillo_area_entered(area):
	area.set_monitoring(false)

func _on_SalidaAmarillo_area_exited(area):
	area.set_monitoring(true)

func _on_SalidaVerde_area_exited(area):
	area.set_monitoring(true)

func _on_SalidaRojo_area_exited(area):
	area.set_monitoring(true)

func _on_SalidaAzul_area_exited(area):
	area.set_monitoring(true)


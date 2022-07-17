extends Node2D

class_name Turnos6J

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
				$FichasVerdes6J.set_dadosInicio(suma)
			2:
				$FichasRojas6J.set_dadosInicio(suma)
			3:
				$FichasAzules6J.set_dadosInicio(suma)
			4:
				$FichasAmarillas6J.set_dadosInicio(suma)
			5:
				$FichasMoradas6J.set_dadosInicio(suma)
			6:
				$FichasNaranjas6J.set_dadosInicio(suma)
		if dados_inicio == Variablesjuego.get_numJugadores():
			organizar_fichas()
			iniciarTurnos()
			ordenInicioJuego = false
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

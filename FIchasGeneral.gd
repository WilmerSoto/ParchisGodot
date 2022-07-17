extends Node2D

class_name FichasGeneral
signal finalTurno
var dadosInicio
var colorTurno
var organizandoFichas = true
var fichasEnCarcel = false
var turnoEnCurso = false
var posFichasCurve2D = []
var posFichas = []
var movimientoDisponible = []
var movimientosPosibles = {
	0 : [7,12],
	1 : [5,10],
	2 : [5,12]
}

func set_turnoEnCurso(boolean):
	turnoEnCurso = boolean

func _ready():
	for i in Variablesjuego.get_numFichas():
		posFichas.append(0)
		posFichasCurve2D.append(0)
		movimientoDisponible.append(false)
	self.set_process_input(false)

func posFichasInicial():
	pass

func play_turn(dado1, dado2, suma):
	var funcMouse = get_parent().get_parent().get_node("MouseClick")
	var listaMovimientos = get_parent().get_parent().get_node("Movimientos/MovimientosVerde").get_curve()
	var listaSalidas = get_parent().get_parent().get_node("Movimientos/SalidaVerde")
	var listaFichasJuego = get_children()
	if organizandoFichas:
		if dado1 == dado2:
			organizandoFichas = false
			get_parent().set_repetirTurno(false)
			var salidasFicha = listaSalidas.get_children()
			var contadorPos = 0
			for i in listaFichasJuego:
				i.set_position(salidasFicha[contadorPos].get_position())
				i.set_scale(Vector2(0.18, 0.18))
				contadorPos += 1 
		else:
			get_parent().set_repetirTurno(true)

	if turnoEnCurso == true and organizandoFichas == false:
		if dado1 == dado2:
			if fichasEnCarcel:
				pass
			get_parent().set_repetirTurno(true)
		else:
			get_parent().set_repetirTurno(false)
		
		for x in Variablesjuego.get_numFichas():
			if not dado1 or not dado2 or not suma in movimientosPosibles[posFichas[x]]:
				print("NO HAY MOVIMIENTO DISPONIBLE ", x, movimientosPosibles[posFichas[x]])
				movimientoDisponible[x] = false
			else:
				print("MOVIMIENTO DISPONIBLE ", x, movimientosPosibles[posFichas[x]])
				movimientoDisponible[x] = true

		var contadorFalse = 0
		for y in movimientoDisponible:
			if y == false:
				contadorFalse += 1

		if contadorFalse == movimientoDisponible.size():
			turnoEnCurso = false
			print("SIZE ",movimientoDisponible.size())
			print("CONTADOR F ",contadorFalse)
			yield(get_tree().create_timer(0.001), "timeout")
			emit_signal("finalTurno")
			
		
		print("TURNOCURSO ",turnoEnCurso)
		print("SALIDAFICHA ",organizandoFichas)
		get_parent().dadoHabilitado(false)
		print("LISTA MOVIMIENTOS ", movimientoDisponible)
		var fichaAMover
		var dadosRestantes = suma
		var indexFicha
		funcMouse.set_listaFichas(listaFichasJuego)
		print("ESPERANDO YIELD MOUSECLICK")
		fichaAMover = yield(funcMouse, "mouseClick")
		indexFicha = fichaAMover.get_index()
		var popupFicha = fichaAMover.get_node("Control/popupOpciones")
		
		if dado1 in movimientosPosibles[posFichas[indexFicha]]:
			popupFicha.get_child(0).set_visible(true)
			popupFicha.get_child(0).set_text(str(dado1))
		else:
			popupFicha.get_child(0).set_visible(false)
			
		if dado2 in movimientosPosibles[posFichas[indexFicha]]:
			popupFicha.get_child(1).set_visible(true)
			popupFicha.get_child(1).set_text(str(dado2))
		else:
			popupFicha.get_child(1).set_visible(false)
			
		if suma in movimientosPosibles[posFichas[indexFicha]]:
			popupFicha.get_child(2).set_visible(true)
			popupFicha.get_child(2).set_text(str(suma))
		else:
			popupFicha.get_child(2).set_visible(false)
			
		popupFicha.set_position(fichaAMover.get_position())
		popupFicha.popup()
		
		var conexionSignal
		print("ESPERANDO YIELD")
		var cantidadMovimiento = yield(popupFicha, "btnOpcionClick")
		print("YIELD TERMINADO")
		var movPath2D
		if cantidadMovimiento == 5 or cantidadMovimiento == 7:
			movPath2D = 1
		elif cantidadMovimiento == 10 or cantidadMovimiento == 12:
			movPath2D = 2
		
		moverFicha(movPath2D, fichaAMover, indexFicha, listaMovimientos)
		
		emit_signal("finalTurno")
		if dadosRestantes == 0:
			funcMouse.set_process_input(false)
			get_parent().dadoHabilitado(true)
			emit_signal("finalTurno")
			turnoEnCurso = false
	print("EMITIENDO SEÑAL")
	yield(get_tree().create_timer(0.001), "timeout")
	emit_signal("finalTurno")
	

func moverFicha(cantidad, fichaAMover, indiceFicha, listaMovimientos):
	var posActual = posFichasCurve2D[indiceFicha]
	print("POS VIEJA FICHA A MOVER ", posActual)
	fichaAMover.set_position(listaMovimientos.get_point_position(posActual + cantidad))
	print("POS NUEVA ", fichaAMover.get_position())
	posFichasCurve2D[indiceFicha] = posActual + cantidad
	posFichas[indiceFicha] = (posFichas[indiceFicha] + cantidad) % 3






func get_colorTurno():
	return colorTurno

func set_dadosInicio(resultado):
	dadosInicio = resultado
	
func get_dadosInicio():
	return dadosInicio

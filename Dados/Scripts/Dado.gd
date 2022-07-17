extends AnimatedSprite
var dado2Node
var dadoBotonNode
var dado1Res
var dado2Res
var sumaDados
signal resultado_dado(dado1, dado2, suma)

func _ready():
	dado2Node = get_parent().get_node("Dado2")
	dadoBotonNode = get_parent()

func _on_DadoBoton_pressed():
	dadoBotonNode.set_disabled(true)
	dadoBotonNode.set_default_cursor_shape(Control.CURSOR_ARROW)
	self.set_frame(0)
	dado2Node.set_frame(0)
	var random = RandomNumberGenerator.new()
	random.randomize()
	dado1Res = random.randi() % 6 + 1
	dado2Res = random.randi() % 6 + 1
	sumaDados = dado1Res + dado2Res
	dado2Node.play("DadoRoll")
	self.play("DadoRoll")


func resultadoVisual(dado1, dado2):
	self.play("Dado")
	self.stop()
	dado2Node.play("Dado")
	dado2Node.stop()
	self.set_frame(dado1-1)
	dado2Node.set_frame(dado2-1)
	yield(get_tree().create_timer(0.001), "timeout")


func _on_Dado_animation_finished():
	self.resultadoVisual(dado1Res, dado2Res)
	get_parent().set_disabled(false)
	dadoBotonNode.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
	emit_signal("resultado_dado", dado1Res, dado2Res, sumaDados)

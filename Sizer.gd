extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Gen_button_down():
	$OutContainer/Output.text = ""
	
	var lista_palabras1 = $T1.text.split("\n")
	var lista_palabras2 = $T2.text.split("\n")
	var lista_palabras3 = $T3.text.split("\n")
	var lista_palabras4 = $T4.text.split("\n")
	var lista_palabras5 = $T5.text.split("\n")
	var lista_palabras6 = $T6.text.split("\n")
	
	
	lista_palabras1 = Array(lista_palabras1)
	lista_palabras1.shuffle()
	
	lista_palabras2 = Array(lista_palabras2)
	lista_palabras2.shuffle()
	
	lista_palabras3 = Array(lista_palabras3)
	lista_palabras3.shuffle()
	
	lista_palabras4 = Array(lista_palabras4)
	lista_palabras4.shuffle()
	
	lista_palabras5 = Array(lista_palabras5)
	lista_palabras5.shuffle()
	
	lista_palabras6 = Array(lista_palabras6)
	lista_palabras6.shuffle()
	
	
	
	for word in lista_palabras1:
		if(randi()&1 == 0):
			$OutContainer/Output.text += word 
		
		if(lista_palabras5.size() > 0):
			if(randi()&1 == 0):
				$OutContainer/Output.text += " " + lista_palabras5[0]
				
			lista_palabras5.pop_front() 
		
		if(lista_palabras6.size() > 0):
			if(randi()&1 == 0):
				$OutContainer/Output.text += " " + lista_palabras6[0]
			
			lista_palabras6.pop_front()
			
		if(lista_palabras2.size() > 0):
			if(randi()&1 == 0):
				$OutContainer/Output.text += " " + lista_palabras2[0] 
				
			lista_palabras2.pop_front()
		
		if(lista_palabras3.size() > 0):
			if(randi()&1 == 0):
				$OutContainer/Output.text += " " + lista_palabras3[0] 
				
			lista_palabras3.pop_front()
			
		if(lista_palabras4.size() > 0):
			if(randi()&1 == 0):
				$OutContainer/Output.text += " " + lista_palabras4[0]
				
			lista_palabras4.pop_front()
		

		

			
		$OutContainer/Output.text += "\n"
	

extends Control

@onready var arrow_1 = $ArrowControl/Arrow1
@onready var arrow_2 = $ArrowControl/Arrow2

@onready var heart_1 = $LifeControl/Heart1
@onready var heart_2 = $LifeControl/Heart2
@onready var heart_3 = $LifeControl/Heart3

func update_arrow(arrows_i):
	if arrows_i == 2:
		arrow_1.show()
		arrow_2.show()
	elif arrows_i == 1:
		arrow_1.show()
		arrow_2.hide()
	else:
		arrow_1.hide()
		arrow_2.hide()

func update_life(life):
	if life == 3:
		heart_1.show()
		heart_2.show()
		heart_3.show()
	elif life == 2:
		heart_1.show()
		heart_2.show()
		heart_3.hide()
	elif life == 1:
		heart_1.show()
		heart_2.hide()
		heart_3.hide()
	else:
		heart_1.hide()
		heart_2.hide()
		heart_3.hide()

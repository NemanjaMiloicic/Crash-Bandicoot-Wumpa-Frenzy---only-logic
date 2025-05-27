extends CanvasLayer



@onready var timer: Timer = $Timer
@onready var wumpa_label: Label = $PlayerInfoBox/WumpaFrame/WumpaLabel
@onready var crate_label: Label = $PlayerInfoBox/CrateFrame/CrateLabel
@onready var life_label: Label = $PlayerInfoBox/LifeFrame/LifeLabel


func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("inventory"):
		timer.start()
		show()


func _on_timer_timeout() -> void:
	hide()

func update_hud(wumpas : int , crates : int , total_crates : int , lives : int) -> void:
	wumpa_label.text = str(wumpas)
	crate_label.text = str(crates) + '/' + str(total_crates)
	life_label.text = str(lives)

	

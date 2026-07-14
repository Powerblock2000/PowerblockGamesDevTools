extends Control

@onready var label: Label = $Label
@onready var label_2: UsernameDisplay = $UsernameDisplay

var coins : int = 0

func _on_button_pressed() -> void:
	coins += 1

func _process(_delta: float) -> void:
	label.text = "Coins: %s" % coins

func _ready() -> void:
	var user = await NakamaManager.get_nakama_user()
	
	label_2.username = user.username

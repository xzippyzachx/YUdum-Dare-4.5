class_name SimonButton
extends Button

@export var btn_num:int

func _ready() -> void:
	GameManger.connect('play_repeat', _on_play_repeat)
	GameManger.connect('change_state', _on_change_state)

func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:	
	GameManger._check_memory(btn_num)
	focus_mode = Control.FOCUS_NONE
	_play_audio()
	
func _on_change_state(sender, state) -> void:
	if state == GameManger.GAME_STATE.GUESS:
		disabled = false
	else:
		disabled = true
	
func _on_play_repeat(sender, btn) -> void:
	if btn == btn_num:
		print(btn_num)
		_play_audio()
		disabled = false
		await get_tree().create_timer(0.4).timeout
		disabled = true
	else:
		disabled = true
		
func _play_audio() -> void:
	$AudioStreamPlayer2D.play()

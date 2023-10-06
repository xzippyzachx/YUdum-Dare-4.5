extends Node2D

enum GAME_STATE {
	GUESS,
	REPEAT,
	GAMEOVER
}
var game_state:GAME_STATE = GAME_STATE.GUESS

var round:int
var check_round:int
var memory:Array[int]

var score:int
var high_score:int

var rng = RandomNumberGenerator.new()
var score_text:RichTextLabel

signal play_repeat
signal change_state

func _ready() -> void:
	score_text = get_node("/root/Main/Score")
	
	round = 0
	_next_round()
	pass

func _process(delta: float) -> void:
	
	pass
	
func _check_memory(btn_num: int):
	if game_state != GAME_STATE.GUESS:
		return
	
	if memory[check_round] == btn_num:
		check_round += 1
		if check_round == round:
			score += 1
			score_text.text = "Score: " + str(score)
			
			await get_tree().create_timer(0.5).timeout
			_next_round()
	else:
		_end_game()
	
func _play_memory():
	for i in memory:
		emit_signal('play_repeat', self, i)
		await get_tree().create_timer(0.5).timeout
		
	game_state = GAME_STATE.GUESS
	emit_signal('change_state', self, game_state)
	
func _next_round():
	print("--------")
	game_state = GAME_STATE.REPEAT
	emit_signal('change_state', self, game_state)
	
	await get_tree().create_timer(1.0).timeout
	
	var next_num:int = rng.randf_range(1,5)
	memory.append(next_num)
	round += 1
	check_round = 0
	
	_play_memory()
	
func _end_game():
	print("Game Over!")
	game_state = GAME_STATE.GAMEOVER
	emit_signal('change_state', self, game_state)
	
	await get_tree().create_timer(2.0).timeout
	
	round = 0
	score = 0
	memory.clear()
	
	_next_round()

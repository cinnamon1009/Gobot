extends CharacterBody2D

# 移動スピード（お好みで調整してください）
const SPEED = 300.0

func _physics_process(_delta):
	# キーボードの矢印キーやWASDの入力を受け取る
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 入力があった方向に速度（velocity）を設定
	velocity = direction * SPEED
	
	# 実際にキャラクターを動かす魔法の言葉
	move_and_slide()

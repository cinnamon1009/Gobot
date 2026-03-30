extends Node2D

@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var http_request: HTTPRequest = $HTTPRequest

func _ready():
	# 起動時にサーバーから最新のマップを取得する
	http_request.request("http://localhost:8080/api/get-map")

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tile_map.local_to_map(mouse_pos)
		tile_map.set_cell(tile_pos, 0, Vector2i(0, 0))

func send_map_data():
	var cells = tile_map.get_used_cells()
	var map_array = []
	for c in cells:
		map_array.append({"x": c.x, "y": c.y})
	
	var json_data = JSON.stringify({"data": map_array})
	var headers = ["Content-Type: application/json"]
	
	http_request.request("http://localhost:8080/api/save-map", headers, HTTPClient.METHOD_POST, json_data)
	print("送信を開始しました...")

func _on_button_pressed() -> void:
	send_map_data()

# すべての通信結果をここで一括処理します
func _on_http_request_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print("通信エラー: ", response_code)
		return

	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)
	
	if json == null:
		return

	# A. 読み込み処理 (GET /api/get-map の時)
	if json.has("data") and json["data"] is Array:
		tile_map.clear()
		for t in json["data"]:
			tile_map.set_cell(Vector2i(t.x, t.y), 0, Vector2i(0, 0))
		print("サーバーからマップを読み込みました。")
	
	# B. 保存成功の確認 (POST /api/save-map の時)
	elif json.has("status") and json["status"] == "success":
		print("サーバーへの保存に成功しました。")

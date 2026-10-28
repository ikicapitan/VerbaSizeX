extends Control

enum Language { ES, JP }

@export var min_length := 1
@export var max_length := 3
@export var space := "　"
@export var chances: Array[float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]

var language: Language = Language.ES
var linebreak := "\n"
var copy_btn: Button

var translations = {
	Language.ES: {
		"gen_btn": "Generar",
		"title": "VerbaSize X",
		"copy_btn": "Copiar",
		"copied": "Copiado",
		"reset_btn": "Reset",
		"shuffle_btn": "Shuffle",
		"view_btn": "Resultado",
		"tags": ["PRONOMBRES", "SUSTANTIVOS", "VERBOS", "ADJETIVOS", "VERBOS 2", "OTROS"]
	},
	Language.JP: {
		"gen_btn": "生成する",
		"title": "VerbaSize X",
		"copy_btn": "コピー",
		"copied": "コピーしました",
		"reset_btn": "リセット",
		"shuffle_btn": "シャッフル",
		"view_btn": "結果",
		"tags": ["単語", "単語", "単語", "単語", "単語", "単語"]
	}
}

@onready var order: Array = [$Words1, $Words5, $Words6, $Words2, $Words3, $Words4]
@onready var tags: Array = [$Tags/Org1, $Tags/Org2, $Tags/Org3, $Tags/Org4, $Tags/Org5, $Tags/Org6]
@onready var output = $OutDialog/OutContainer/Output
@onready var out_dialog: AcceptDialog = $OutDialog
@onready var language_btn: Button = $LanguageBtn
@onready var view_btn: Button = $ViewBtn
@onready var reset_btn: Button = $ResetBtn
@onready var shuffle_btn: Button = $ShuffleBtn
@onready var gen_button: Button = $Gen
@onready var title_label: Label = $title

var japanese_font = preload("res://Fonts/NotoSansJP-VariableFont_wght.ttf")



func _ready() -> void:
	
	out_dialog.ok_button_text = "OK"
	output.deselect_on_focus_loss_enabled = false
	copy_btn = out_dialog.add_button("", false, "copy")
	copy_btn.add_theme_font_override("font", japanese_font)
	out_dialog.custom_action.connect(_on_custom_action)
	language_btn.pressed.connect(_on_language_btn_pressed)
	view_btn.pressed.connect(_open_output)
	reset_btn.pressed.connect(_on_reset_btn_pressed)
	shuffle_btn.pressed.connect(_on_shuffle_btn_pressed)
	view_btn.disabled = true
	_apply_language()


func _on_language_btn_pressed() -> void:
	language = Language.JP if language == Language.ES else Language.ES
	output.text = ""
	view_btn.disabled = true
	_apply_language()


func _on_reset_btn_pressed() -> void:
	for list in order:
		list.clear_all()


func _on_shuffle_btn_pressed() -> void:
	for list in order:
		list.shuffle_rows()


func _apply_language() -> void:
	var is_jp := language == Language.JP
	language_btn.text = "Español" if is_jp else "日本語"
	gen_button.text = translations[language]["gen_btn"]
	title_label.text = translations[language]["title"]
	copy_btn.text = translations[language]["copy_btn"]
	reset_btn.text = translations[language]["reset_btn"]
	shuffle_btn.text = translations[language]["shuffle_btn"]
	view_btn.text = translations[language]["view_btn"]
	var tag_texts: Array = translations[language]["tags"]
	for i in tags.size():
		tags[i].text = tag_texts[i]


func _on_custom_action(action: StringName) -> void:
	if action == "copy":
		var txt: String = output.get_selected_text() if output.has_selection() else output.text
		DisplayServer.clipboard_set(txt)
		copy_btn.text = translations[language]["copied"]
		get_tree().create_timer(1.0).timeout.connect(_apply_language)


func _on_Gen_button_down() -> void:
	output.text = _generator_jp() if language == Language.JP else _generator_es()
	view_btn.disabled = output.text.is_empty()
	_open_output()


func _open_output() -> void:
	out_dialog.popup_centered(Vector2i(700, 500))


func _generator_es() -> String:
	var arrays: Array = []
	var required: Array = []
	for i in order.size():
		var words: Array = order[i].get_words()
		words.shuffle()
		arrays.append(words)
		var p: float = chances[i] if i < chances.size() else 1.0
		if p >= 1.0 and not words.is_empty():
			required.append(i)
	var generator := ""
	while _can_continue(arrays, required):
		var line := PackedStringArray()
		for i in arrays.size():
			var p: float = chances[i] if i < chances.size() else 1.0
			if arrays[i].size() > 0 and randf() < maxf(p, 0.05):
				line.append(arrays[i].pop_front())
		if line.size() > 0:
			generator += " ".join(line) + linebreak
	return generator


func _can_continue(arrays: Array, required: Array) -> bool:
	if required.is_empty():
		for array in arrays:
			if array.size() > 0:
				return true
		return false
	for i in required:
		if arrays[i].is_empty():
			return false
	return true


func _generator_jp() -> String:
	var words: Array = []
	for list in order:
		words.append_array(list.get_words())
	words.shuffle()
	var lines := PackedStringArray()
	var i := 0
	while i < words.size():
		var n := randi_range(min_length, max_length)
		var j := mini(i + n, words.size())
		var chunk := PackedStringArray(words.slice(i, j))
		lines.append(space.join(chunk))
		i = j
	return linebreak.join(lines)

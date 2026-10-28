extends VBoxContainer
class_name WordHandler

@onready var entry: LineEdit = $Entry
@onready var rows: VBoxContainer = $Scroll/Rows
var add_btn: Button


func _ready() -> void:
	var entry_row := HBoxContainer.new()
	add_child(entry_row)
	move_child(entry_row, 0)
	entry.reparent(entry_row, false)
	entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_btn = Button.new()
	add_btn.text = "+"
	entry_row.add_child(add_btn)
	entry.text_submitted.connect(_on_text_submitted)
	add_btn.pressed.connect(_on_add_btn_pressed)


func _on_add_btn_pressed() -> void:
	_on_text_submitted(entry.text)


func _on_text_submitted(txt: String) -> void:
	txt = txt.strip_edges()
	if txt.is_empty():
		return
	add_word(txt)
	entry.clear()
	entry.grab_focus()


func add_word(txt: String) -> void:
	var row := HBoxContainer.new()
	var field := LineEdit.new()
	field.text = txt
	field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var btn := Button.new()
	btn.text = "✕"
	btn.pressed.connect(remove_row.bind(row))
	row.add_child(field)
	row.add_child(btn)
	rows.add_child(row)


func remove_row(row: Control) -> void:
	rows.remove_child(row)
	row.queue_free()


func get_words() -> Array:
	var array: Array = []
	for row in rows.get_children():
		var txt: String = row.get_child(0).text.strip_edges()
		if not txt.is_empty():
			array.append(txt)
	return array


func clear_all() -> void:
	for row in rows.get_children():
		remove_row(row)


func shuffle_rows() -> void:
	var children := rows.get_children()
	children.shuffle()
	for i in children.size():
		rows.move_child(children[i], i)

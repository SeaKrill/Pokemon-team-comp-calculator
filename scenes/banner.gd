extends PanelContainer

signal sort_option(option: String)

@onready var container := $HBox

func _ready() -> void:
	for i in container.get_children():
		#if i.name.contains("Check"): continue
		i.connect("pressed", emit_signal.bind("sort_option", i.name))

#func _fix_name(_name: String) -> String:
	#if _name.contains("_"): _name = _name.replace("_", ". ")
	#return _name

extends VBoxContainer

@onready var primary_drop := $OptionButton
@onready var secondary_drop := $OptionButton2

var selector : Control
var types : Array

var id : int

func _ready() -> void:
	var _type_keys = Data.get_script().get_script_constant_map()
	
	for i in _type_keys.keys():
		primary_drop.add_item(i)
		secondary_drop.add_item(i)
	
	primary_drop.connect("item_selected", _type_selected)
	secondary_drop.connect("item_selected", _type_selected)
	

func _type_selected(_idx: int):
	types.clear()
	types = [primary_drop.get_item_text(primary_drop.selected),
			primary_drop.get_item_text(secondary_drop.selected)]
	selector.emit_signal("type_selected", types, id)

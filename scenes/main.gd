extends Control

@onready var selector := $MarginContainer/VBoxContainer/Selector
@onready var list := $MarginContainer/VBoxContainer/Databox/ScrollBox/List

var party : Dictionary
var suggestions : Dictionary : set = _display_suggestions
var type_keys : Dictionary = Data.get_script().get_script_constant_map()

func _ready() -> void:
	selector.connect("type_selected", _type_selected)
	_create_combos()
	
func _create_combos():
	var _type_keys = Data.get_script().get_script_constant_map()
	var _type_list : Array = _type_keys.values()
	var _key_names : Array = _type_keys.keys()
	var _types : Dictionary = Data.types
	
	for _x in _type_list:
		for _y in _type_list:
			if [_x, _y] in _types or [_y, _x] in _types or _x == _y: continue
			var x_key : String = str(_key_names[_x])
			var y_key : String = str(_key_names[_y])
			var _key : Array = [Data[x_key], Data[y_key]] if x_key < y_key else [Data[y_key], Data[x_key]]
			
			_types[_key] = _pack_combo(_x, _y)
			
func _pack_combo(x: int, y: int) -> Dictionary:
	var _types : Dictionary = Data.types
	var x_def : Dictionary = _types[[x]].def
	var y_def : Dictionary = _types[[y]].def
	
	var weak : Array
	var strong : Array
	var immune : Array
	
	for m in x_def.immune:
		if not m in immune: immune.append(m)
	for m in y_def.immune:
		if not m in immune: immune.append(m)
	
	for w in x_def.weak:
		if w in y_def.strong or w in immune: continue
		weak.append(w)
	for w in y_def.weak:
		if w in x_def.strong or w in immune: continue
		weak.append(w)
		
	for w in x_def.strong:
		if w in y_def.weak or w in immune: continue
		strong.append(w)
	for w in y_def.strong:
		if w in x_def.weak or w in immune: continue
		strong.append(w)
		
	return {
		"def":{
			"weak":weak,
			"strong":strong,
			"immune":immune
		}
	}

func _type_selected(_t: Array, _id: int):
	party[_id] = _t

	var weakness : Array
	for p in party:
		var key : Array = party[p].filter(func(t): return t in type_keys).map(func(t): return type_keys[t])
		var found_entry = Data.types.get(key) if Data.types.has(key) else Data.types.get(_reversed(key))
		
		if found_entry:
			weakness.append_array(found_entry.def.weak)
		
	var _suggestions : Dictionary
	for t in Data.types:
		var _strength := 0
		for w in weakness:
			if w in Data.types[t].def.immune:
				_strength += 2
			else:
				if w in Data.types[t].def.weak:
					_strength -= 1
				if w in Data.types[t].def.strong:
					_strength += 1
			
		_suggestions[t] = _strength
		
	suggestions = _suggestions
	
func _display_suggestions(_suggestions: Dictionary):
	for i in list.get_children():
		var key = i.get_meta("type").map(func(t): return type_keys[t.to_upper()])
		var found_entry = key if Data.types.has(key) else _reversed(key)
		i.rating.text = str(_suggestions[found_entry])
		
	Data.resort.emit()
	suggestions = _suggestions

func _reversed(arr: Array) -> Array:
	var a := arr.duplicate()
	a.reverse()
	return a

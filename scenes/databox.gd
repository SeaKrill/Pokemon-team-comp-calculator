extends VBoxContainer

@onready var entry := preload("res://scenes/entry.tscn")
@onready var banner := $Banner
@onready var list := $ScrollBox/List
@onready var rating_sort := $Banner/HBox/Check

var types : Dictionary
var entries : Dictionary
var en : Array

var sort_method : String = "Id" : set = _sort_method

func _ready() -> void:
	banner.connect("sort_option", _sort_selection)
	Data.connect("resort", _resort)
	var data := Data.pokedex
	
	var _type_keys = Data.get_script().get_script_constant_map()
	for i in _type_keys:
		i = i.to_pascal_case()
		types[i] = load("res://Icons/%sIC_SM.png" % i)
	
	for i in data:
		var _id = str(int(i.id)).pad_zeros(3)
		var _sprite = load("res://sprites/%s.png" %  _id)
		var _thumbnail = load("res://thumbnails/%s.png" %  _id)
		var _entry := entry.instantiate()
		list.add_child(_entry)
		entries[_entry] = i
		en.append(_entry)
		
		_entry.sprite.texture = _sprite
		_entry.id.text = _id
		_entry.entry.text = i.name.english
		
		_entry.connect("gui_input", $"../Selector".hovered.bind(_thumbnail))
		
		for t in i.type.size():
			_entry.type[t].texture = types[i.type[t]]
		_entry.set_meta("type", i.type)
		
		var _ability = i.profile.ability
		for a in _ability.size():
			_entry.ability.text += _ability[a][0]
			if a < _ability.size() - 1:
				_entry.ability.text += "\n"
		
		var _total := 0
		for n in _entry.base:
			var _name = _entry.base[n].name
			if _name.contains("_"): _name = _name.replace("_", ". ")
			var _amount := int(i.base[_name])
			_entry.base[n].text = str(_amount)
			_total += _amount
		_entry.total.text = str(_total)

func _sort_selection(_sort: String):
	if _sort == "Check":
		_resort()
		return
	if _sort == sort_method and !_sort.contains("descend"):
		banner.get_node("HBox/%s/Sort" % _sort).text = "^"
		sort_method = "%s_descend" % _sort
		return
	elif sort_method.contains("descend"):
		sort_method = sort_method.replace("_descend", "")
	
	banner.get_node("HBox/%s/Sort" % sort_method).text = ""
	banner.get_node("HBox/%s/Sort" % _sort).text = "v"
	
	sort_method = _sort
	
func _sort_method(_sort: String):
	var _descending := _sort.contains("descend")
	sort_method = _sort
	_sort = _sort.replace("_descend", "").to_lower()
	
	var comparator : Callable
	
	if _sort in ["entry", "ability"]:
		comparator = _sort_text.bind(_sort, _descending)
	elif _sort in en[0] and en[0][_sort] is Label:
		comparator = _sort_number.bind(_sort, _descending)
	elif _sort == "type":
		comparator = func(a, b):
			var a_type = a.get_meta("type")
			var b_type = b.get_meta("type")
			
			return a_type < b_type if !_descending else a_type > b_type
	elif _sort in en[0].base:
		comparator = func(a, b):
			return int(a.base[_sort].text) < int(b.base[_sort].text) if !_descending else int(a.base[_sort].text) > int(b.base[_sort].text)
	
	if rating_sort.button_pressed:
		en.sort_custom(
			func(a, b):
				var _a = int(a.rating.text)
				var _b = int(b.rating.text)
				if _a != _b:
					return _a > _b
				return comparator.call(a,b)
		)
	else:
		en.sort_custom(comparator)
		
	for i in en.size():
		list.move_child(en[i], i)
		
func _resort():
	_sort_method(sort_method)
		
func _sort_number(a: Node, b: Node, c: String, d: bool) -> bool:
	return int(a[c].text) < int(b[c].text) if !d else int(a[c].text) > int(b[c].text)
	
func _sort_text(a: Node, b: Node, c: String, d: bool) -> bool:
	return a[c].text < b[c].text if !d else a[c].text > b[c].text

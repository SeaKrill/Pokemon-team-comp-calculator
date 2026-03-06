extends HBoxContainer

signal type_selected(_t: Array, _id: int)

@onready var poke_type := preload("res://scenes/poke_type.tscn")
@onready var thumbnail := $Thumbnail/Image

@export var party_size := 6

var image : CompressedTexture2D

func _ready() -> void:
	for i in party_size:
		var _poke = poke_type.instantiate()
		add_child(_poke)
		_poke.id = i
		_poke.selector = self

func hovered(event: InputEvent, _image: CompressedTexture2D):
	if _image != image:
		image = _image
		thumbnail.texture = _image

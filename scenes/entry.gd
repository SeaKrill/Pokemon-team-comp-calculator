extends PanelContainer

@onready var id := $Expansion/Banner/ID
@onready var entry := $Expansion/Banner/Entry
@onready var sprite := $Expansion/Banner/Sprite
@onready var type := [$"Expansion/Banner/Type/0", $"Expansion/Banner/Type/1"]
@onready var ability := $Expansion/Banner/Ability
@onready var total := $Expansion/Banner/Total
@onready var rating := $Expansion/Banner/Rating
@onready var base := {
	"hp":$Expansion/Banner/HP,
	"attack":$Expansion/Banner/Attack,
	"defense":$Expansion/Banner/Defense,
	"sp_attack":$Expansion/Banner/Sp_Attack,
	"sp_defense":$Expansion/Banner/Sp_Defense,
	"speed":$Expansion/Banner/Speed
}

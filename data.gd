extends Node

signal resort

enum {NORMAL, FIRE, WATER, ELECTRIC, GRASS, ICE, FIGHTING, POISON, GROUND, FLYING, PSYCHIC, BUG, ROCK, GHOST, DRAGON, DARK, STEEL, FAIRY}

#EXAMPLE
#NULL:{
		#"atk":{
			#"strong":[],
			#"weak":[],
			#"immune":[]
		#},
		#"def":{
			#"strong":[],
			#"weak":[],
			#"immune":[]
		#}
	#}

var pokedex : Array

var party : Dictionary

var type_counts : Dictionary

func _ready() -> void:
	var file := FileAccess.open("res://pokedex.json", FileAccess.READ)
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
		
	pokedex = json.data

var types := {
	[NORMAL]:{
		"def":{
			"weak":[FIGHTING],
			"strong":[],
			"immune":[GHOST]
		},
		"atk":{
			"weak":[ROCK, STEEL],
			"strong":[],
			"immune":[GHOST]
		},
	},
	[FIRE]:{
		"def":{
			"weak":[WATER, GROUND, ROCK],
			"strong":[FIRE, GRASS, ICE, BUG, STEEL, FAIRY],
			"immune":[]
		},
		"atk":{
			"weak":[FIRE, WATER, ROCK, DRAGON],
			"strong":[GRASS, ICE, BUG, STEEL],
			"immune":[]
		}
	},
	[WATER]:{
		"def":{
			"weak":[ELECTRIC, GRASS],
			"strong":[FIRE, WATER, ICE, STEEL],
			"immune":[]
		},
		"atk":{
			"weak":[WATER, GRASS, DRAGON],
			"strong":[FIRE, GROUND, ROCK],
			"immune":[]
		}
	},
	[ELECTRIC]:{
		"atk":{
			"strong":[WATER, FLYING],
			"weak":[ELECTRIC, GRASS, DRAGON],
			"immune":[GROUND]
		},
		"def":{
			"strong":[ELECTRIC, FLYING, STEEL],
			"weak":[GROUND],
			"immune":[]
		}
	},
	[GRASS]:{
		"atk":{
			"strong":[WATER, GROUND, ROCK],
			"weak":[FIRE, GRASS, POISON, FLYING, BUG, DRAGON, STEEL],
			"immune":[]
		},
		"def":{
			"strong":[WATER, ELECTRIC, GRASS, GROUND],
			"weak":[FIRE, ICE, POISON, FLYING, BUG],
			"immune":[]
		}
	},
	[ICE]:{
		"atk":{
			"strong":[GRASS, GROUND, FLYING, DRAGON],
			"weak":[FIRE, WATER, ICE, STEEL],
			"immune":[]
		},
		"def":{
			"strong":[ICE],
			"weak":[FIRE, FIGHTING, ROCK, STEEL],
			"immune":[]
		}
	},
	[FIGHTING]:{
		"atk":{
			"strong":[NORMAL, ICE, ROCK, DARK, STEEL],
			"weak":[POISON, FLYING, PSYCHIC, BUG, FAIRY],
			"immune":[GHOST]
		},
		"def":{
			"strong":[BUG, ROCK, DARK],
			"weak":[FLYING, PSYCHIC, FAIRY],
			"immune":[]
		}
	},
	[POISON]:{
		"atk":{
			"strong":[GRASS, FAIRY],
			"weak":[POISON, GROUND, ROCK, GHOST],
			"immune":[STEEL]
		},
		"def":{
			"strong":[GRASS, FIGHTING, POISON, BUG, FAIRY],
			"weak":[GROUND, PSYCHIC],
			"immune":[]
		}
	},
	[GROUND]:{
		"atk":{
			"strong":[FIRE, ELECTRIC, POISON, ROCK, STEEL],
			"weak":[GRASS, BUG],
			"immune":[FLYING]
		},
		"def":{
			"strong":[POISON, ROCK],
			"weak":[WATER, GRASS, ICE],
			"immune":[ELECTRIC]
		}
	},
	[FLYING]:{
		"atk":{
			"strong":[GRASS, FIGHTING, BUG],
			"weak":[ELECTRIC, ROCK, STEEL],
			"immune":[]
		},
		"def":{
			"strong":[GRASS, FIGHTING, BUG],
			"weak":[ELECTRIC, ICE, FLYING],
			"immune":[GROUND]
		}
	},
	[PSYCHIC]:{
		"atk":{
			"strong":[FIGHTING, POISON],
			"weak":[PSYCHIC, STEEL],
			"immune":[DARK]
		},
		"def":{
			"strong":[FIGHTING, PSYCHIC],
			"weak":[BUG, GHOST, DARK],
			"immune":[]
		}
	},
	[BUG]:{
		"atk":{
			"strong":[GRASS, PSYCHIC, DARK],
			"weak":[FIRE, FIGHTING, POISON, FLYING, GHOST, STEEL, FAIRY],
			"immune":[]
		},
		"def":{
			"strong":[GRASS, FIGHTING, GROUND],
			"weak":[FIRE, FLYING, ROCK],
			"immune":[]
		}
	},
	[ROCK]:{
		"atk":{
			"strong":[FIRE, ICE, FLYING, BUG],
			"weak":[FIGHTING, GROUND, STEEL],
			"immune":[]
		},
		"def":{
			"strong":[NORMAL, FIRE, POISON, FLYING],
			"weak":[WATER, GRASS, FIGHTING, GROUND, STEEL],
			"immune":[]
		}
	},
	[GHOST]:{
		"atk":{
			"strong":[PSYCHIC, GHOST],
			"weak":[DARK],
			"immune":[NORMAL]
		},
		"def":{
			"strong":[POISON, BUG],
			"weak":[GHOST, DARK],
			"immune":[NORMAL, FIGHTING]
		}
	},
	[DRAGON]:{
		"atk":{
			"strong":[DRAGON],
			"weak":[STEEL],
			"immune":[FAIRY]
		},
		"def":{
			"strong":[FIRE, WATER, ELECTRIC, GRASS],
			"weak":[ICE, DRAGON, FAIRY],
			"immune":[]
		}
	},
	[DARK]:{
		"atk":{
			"strong":[PSYCHIC, GHOST],
			"weak":[FIGHTING, DARK, FAIRY],
			"immune":[]
		},
		"def":{
			"strong":[GHOST, DARK],
			"weak":[FIGHTING, BUG, FAIRY],
			"immune":[PSYCHIC]
		}
	},
	[STEEL]:{
		"atk":{
			"strong":[ICE, ROCK, FAIRY],
			"weak":[FIRE, WATER, ELECTRIC, STEEL],
			"immune":[]
		},
		"def":{
			"strong":[NORMAL, GRASS, ICE, FLYING, PSYCHIC, BUG, ROCK, DRAGON, STEEL, FAIRY],
			"weak":[FIRE, FIGHTING, GROUND],
			"immune":[POISON]
		}
	},
	[FAIRY]:{
		"atk":{
			"strong":[FIGHTING, DRAGON, DARK],
			"weak":[FIRE, POISON, STEEL],
			"immune":[]
		},
		"def":{
			"strong":[FIGHTING, BUG, DARK],
			"weak":[POISON, STEEL],
			"immune":[DRAGON]
		}
	}
}

extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH ="res://Textures/Items/Weapons/"
const UPGRADES = {
	"health1":{
		"icon": ICON_PATH + "Burger.png",
		"displayname": "Burger",
		"details": "Increase Maxhealth by 20",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"health2":{
		"icon": ICON_PATH + "Burger.png",
		"displayname": "Burger",
		"details": "Increase Maxhealth by 20",
		"level": "Level: 1",
		"prerequisite": ["health1"],
		"type": "upgrade"
	},
	"health3":{
		"icon": ICON_PATH + "Burger.png",
		"displayname": "Burger",
		"details": "Increase Maxhealth by 20",
		"level": "Level: 1",
		"prerequisite": ["health2"],
		"type": "upgrade"
	},
	"health4":{
		"icon": ICON_PATH + "Burger.png",
		"displayname": "Burger",
		"details": "Increase Maxhealth by 20",
		"level": "Level: 1",
		"prerequisite": ["health3"],
		"type": "upgrade"
	},
	"armor1": {
		"icon": ICON_PATH + "Candy.png",
		"displayname": "Bonbon",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "Candy.png",
		"displayname": "Bonbon",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "Candy.png",
		"displayname": "Bonbon",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "Candy.png",
		"displayname": "Bonbon",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "Coffee.png",
		"displayname": "Espresso",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "Coffee.png",
		"displayname": "Espresso",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "Coffee.png",
		"displayname": "Espresso",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "Coffee.png",
		"displayname": "Espresso",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "Melone.png",
		"displayname": "Wassermelone",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "Melone.png",
		"displayname": "Wassermelone",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "Melone.png",
		"displayname": "Wassermelone",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "Melone.png",
		"displayname": "Wassermelone",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		#"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Minztee",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		#"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Minztee",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		#"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Minztee",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		#"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Minztee",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "Popcorn.png",
		"displayname": "Popcorn",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "Popcorn.png",
		"displayname": "Popcorn",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "GoldenApple.png",
		"displayname": "Golden Apple",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}

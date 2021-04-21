extends Node2D

onready var player_cards := $PlayerHand/Cards
onready var drop_zone := $CardDropZone/Zone
var drop_zone_size := Vector2(576, 288)

var card_to_play : Card = null
var cursor_in_zone := false


func _on_PlayerHand_card_dropped(cursor_position: Vector2, card: Card) -> void:
	if is_cursor_in_dropzone():
		card.use()

func is_cursor_in_dropzone() -> bool:
	var cursor = get_global_mouse_position()
	return (
		cursor.x > (drop_zone.global_position - drop_zone_size).x and 
		cursor.y > (drop_zone.global_position - drop_zone_size).y and
		cursor.x < (drop_zone.global_position + drop_zone_size).x and
		cursor.y < (drop_zone.global_position + drop_zone_size).y
	)

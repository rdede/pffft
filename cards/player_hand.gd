extends Node2D

var CardBase = preload("res://cards/card.tscn")
var cards := 0 
var card_in_mouse : Card = null
var card_offset := 10.0
enum CARD_STATES {IN_HAND, IN_MOUSE, REORGANIZE}

onready var center_card_hand := get_viewport().size * Vector2(0.5, 1) - Vector2(0, 130)
onready var hand := $Cards

signal card_dropped

func _process(delta: float) -> void:
	#Check if a card is in mouse
	var card_in_mouse_temp = null
	for card in hand.get_children():
		if card.current_state == CARD_STATES.IN_MOUSE:
			card_in_mouse_temp = card
			continue
	
	# Reorganize card hand if card in mouse change
	if card_in_mouse != card_in_mouse_temp:
		organize_cards()
		card_in_mouse = card_in_mouse_temp
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Secondary_Click"):
		draw_card()

func draw_card() -> void:
	cards += 1
	var new_card = CardBase.instance()
	hand.add_child(new_card)
	new_card.connect("droped", self, "_on_Card_dropped")
	new_card.connect("used", self, "_on_Card_used")
	organize_cards()

func organize_cards() -> void:
	var cards_processed := 0
	var cards_in_hand := cards
	for card in hand.get_children():
		if card.wait_to_remove:
			continue
		if card.current_state == CARD_STATES.IN_MOUSE:
			cards_in_hand -= 1
			continue
		card.current_state = CARD_STATES.REORGANIZE
		var x_pos = center_card_hand.x - card.rect_size.x + ((card.rect_size.x * cards_in_hand + card_offset * cards_in_hand) / 2) 
		x_pos -= card.rect_size.x * cards_processed + card_offset * cards_processed
		card.target_pos = Vector2(round(x_pos), round(center_card_hand.y))
		cards_processed += 1

func _on_Card_dropped(cursor_position: Vector2, card: Card) -> void:
	emit_signal("card_dropped", cursor_position, card)

func _on_Card_used(card: Card) -> void:
	card.queue_free()
	card_in_mouse = null
	cards -= 1
	organize_cards()

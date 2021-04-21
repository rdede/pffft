extends Node2D

var CardBase = preload("res://cards/card.tscn")
var cards := [] 
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
	var new_card = CardBase.instance()
	
	# Add card to the array
	cards.append(new_card)
	
	# Add card to the game screen
	hand.add_child(new_card)
	
	# Connect signals
	new_card.connect("droped", self, "_on_Card_dropped")
	new_card.connect("used", self, "_on_Card_used")
	
	# Reorganize cards
	organize_cards()

func organize_cards() -> void:
	var cards_processed := 0
	var cards_in_hand := cards.size()
	for card in cards:
		# If card is waiting to be removed with queu_free(), do not process it
		if card.wait_to_remove:
			continue
		# If card is grabbed by the mouse, do not process it
		if card.current_state == CARD_STATES.IN_MOUSE:
			cards_in_hand -= 1
			continue
		# Set the card state to be reorganized
		card.current_state = CARD_STATES.REORGANIZE
		
		# Defines the card x position relative to the total number of cards in hand...
		var x_pos = center_card_hand.x - card.container.rect_size.x + ((card.container.rect_size.x * cards_in_hand + card_offset * cards_in_hand) / 2) 
		# ...and the number of processed cards  
		x_pos -= card.container.rect_size.x * cards_processed + card_offset * cards_processed
		# Set it as card target pos to "animate" the lineare interpolation of the card.
		card.target_pos = Vector2(round(x_pos), round(center_card_hand.y))
		
		cards_processed += 1

func _on_Card_dropped(cursor_position: Vector2, card: Card) -> void:
	emit_signal("card_dropped", cursor_position, card)

func _on_Card_used(card: Card) -> void:
	#
	# Play card use animation here
	#

	# Remove the card instance
	card.queue_free()
	
	# Free the mouse from card
	card_in_mouse = null
	assert(cards.has(card), "Card " + str(card) + " does not exists in the hand")
	
	# Remove the card from the player hand
	cards.remove(cards.find(card))
	organize_cards()

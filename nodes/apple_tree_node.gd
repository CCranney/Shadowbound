extends StaticBody3D

@onready var area_3d: Area3D = $Area3D
@onready var basket_mesh: MeshInstance3D = $Basket

@export var is_basket_present: bool = false:
	set(new_value):
		is_basket_present = new_value
		if basket_mesh:
			basket_mesh.visible = new_value
			
func _ready() -> void:
	basket_mesh.visible = is_basket_present

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not CharacterBody3D: return
	if body.player_holding_status == body.PlayerHolding.NOTHING and is_basket_present:
		print("Player is holding the basket now!")	
		is_basket_present = false
		body.player_holding_status = body.PlayerHolding.BASKET
	elif body.player_holding_status == body.PlayerHolding.BASKET and !is_basket_present:
		print("Player dropped off the basket!")	
		is_basket_present = true
		body.player_holding_status = body.PlayerHolding.NOTHING

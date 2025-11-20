extends Area3D

signal objective_fulfilled

@onready var diamond_mesh: MeshInstance3D = $DiamondMesh

@export var is_final_objective := false
@export var is_diamond_inserted: bool = false:
	set(new_value):
		is_diamond_inserted = new_value
		if diamond_mesh:
			diamond_mesh.visible = new_value
		if is_final_objective and new_value:
			objective_fulfilled.emit()

func _ready() -> void:
	diamond_mesh.visible = is_diamond_inserted

func _on_body_entered(body: Node3D) -> void:
	if body is not CharacterBody3D: return
	if body.player_holding_status == body.PlayerHolding.NOTHING and is_diamond_inserted:
		is_diamond_inserted = false
		body.player_holding_status = body.PlayerHolding.DIAMOND
	elif body.player_holding_status == body.PlayerHolding.DIAMOND and !is_diamond_inserted:
		is_diamond_inserted = true
		body.player_holding_status = body.PlayerHolding.NOTHING

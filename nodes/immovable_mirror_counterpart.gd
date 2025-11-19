class_name ImmovableMirrorCounterpart
extends StaticBody3D

var original_node: Node3D

func _init(original: Node3D):
	original_node = original
	global_transform = original_node.global_transform
	for child in original_node.get_children():
		var duplicate_child = child.duplicate(DuplicateFlags.DUPLICATE_GROUPS)
		add_child(duplicate_child)
	global_transform = find_mirror_transform(original_node)
	
func _process(_delta) -> void:
	global_transform = find_mirror_transform(original_node)
	
func find_mirror_transform(node: Node3D) -> Transform3D:
	var t : Transform3D = node.global_transform
	t.origin.z = -t.origin.z
	t.basis = t.basis.scaled(Vector3(1, 1, -1))
	return t

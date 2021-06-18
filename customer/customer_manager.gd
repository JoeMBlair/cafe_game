extends Node

var customer_groups : Array
var tables : Array
var chairs : Array
var free_chairs : Array
var customer_path
var spawn_pos

func _ready():
	var door_nodes = get_tree().get_nodes_in_group("Door")
	spawn_pos = door_nodes[0].global_position
	customer_path = $Customer.filename
	$Customer.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	tables = get_tables()
	chairs = get_chairs()
	free_chairs = get_chairs()
	spawn()

func _process(delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("spawn"):
		spawn()

func get_tables():
	tables.clear()
	var table_nodes = get_tree().get_nodes_in_group("Table")
	var return_tables : Array
	for single_table in table_nodes:
		return_tables += [{"SpacesLeft": single_table.chairs.size(), "Node": single_table, "Chairs": single_table.chairs}]
	return return_tables
	
func get_chairs():
	chairs.clear()
	var return_chairs : Array
	for single_table in tables:
		for single_chair in single_table.Chairs:
			return_chairs += [{"Node": single_chair.Node, "Plate": single_chair.Plate,
			 "Table": single_table, "InUse": false}]
	return return_chairs

func get_nearest_chair(player):
	var nearest_chair = free_chairs[0]
	var nearest_index = 0
	for single_chair in free_chairs.size():
		var single_chair_distance = free_chairs[single_chair].Node.global_position.distance_to(player.global_position)
		var nearest_chair_distance = free_chairs[single_chair].Node.global_position.distance_to(player.global_position)
		if single_chair_distance < nearest_chair_distance:
			nearest_chair = free_chairs[single_chair]
			nearest_index = single_chair
	
	free_chairs.remove(nearest_index)
	return nearest_chair

func spawn():
	var customer = load(customer_path).instance()
	add_child(customer)
	customer.global_position = spawn_pos
	customer.chosen_chair = get_nearest_chair(customer)
	customer_groups += [customer]
	pass

extends Node

var customer_groups : Array # [{Customers, Table}][{...}]
var tables : Dictionary # {TableNode: {Chairs, FreeChairs}, ...: {...}}
#var chairs : Array # [{Node, Plate, Table, InUse}{...}]
#var free_chairs : Array # [{Node, Plate, Table, InUse}{...}]
export(String, "easy", "normal", "hard", "extreme") var level = "easy"
var level_count = 1
var spawn_rate = {
	"easy": [1, 1, 1, 1, 1, 1, 1, 2, 2, 3],
	"normal": [1, 1, 1, 1, 1, 2, 2, 2, 3, 3],
	"hard": [1, 1, 1, 2, 2, 2, 2, 3, 3, 3],
	"extreme": [1, 2, 2, 2, 2, 3, 3, 3, 3, 3]
				}
var customer_path
var spawn_pos

func _ready():
	pass


func _process(_delta):
	get_input()
	if customer_groups.size() > 0:
		manage_groups()
	match level_count:
		1: if not level == "easy": level = "easy"
		2: if not level == "normal": level = "normal"
		3: if not level == "hard": level = "hard"
		4: if not level == "extreme": level = "extreme"

func get_input():
	if Input.is_action_just_pressed("spawn"):
		spawn_group(0)


func manage_groups():
	for group in customer_groups:
		var is_done = true
		for customer in group.Customers:
			if not customer.state == "ate":
				is_done = false
				break
		if is_done:
			for customer in group.Customers:
				yield(get_tree().create_timer(0.4), "timeout")
				customer.state = "home"
			customer_groups.erase(group)
			tables[group.Table].InUse = false
			level_count += 1
			spawn_group(0)


func get_tables():
	tables.clear()
	var table_nodes = get_tree().get_nodes_in_group("Table")
	var return_tables : Dictionary
	for single_table in table_nodes:
		return_tables[single_table] = {
			"Node": single_table, 
			"Chairs": single_table.get_chairs(),
			"FreeChairs": single_table.chairs,
			"InUse": false
			}
	return return_tables
	
#func get_chairs():
#	chairs.clear()
#	var return_chairs : Array
#	for single_table in tables:
#		for single_chair in single_table.Chairs:
#			return_chairs += [{
#				"Node": single_chair.Node, 
#				"Plate": single_chair.Plate, 
#				"Table": single_table, 
#				"InUse": false
#				}]
#	return return_chairs

func get_nearest_table(group_size):
	for table in tables:
		if not tables[table].InUse and tables[table].FreeChairs.size() >= group_size:
			return {"Node": table, "Table": tables[table]}


func get_nearest_chair(player, table = null):
	var free_chairs : Array
	if table:
		free_chairs = tables[table].FreeChairs
	else:
		for table in tables:
			free_chairs += tables[table].FreeChairs
			
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
	return customer
	pass

func spawn_group(size):
	var group : Array
	var group_size
	if size == 0:
		randomize()
		group_size = spawn_rate[level][rand_range(0, spawn_rate[level].size())]
	else:
		group_size = size
		
	var available_table = get_nearest_table(group_size)
	for i in group_size:
		var customer = spawn()
		group += [customer]
	if available_table:
		for customer in group:
			customer.chosen_chair = get_nearest_chair(customer, available_table.Node)
			available_table.Table.FreeChairs.erase(customer.chosen_chair)
			available_table.Table.InUse = true
			yield(get_tree().create_timer(0.5), "timeout")
		customer_groups += [{"Customers": group, "Table": available_table.Node}]
		pass


func _on_Main_ready():
	yield(get_tree().create_timer(0.5), "timeout")
	var door_nodes = get_tree().get_nodes_in_group("Door")
	spawn_pos = door_nodes[0].global_position
	
	tables = get_tables()
	
	customer_path = get_node("Customer").filename
	$Customer.queue_free()
	spawn_group(0)

@tool
extends Node

var nakama_client : NakamaClient
var nakama_session : NakamaSession
var nakama_socket : NakamaSocket

var logged_in : bool = false

func _ready() -> void:
	print("READY ID: %s, path: %s" % [get_instance_id(), get_path()])
	
	if !FileAccess.file_exists("res://ACCOUNT_CREDENTIALS"):
		push_error("Please LOG IN in the dock!")
		return
	
	var account_cred : ConfigFile = ConfigFile.new()
	account_cred.load("res://ACCOUNT_CREDENTIALS")
	
	for email in account_cred.get_section_keys("Account creds"):
		var password : String = account_cred.get_value("Account creds", email)
		print("CONNECTING")
		await connect_to_powerblock_games(email, password)
		break

func connect_to_powerblock_games(email: String, password: String) -> void:
	if logged_in: return
	logged_in = true
	#nakama_client = Nakama.create_client()
	
	var http : HTTPRequest = HTTPRequest.new()
	add_child(http)
	
	var url : String = "http://0.0.0.0:8000/get-server-key?email=%s" % email
	var headers = [
		"password: Bearer %s" % password
	]
	
	http.request(
		url,
		headers,
		HTTPClient.METHOD_GET
	)
	
	var response : Array = await http.request_completed
	
	if response[1] != 200:
		push_error("Unable to get server key: %s" % (response[3] as PackedByteArray).get_string_from_utf8())
		return
	
	var dict = JSON.parse_string((response[3] as PackedByteArray).get_string_from_utf8())
	#print(dict)
	#return
	
	if dict == null:
		push_error("Error parsing JSON")
		return
	
	var server_key : String = dict["key"]
	var session_token : String = dict["session_token"]
	
	nakama_client = await Nakama.create_client(server_key, "api.nakama.powerblock.hackclub.app", 443, "https")
	nakama_socket = await Nakama.create_socket_from(nakama_client)
	
	nakama_session = await NakamaSession.new(session_token)
	
	var connected : NakamaAsyncResult = await nakama_socket.connect_async(nakama_session)
	
	if connected.is_exception():
		push_error("Failed connecting socket: %s" % connected.exception.message)
		return
	print("=-=-=-=-=-=\nConnected!\n=-=-=-=-=-=")

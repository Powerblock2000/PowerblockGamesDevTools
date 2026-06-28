@tool
extends MarginContainer

@onready var password_le: LineEdit = $PowerblockGamesDock/Login/PasswordHB/Password
@onready var email_le: LineEdit = $PowerblockGamesDock/Login/Email
@onready var login: Button = $PowerblockGamesDock/Login/Login

var nakama_client
var nakama_socket
var nakama_session

func _on_show_password_toggled(toggled_on: bool) -> void:
	password_le.secret = !toggled_on

func _process(delta: float) -> void:
	if password_le.text != "" and email_le.text != "":
		login.disabled = false
	else:
		login.disabled = true

func connect_to_powerblock_games(email: String, password: String) -> void:
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
	
	await nakama_client.session_logout_async(nakama_session)
	
	var email_pw_save : ConfigFile = ConfigFile.new()
	
	email_pw_save.set_value("Account creds", email, password)
	
	email_pw_save.save("res://ACCOUNT_CREDENTIALS")

func _on_login_pressed() -> void:
	connect_to_powerblock_games(email_le.text, password_le.text)

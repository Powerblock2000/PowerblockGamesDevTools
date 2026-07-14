extends Node

# Nakama variables
var nakama_client : NakamaClient
var nakama_socket : NakamaSocket
var nakama_session : NakamaSession
var nakama_account : NakamaAPI.ApiAccount
var nakama_user : NakamaAPI.ApiUser

signal _connected(error: Error)

var status : String
var authenticating : bool = true

var started_auth: bool = false

var server_id : String = ""

func get_nakama_account() -> NakamaAPI.ApiAccount:
	await get_tree().create_timer(.1).timeout
	return null

func get_nakama_user() -> NakamaAPI.ApiUser:
	await get_tree().create_timer(.1).timeout
	return null

func get_avatar_url() -> String:
	await get_tree().create_timer(.1).timeout
	return ""

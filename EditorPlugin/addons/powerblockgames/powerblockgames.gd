@tool
extends EditorPlugin

const POWERBLOCK_GAMES_DOCK_SCENE = preload("uid://48hyaje3ye6j")
var dock : EditorDock

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton("NakamaManager", "res://addons/powerblockgames/GameManager/GameManager.gd")
	add_autoload_singleton("Nakama", "res://addons/powerblockgames/com.heroiclabs.nakama/Nakama.gd")

func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton("NakamaManager")
	remove_autoload_singleton("Nakama")

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	var powerblock_games_dock : MarginContainer = POWERBLOCK_GAMES_DOCK_SCENE.instantiate()
	dock = EditorDock.new()
	dock.add_child(powerblock_games_dock)
	
	dock.title = "Powerblock Games"
	dock.default_slot = EditorDock.DOCK_SLOT_BOTTOM
	
	dock.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
	add_dock(dock)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_dock(dock)
	dock.queue_free()

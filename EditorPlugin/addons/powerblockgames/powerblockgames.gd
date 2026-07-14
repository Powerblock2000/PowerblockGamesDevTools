@tool
extends EditorPlugin

var dock : EditorDock

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton("NakamaManager", "res://addons/powerblockgames/NakamaManager.gd")
	add_autoload_singleton("Nakama", "res://addons/powerblockgames/com.heroiclabs.nakama/Nakama.gd")

func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton("NakamaManager")
	remove_autoload_singleton("Nakama")

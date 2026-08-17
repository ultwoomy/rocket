extends Control
@onready var red_arrow : TextureRect = $RedArrow
@onready var click_here : Label = $Label
@onready var scroll_instruction : Label = $Label2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OhzeroData.tutorial_progress == 3:
		click_here.text = "Now click here to create a module"
		red_arrow.position = Vector2(800,175)
	elif OhzeroData.tutorial_progress == 4:
		scroll_instruction.text = "Click on fuel until you have enough for the next module"
		OhzeroData.tutorial_progress = 5
		red_arrow.hide()
		click_here.hide()
	elif OhzeroData.tutorial_progress == 6:
		scroll_instruction.text = "If you need any further explanations talk to me again a few times. This concludes the tutorial."
		red_arrow.hide()
		click_here.hide()
		OhzeroData.tutorial_progress = -1
	else:
		red_arrow.hide()
		click_here.hide()
		scroll_instruction.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

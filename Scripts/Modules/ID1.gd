extends BaseModule
class_name ID1
@onready var text : Label = $Panel/Lines
@onready var progbar : ProgressBar = $Panel/ProgressBar
@onready var upgrade1 : Button = $Panel/Button
@onready var upgrade2 : Button = $Panel/Button2
@onready var upgrade3 : Button = $Panel/Button3
@onready var panel1 : Label = $Panel/Button/Label
@onready var panel2 : Label = $Panel/Button2/Label
@onready var panel3 : Label = $Panel/Button3/Label

var thresh_max : float = 80
var prog : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FuelManager.fuel_lines_changed.connect(self.update_lines)
	FuelManager.fuel_changed.connect(self.fuel_increased)
	progbar.max_value = thresh_max
	update_prices()
	update_lines()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func fuel_increased():
	if enabled:
		prog += FuelManager.ID1_data.fuel_line_gain_rate
	if prog >= thresh_max:
		FuelManager.gain_lines()
		prog -= thresh_max
	progbar.value = prog

func update_lines():
	text.text = str(NumberManager.get_scientific(FuelManager.fuel_lines)) + " lines"

func _on_button1_pressed() -> void:
	if FuelManager.subtract_fuel(FuelManager.ID1_data.COST_line_gain_rate) and enabled:
		FuelManager.ID1_fuel_line_gain_rate_up()
		update_prices()

func update_prices():
	panel1.text = "Cost:\n" + str(NumberManager.get_scientific(FuelManager.ID1_data.COST_line_gain_rate))
	panel2.text = "Cost:\n" + str(NumberManager.get_scientific(FuelManager.ID1_data.COST_fuel_line_mod))
	panel3.text = "Cost:\n" + str(NumberManager.get_scientific(FuelManager.ID1_data.COST_fuel_line_mult)) + " lines"

func _on_button_2_pressed() -> void:
	if FuelManager.subtract_fuel(FuelManager.ID1_data.COST_fuel_line_mod) and enabled:
		FuelManager.ID1_fuel_gain_mod()
		update_prices()

func _on_button_3_pressed() -> void:
	if FuelManager.subtract_lines(FuelManager.ID1_data.COST_fuel_line_mult) and enabled:
		FuelManager.ID1_fuel_line_gain_mult()
		update_prices()

extends Control

# SIGNALS
signal threeshold_reached

# VARIABLES
var input_device_list := AudioServer.get_input_device_list()
var input_device: String

var effect: AudioEffectRecord
var bus_index: int = -1

var volume_samples: Array = []
const SAMPLES_COUNT := 10
var boost_gain: float = 1.0

var current_normalized_volume: float = 0.0
var threshold_limit: float = 0.5

# FUNCTIONS
func check_audio_driver_enabled() -> void:
	if not ProjectSettings.get_setting("audio/driver/enable_input"):
		push_error("No audio driver found. Please enable in Project -> Project Settings -> Audio -> Driver -> Check Enable Input")
		assert(false)

func setup_record_bus() -> void:
	if AudioServer.get_bus_index("ThresholdRecord") == -1:
		AudioServer.add_bus()
		var new_bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(new_bus_index, "ThresholdRecord")
		
		# Add Record Effect at position 0
		var record_effect = AudioEffectRecord.new()
		AudioServer.add_bus_effect(new_bus_index, record_effect, 0)


func calculate_average_volume() -> float:
	# Peak volume for left and right channels
	var max_lr_volume = maxf(
		db_to_linear(AudioServer.get_bus_peak_volume_left_db(bus_index, 0)),
		db_to_linear(AudioServer.get_bus_peak_volume_right_db(bus_index, 0))
	)
	
	# push last volume sample to the front
	volume_samples.push_front(max_lr_volume)
	# slice array to only keep the last SAMPLES_COUNT samples
	if volume_samples.size() > SAMPLES_COUNT:
		volume_samples.pop_back()

	# calculate average volume from samples
	var total_volume: float = 0.0
	for sample in volume_samples:
		total_volume += sample
	
	return total_volume / volume_samples.size()
	

# BUILT-IN METHODS
func _ready() -> void:
	# setup_record_bus
	check_audio_driver_enabled()
	setup_record_bus()
	$MicInput.bus = &"ThresholdRecord"

	bus_index = AudioServer.get_bus_index("ThresholdRecord")
	effect = AudioServer.get_bus_effect(bus_index, 0)

	effect.set_recording_active(true)
	$VolumeBar.min_value = 0.0
	$VolumeBar.max_value = 0.4
	
	$BoostSlider.min_value = 0.1
	$BoostSlider.max_value = 3.0
	$BoostSlider.value = 2.0
	$BoostSlider.step = 0.1
	boost_gain = 1.0

	$ThresholdSlider.min_value = $VolumeBar.min_value
	$ThresholdSlider.max_value = $VolumeBar.max_value
	$ThresholdSlider.value = 0.1
	$ThresholdSlider.step = 0.01


func _process(_delta: float) -> void:
	# update volume bar only if recording is active
	if effect and effect.is_recording_active():
		# calculate average volume from the last samples and update the volume bar
		var average_volume = calculate_average_volume()
		# apply boost gain and clamp the value between 0 and 1
		current_normalized_volume = clamp(average_volume * boost_gain, 0.0, 1.0)

	# threshold_limit
	if current_normalized_volume > threshold_limit:
		emit_signal("threeshold_reached")

	# UI
	$VolumeBar.value = current_normalized_volume



# SIGNAL CALLBACKS
func _on_input_device_option_button_pressed() -> void:
	$InputDeviceOptionButton.clear()
	for device in input_device_list:
		$InputDeviceOptionButton.add_item(device)


func _on_InputDeviceOptionButton_item_selected(index: int) -> void:
	AudioServer.set_input_device(input_device_list[index])


func _on_boost_slider_value_changed(value: float) -> void:
	boost_gain = value


func _on_threshold_slider_value_changed(value: float) -> void:
	threshold_limit = value

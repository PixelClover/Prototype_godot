extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Переменные для обработки прыжка
var jump_buffer_frames: int = 5 # Количество кадров для буферизации прыжка (Можешь поиграться с этим)
var jump_buffer_counter: int = -1 # Счетчик для буферизации прыжка
var ledge_assistance_frames: int = 6 # Количество кадров "милосердия"
var ledge_assistance_counter: int = 0 # Счетчик для "помощи на краю" (также и с этим, чтобы понять что происходит)

func _physics_process(delta: float) -> void:
	# Добавление гравитации
	if not is_on_floor():
		velocity += get_gravity() * delta
		ledge_assistance_counter -= 1 # Уменьшаем счетчик "помощи на краю"

	# Обработка прыжка
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_buffer_counter = jump_buffer_frames
		elif ledge_assistance_counter >= 0: # Если "помощь на краю" активна
			velocity.y = JUMP_VELOCITY
			ledge_assistance_counter = 0 # Сбрасываем счетчик "помощи на краю"

	# Проверка буфера прыжка
	if jump_buffer_counter >= 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_buffer_counter -= 1

	# Счетчик буфера
	if jump_buffer_counter >= 0:
		jump_buffer_counter -= 1

	# Получение направления и обработка движения/замедления
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Проверка на "помощь на краю"
	if not is_on_floor() and ledge_assistance_counter < ledge_assistance_frames:
		ledge_assistance_counter += 1 # Увеличиваем счетчик "помощи на краю"

	move_and_slide()

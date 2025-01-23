extends CharacterBody2D

const SPEED = 100.0 				#Скорость передвижения
const JUMP_VELOCITY = -400.0		# Высота прыжка
const JUMP_BUFFER_TIME = 0.2		# Время буферизации прыжка в секундах

# Переменные
var jump_buffered: bool = false		# включатель буферизации прыжка
var jump_buffer_time: float = 0.0	# время буферизации прыжка

var ledge_assistance_frames: int = 11 # Количество кадров "милосердия" 
var ledge_assistance_counter: int = 0 # Счетчик для "помощи на краю"
var jumped_from_ledge: bool = false  # Флаг для отслеживания прыжка с края

func _physics_process(delta: float) -> void:
	# Добавление гравитации
	if not is_on_floor():
		velocity += get_gravity() * delta
		# Увеличиваем счетчик "помощи на краю", если не на земле
		handle_ledge_assistance()

	# Обработка прыжка
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Реализицая "помощи у края платформы" в обработке прыжка
		elif ledge_assistance_counter < ledge_assistance_frames and not jumped_from_ledge:
			velocity.y = JUMP_VELOCITY
			ledge_assistance_counter = 0  # Сбрасываем счетчик "помощи на краю"
			jumped_from_ledge = true
		# Реализация "буферизации прыжка" в обработке прыжка
		else:
			jump_buffered = true
			jump_buffer_time = Time.get_ticks_msec() / 1000.0

	# Сброс счетчиков, если игрок на земле
	if is_on_floor():
		if jump_buffered and (Time.get_ticks_msec() / 1000.0 - jump_buffer_time < JUMP_BUFFER_TIME):
			velocity.y = JUMP_VELOCITY
			jump_buffered = false
		ledge_assistance_counter = 0  # Сбрасываем "помощь на краю"
		jumped_from_ledge = false #сбрасываем флаг 
			
	# Получение направления и обработка движения/замедления
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Функция для обработки "помощи на краю"
func handle_ledge_assistance() -> void:
	if not is_on_floor() and ledge_assistance_counter < ledge_assistance_frames:
		ledge_assistance_counter += 1
			

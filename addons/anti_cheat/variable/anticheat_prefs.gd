extends RefCounted

class_name AntiCheatPrefs

enum AntiType{
	CHECK = 0,
	ENCRYPT = 1
}

#var aes = AESContext.new()

var objects = {}
var anit_objects = {}

var pwd:String
var hashType = AntiType.CHECK

signal onValueChanged()

static func generate_key_b() -> String:
	var crypto = Crypto.new()
	# Generamos 16 bytes aleatorios.
	# Al pasarlos a .hex_encode(), se convierten en 32 caracteres (ej: "a1b2c3...").
	# 32 caracteres en UTF-8 = exactamente 32 bytes. ¡Perfecto para AES-256!
	return crypto.generate_random_bytes(16).hex_encode()
	
static func generate_key() -> String:
	var chars = "0123456789abcdefABCDEF"
	var key = ""
	for i in range(32):
		key += chars[randi() % chars.length()]
	return key

func _init(_pwd = null, mode = AntiType.CHECK):
	hashType = mode
	# Si la contraseña es nula, generamos una aleatoria de 32 bytes (seguro para AES)
	if _pwd == null:
		pwd = generate_key()
	else:
		# SEGURIDAD: Comprobamos que la clave proporcionada tenga 16 o 32 bytes
		var byte_size = _pwd.to_utf8_buffer().size()
		if byte_size == 16 or byte_size == 32:
			pwd = _pwd
		else:
			# Si la clave es inválida (ej: "hola" que tiene 4 bytes), generamos una segura
			print("Advertencia AntiCheat: La clave proporcionada no tiene 16 o 32 bytes. Se generó una dinámica.")
			pwd = generate_key()

func get_val(key):
	if objects.has(key) && anit_objects[key]:
		return decrypt(key)
	return null

func set_val(key,value):
	objects[key] = value
	encrypt(key,value)
	
func plus(key,value):
	var temp = get_val(key)
	assert(temp is int || temp is float)			
	temp += value
	encrypt(key,temp)

func minus(key,value):
	var temp = get(key)
	assert(temp is int || temp is float)
	temp -= value
	encrypt(key,temp)

func ride(key,value):
	var temp = get_val(key)
	assert(temp is int || temp is float)
	temp *= value
	encrypt(key,temp)

func div(key,value):
	var temp = get_val(key)
	assert(temp is int || temp is float)
	temp /= value
	encrypt(key,temp)

func remove(key):
	objects.erase(key)
	anit_objects.erase(key)

func clear():
	objects.clear()
	anit_objects.clear()

func encrypt(key,value):
	anit_objects[key] = {
		"value":null,
		"type":typeof(value),
		"count":0
	}
	match hashType:
		AntiType.ENCRYPT:
			var aes = AESContext.new()
			aes.start(AESContext.MODE_ECB_ENCRYPT, pwd.to_utf8_buffer())
			var encry = str(value).to_utf8_buffer()
			anit_objects[key].count = encry.size()
			var check = checkSize(encry)
			var encrypted = aes.update(check)
			aes.finish()
			objects[key] = encrypted
		_:
			objects[key] = value
	anit_objects[key].value = str(objects[key]).md5_text()

func decrypt(key):
	var result = objects[key]
	var de_val = str(result).md5_text()
	if anit_objects[key].value != de_val:
		emit_signal("onValueChanged")
		return null
		
	match hashType:
		AntiType.ENCRYPT:
			var aes = AESContext.new()
			aes.start(AESContext.MODE_ECB_DECRYPT, pwd.to_utf8_buffer())
			var decrypted = aes.update(objects[key])
			var new_decr = decrypted.slice(0, anit_objects[key].count)
			aes.finish()
			result = new_decr.get_string_from_utf8()
	match anit_objects[key].type:
		TYPE_INT:
			return int(result)
		TYPE_FLOAT:
			return float(result)
		TYPE_STRING:
			return str(result)
		TYPE_BOOL:
			return bool(result)
		TYPE_NIL:
			return null
	return result

func checkSize(val):
	if val.size() % 16 == 0:
		return val
	else:
		for i in (16 - val.size() % 16):
			val.append(0)
		return val

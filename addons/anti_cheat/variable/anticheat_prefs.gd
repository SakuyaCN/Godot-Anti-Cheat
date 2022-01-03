extends Reference

class_name AntiCheatPrefs

enum AntiType{
	CHECK = 0,
	ENCRYPT = 1
}

var aes = AESContext.new()

var objects = {}
var anit_objects = {}

var pwd:String
var hashType = AntiType.CHECK

signal onValueChanged()

func _init(_pwd = "3C5B753FA2DFE30832D7C2255F29EAAB",mode = AntiType.CHECK):
	pwd = _pwd
	hashType = mode

func get(key):
	if objects.has(key) && anit_objects[key]:
		return decrypt(key)

func set(key,value):
	objects[key] = value
	encrypt(key,value)
	
func plus(key,value):
	var temp = get(key)
	assert(temp is int || temp is float)
	temp += value
	encrypt(key,temp)

func minus(key,value):
	var temp = get(key)
	assert(temp is int || temp is float)
	temp -= value
	encrypt(key,temp)

func ride(key,value):
	var temp = get(key)
	assert(temp is int || temp is float)
	temp *= value
	encrypt(key,temp)

func div(key,value):
	var temp = get(key)
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
			aes.start(AESContext.MODE_ECB_ENCRYPT, pwd.to_utf8())
			var encry = str(value).to_utf8()
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
	match hashType:
		AntiType.ENCRYPT:
			aes.start(AESContext.MODE_ECB_DECRYPT, pwd.to_utf8())
			var decrypted = aes.update(objects[key])
			var new_decr = decrypted.subarray(0,anit_objects[key].count-1)
			aes.finish()
			result = decrypted.get_string_from_utf8()
	match anit_objects[key].type:
		TYPE_INT:
			return int(result)
		TYPE_REAL:
			return float(result)
		TYPE_STRING:
			return str(result)
		TYPE_BOOL:
			return bool(result)
		TYPE_NIL:
			return null
	return 

func checkSize(val):
	if val.size() % 16 == 0:
		return val
	else:
		for i in (16 - val.size() % 16):
			val.append(0)
		return val

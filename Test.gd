extends Control


var anti = AntiCheatPrefs.new()

func _ready():
	anti.set("hp",100)
	anti.connect("onValueChanged",self,"_onValueChanged")
	$Label.text = "HP = %s" %anti.get("hp")

func _onValueChanged():
	$Label.text = "检测到数据被修改"

func _on_Button_pressed():
	anti.plus("hp",100)
	$Label.text = "HP = %s" %anti.get("hp")


func _on_Button2_pressed():
	print(anti.get("hp"))


func _on_Button3_pressed():
	print(anti.get("hp"))

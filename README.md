# Godot-Anti-Cheat
Godot 内存数据加密插件

使用方式：

定义变量：

var anti = AntiCheatPrefs.new()

或者：

var anti = AntiCheatPrefs.new("key or null",AntiCheatPrefs.AntiType.ENCRYPT)


说明：

AntiCheatPrefs.AntiType.ENCRYPT 直接加密数据值

AntiCheatPrefs.AntiType.CHECK 不加密值，只检测数据是否合格

设置一个变量：

anti.set("hp",100)

读取一个变量：

anti.get("hp")


运算符：（只能是float或者int类型）

anti.plus("hp",100) 加法

anti.minus("hp",100) 减法

anti.ride("hp",100) 乘法

anti.div("hp",100) 除法


信号：

anti.connect("onValueChanged",self,"_onValueChanged")

当内存数据检测到异常时会触发

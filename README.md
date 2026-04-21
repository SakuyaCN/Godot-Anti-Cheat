# Godot-Anti-Cheat
Godot Memory Data Encryption Plugin - 内存数据加密插件

Usage - 使用方式：

Define a variable - 定义变量：

var anti = AntiCheatPrefs.new()

or - 或者：

var anti = AntiCheatPrefs.new("key",AntiCheatPrefs.AntiType.ENCRYPT)

or

var anti = AntiCheatPrefs.new(null, AntiCheatPrefs.AntiType.ENCRYPT)


Explanation: - 说明：

AntiCheatPrefs.AntiType.ENCRYPT Directly encrypt the data value. - 直接加密数据值

AntiCheatPrefs.AntiType.CHECK Do not encrypt the value, only check if the data is valid. - 不加密值，只检测数据是否合格

Set a variable: - 设置一个变量：

anti.set_val("hp",100)

Read a variable: - 读取一个变量：

anti.get_val("hp")


Operators: (can only be of float or int type) - 运算符：（只能是float或者int类型）

anti.plus("hp",100) addition - 加法

anti.minus("hp",100) substraction - 减法

anti.ride("hp",100) multiplication - 乘法

anti.div("hp",100) division - 除法


signal - 信号：

anti.connect("onValueChanged",self,"_onValueChanged")

It will be triggered when an anomaly is detected in the memory data. - 当内存数据检测到异常时会触发

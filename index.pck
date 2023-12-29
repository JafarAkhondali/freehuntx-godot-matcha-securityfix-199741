GDPC                �	                                                                         \   res://.godot/exported/133200997/export-54c952f023ea1e258f1d375059f8166d-server_client.scn   p�      L      I3`pW���8����2    T   res://.godot/exported/133200997/export-61bb896f3c9c05f0d1e2c55a3eacd5ad-lobby.scn   �      x      ��L5'�S6fWTz�    T   res://.godot/exported/133200997/export-61e474ebecd96a8a7bfc183b8acbdb18-bobble.scn  0�      �      6�5)c?fF��M/�J�0    P   res://.godot/exported/133200997/export-6581cd44ca730c421bddc3302d6ce6cc-root.scnP�      0      ��K���˰�%��F�    T   res://.godot/exported/133200997/export-bab7f66da158eb92d4a519c9e5bf8439-player.scn  P�            ���=$f��!�=�q�s    ,   res://.godot/global_script_class_cache.cfg  ��      >      HY��s�o��Z��    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex��      �      �Yz=������������       res://.godot/uid_cache.bin  ��            L�M����2�7+�x�    $   res://addons/matcha/MatchaPeer.gd   �k            $'<����c�W&����    $   res://addons/matcha/MatchaRoom.gd   �{      !      HO�Ɇ�(��חt��        res://addons/matcha/lib/Utils.gd              �=/��������+ɨ�    ,   res://addons/matcha/lib/WebSocketClient.gd         �      4�<��G� �W=U        res://addons/matcha/nostr/Big.gd�      �K      ��'8�/�`k/�G"X�    (   res://addons/matcha/nostr/Secp256k1.gd  �[      �      @��#$!�fk�����    ,   res://addons/matcha/tracker/TrackerClient.gdP]      w      ,p����/�����        res://examples/bobble/bobble.gd `�      �      ��3�pr����K�@�@    (   res://examples/bobble/bobble.tscn.remap ��      c       f�!˵[��6m毽    ,   res://examples/bobble/components/player.gd   �      E      $}��9�K^�~�C���    4   res://examples/bobble/components/player.tscn.remap  ��      c       ͅX�j�Oc6�i�        res://examples/lobby/lobby.gd   б             ��,�H6���aqct�~    (   res://examples/lobby/lobby.tscn.remap   `�      b       ��4Br�`����8�0    0   res://examples/server_client/server_client.gd   `�            #������]Vwx�) =    8   res://examples/server_client/server_client.tscn.remap   ��      j       �m���0 BВ��(�T       res://icon.svg  ��      �      C��=U���^Qu��U3       res://icon.svg.import   ��      �       �u� ���{�O-�C       res://project.binary��      �      � ~�Xfn�ɐ�	�       res://root.gd   p�      �      �2J�<�"�[���
i�       res://root.tscn.remap   @�      a       ;�/q�;X�����=�k        # Generate an random string with a certain length
static func gen_id(len:=20, charset:="0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ") -> String:
	var word: String
	var n_char = len(charset)
	for i in range(len):
		word += charset[randi()% n_char]
	return word
         # TODO: DOCUMENT, DOCUMENT, DOCUMENT!

extends RefCounted

# Signals
signal disconnected
signal reconnecting
signal connecting
signal connected
signal message(data)

# Constants
enum Mode { BYTES, TEXT, JSON }
enum State { DISCONNECTED, CONNECTING, CONNECTED, RECONNECTING }

# Members
var _user_agent: String
var _state := State.DISCONNECTED
var _url: String
var _socket: WebSocketPeer
var _reconnect_try_counter := 0
var _options: Dictionary

# Getters
var is_connected:
	get: return _state == State.CONNECTED

# Constructor
func _init(url: String, options:={}) -> void:
	if not "mode" in options: options.mode = Mode.BYTES
	if not "reconnect_tries" in options: options.reconnect_tries = 0
	_url = url
	_options = options

	_user_agent = "Matcha/0.0.0 (%s; %s; %s) Godot/%s" % [
		OS.get_name(),
		OS.get_version(),
		Engine.get_architecture_name(),
		Engine.get_version_info().string.split(" ")[0]
	]

	Engine.get_main_loop().process_frame.connect(self._poll)
	Engine.get_main_loop().process_frame.connect(self._start, CONNECT_ONE_SHOT)

# Public methods
func send(data, mode=_options.mode) -> Error:
	if not is_connected:
		push_error("NOT_CONNECTED")
		return Error.ERR_CONNECTION_ERROR

	if mode == Mode.BYTES and typeof(data) != TYPE_PACKED_BYTE_ARRAY:
		if typeof(data) == TYPE_STRING:
			data = data.to_utf8_buffer()
		else:
			push_error("UNKOWN_TYPE")
			return Error.ERR_INVALID_DATA
	elif mode == Mode.TEXT and typeof(data) != TYPE_STRING:
		if typeof(data) == TYPE_PACKED_BYTE_ARRAY:
			data = data.get_string_from_utf8()
		else:
			push_error("UNKNOWN_TYPE")
			return Error.ERR_INVALID_DATA
	elif mode == Mode.JSON:
		data = JSON.stringify(data)
		if data == null:
			push_error("INVALID_JSON")
			return Error.ERR_INVALID_DATA

	if typeof(data) != TYPE_STRING:
		push_error("INVALID_DATA")
		return Error.ERR_INVALID_DATA

	return _socket.send_text(data)

func close(was_error=false) -> void:
	if _socket != null:
		_socket.close()
		_socket = null

	if _state == State.CONNECTING:
		_state = State.DISCONNECTED

	if _state == State.CONNECTED:
		_state = State.DISCONNECTED
		disconnected.emit()

	if was_error and _state != State.RECONNECTING and _options.reconnect_tries > 0:
		_reconnect_try_counter += 1

		if _reconnect_try_counter > _options.reconnect_tries:
			return

		_state = State.RECONNECTING
		reconnecting.emit()
		Engine.get_main_loop().create_timer(_options.reconnect_time).timeout.connect(func():
			_state = State.DISCONNECTED
			_start()
		)

# Private methods
func _start() -> void:
	if _socket != null:
		close()

	_socket = WebSocketPeer.new()

	if OS.get_name() != "Web":
		# When not in web we should use an useragent. Some servers dont accept requests without an user-agent
		_socket.handshake_headers = PackedStringArray([ "user-agent: %s" % [_user_agent] ])

	if _socket.connect_to_url(_url) != OK:
		close(true)
		return

	_state = State.CONNECTING
	connecting.emit()

func _poll() -> void:
	if _socket == null: return
	_socket.poll()

	var state = _socket.get_ready_state()
	if state == WebSocketPeer.STATE_CLOSED:
		close(true)
		return

	if state != WebSocketPeer.STATE_OPEN:
		return

	if _state != State.CONNECTED:
		_state = State.CONNECTED
		_reconnect_try_counter = 0
		connected.emit()

	while _socket.get_available_packet_count():
		_on_packet(_socket.get_packet())

func _on_packet(buffer: PackedByteArray) -> void:
	if _options.mode == Mode.BYTES:
		message.emit(buffer)
	elif _options.mode == Mode.TEXT:
		message.emit(buffer.get_string_from_utf8())
	elif _options.mode == Mode.JSON:
		var str := buffer.get_string_from_utf8()
		var data = JSON.parse_string(str)
		if data == null:
			push_error("[WebSocketClient] Invalid json: %s" % [str])
		else:
			message.emit(data)
             # WORK IN PROGRESS! NOSTR NOT IMPLEMENTED YET!

# Copied from: https://github.com/ChronoDK/GodotBigNumberClass

class_name Big
extends RefCounted
# Big number class for use in idle / incremental games and other games that needs very large numbers
# Can format large numbers using a variety of notation methods:
# AA notation like AA, AB, AC etc.
# Metric symbol notation k, m, G, T etc.
# Metric name notation kilo, mega, giga, tera etc.
# Long names like octo-vigin-tillion or millia-nongen-quin-vigin-tillion (based on work by Landon Curt Noll)
# Scientic notation like 13e37 or 42e42
# Long strings like 4200000000 or 13370000000000000000000000000000
# Please note that this class has limited precision and does not fully support negative exponents
# Integer division warnings should be disabled in Project Settings

var mantissa: float = 0.0
var exponent: int = 1

const postfixes_metric_symbol = {"0":"", "1":"k", "2":"M", "3":"G", "4":"T", "5":"P", "6":"E", "7":"Z", "8":"Y", "9":"R", "10":"Q"}
const postfixes_metric_name = {"0":"", "1":"kilo", "2":"mega", "3":"giga", "4":"tera", "5":"peta", "6":"exa", "7":"zetta", "8":"yotta", "9":"ronna", "10":"quetta"}
static var postfixes_aa = {"0":"", "1":"k", "2":"m", "3":"b", "4":"t", "5":"aa", "6":"ab", "7":"ac", "8":"ad", "9":"ae", "10":"af", "11":"ag", "12":"ah", "13":"ai", "14":"aj", "15":"ak", "16":"al", "17":"am", "18":"an", "19":"ao", "20":"ap", "21":"aq", "22":"ar", "23":"as", "24":"at", "25":"au", "26":"av", "27":"aw", "28":"ax", "29":"ay", "30":"az", "31":"ba", "32":"bb", "33":"bc", "34":"bd", "35":"be", "36":"bf", "37":"bg", "38":"bh", "39":"bi", "40":"bj", "41":"bk", "42":"bl", "43":"bm", "44":"bn", "45":"bo", "46":"bp", "47":"bq", "48":"br", "49":"bs", "50":"bt", "51":"bu", "52":"bv", "53":"bw", "54":"bx", "55":"by", "56":"bz", "57":"ca"}
const alphabet_aa: Array[String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

const latin_ones: Array[String] = ["", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "novem"]
const latin_tens: Array[String] = ["", "dec", "vigin", "trigin", "quadragin", "quinquagin", "sexagin", "septuagin", "octogin", "nonagin"]
const latin_hundreds: Array[String] = ["", "cen", "duocen", "trecen", "quadringen", "quingen", "sescen", "septingen", "octingen", "nongen"]
const latin_special: Array[String] = ["", "mi", "bi", "tri", "quadri", "quin", "sex", "sept", "oct", "non"]

static var other = {"dynamic_decimals":true, "dynamic_numbers":4, "small_decimals":2, "thousand_decimals":2, "big_decimals":2, "scientific_decimals": 2, "logarithmic_decimals":2, "thousand_separator":".", "decimal_separator":",", "postfix_separator":"", "reading_separator":"", "thousand_name":"thousand"}

const MAX_MANTISSA = 1209600.0
const MANTISSA_PRECISSION = 0.0000001

const MIN_INTEGER: int = -9223372036854775807
const MAX_INTEGER: int = 9223372036854775806

func _init(m, e := 0):
	if m is PackedByteArray:
		mantissa = 0
		exponent = 0
		calculate(self)
		print(pow(16, 2))

		for i in range(m.size()):
			i = m.size() - 1 - i
			var byte = m[i]
			plus(Big.new(byte).multiply(pow(16, i*2)))
# 0xFFFFFF === (255*Math.pow(16, 0)) + (255*Math.pow(16, 2)) + (255*Math.pow(16, 4))
			#plus(Big.new(byte).multiply(i*))
			#var byte = m[i]
			#plus(Big.new(byte, 10))
		return

	if m is String:
		var scientific = m.split("e")
		mantissa = float(scientific[0])
		if scientific.size() > 1:
			exponent = int(scientific[1])
		else:
			exponent = 0
	elif m is Big:
		mantissa = m.mantissa
		exponent = m.exponent
	else:
		_sizeCheck(m)
		mantissa = m
		exponent = e
	calculate(self)
	pass

func _sizeCheck(m):
	if m > MAX_MANTISSA:
		printerr("BIG ERROR: MANTISSA TOO LARGE, PLEASE USE EXPONENT OR SCIENTIFIC NOTATION")


static func _typeCheck(n):
	if typeof(n) == TYPE_INT or typeof(n) == TYPE_FLOAT:
		return {"mantissa":float(n), "exponent":int(0)}
	elif typeof(n) == TYPE_STRING:
		var split = n.split("e")
		return {"mantissa":float(split[0]), "exponent":int(0 if split.size() == 1 else split[1])}
	else:
		return n


func plus(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		mantissa += scaled_mantissa
	elif isLessThan(n):
		mantissa = n.mantissa #when difference between values is big, throw away small number
		exponent = n.exponent
	calculate(self)
	return self


func minus(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var exp_diff = n.exponent - exponent #abs?
	if exp_diff < 248:
		var scaled_mantissa = n.mantissa * pow(10, exp_diff)
		mantissa -= scaled_mantissa
	elif isLessThan(n):
		mantissa = -MANTISSA_PRECISSION
		exponent = n.exponent
	calculate(self)
	return self


func multiply(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var new_exponent = n.exponent + exponent
	var new_mantissa = n.mantissa * mantissa
	while new_mantissa >= 10.0:
		new_mantissa /= 10.0
		new_exponent += 1
	mantissa = new_mantissa
	exponent = new_exponent
	calculate(self)
	return self


func divide(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	if n.mantissa == 0:
		printerr("BIG ERROR: DIVIDE BY ZERO OR LESS THAN " + str(MANTISSA_PRECISSION))
		return self
	var new_exponent = exponent - n.exponent
	var new_mantissa = mantissa / n.mantissa
	while new_mantissa < 1.0 and new_mantissa > 0.0:
		new_mantissa *= 10.0
		new_exponent -= 1
	mantissa = new_mantissa
	exponent = new_exponent
	calculate(self)
	return self


func powerInt(n: int):
	if n < 0:
		printerr("BIG ERROR: NEGATIVE EXPONENTS NOT SUPPORTED!")
		mantissa = 1.0
		exponent = 0
		return self
	if n == 0:
		mantissa = 1.0
		exponent = 0
		return self

	var y_mantissa = 1
	var y_exponent = 0

	while n > 1:
		calculate(self)
		if n % 2 == 0: #n is even
			exponent = exponent + exponent
			mantissa = mantissa * mantissa
			n = n / 2  # warning-ignore:integer_division
		else:
			y_mantissa = mantissa * y_mantissa
			y_exponent = exponent + y_exponent
			exponent = exponent + exponent
			mantissa = mantissa * mantissa
			n = (n-1) / 2  # warning-ignore:integer_division

	exponent = y_exponent + exponent
	mantissa = y_mantissa * mantissa
	calculate(self)
	return self


func power(n: float) -> Big:
	if mantissa == 0:
		return self

	# fast track
	var temp:float = exponent * n
	if round(n) == n and temp < MAX_INTEGER and temp > MIN_INTEGER and temp != INF and temp != -INF:
		var newMantissa = pow(mantissa, n)
		if newMantissa != INF and newMantissa != -INF:
			mantissa = newMantissa
			exponent = int(temp)
			calculate(self)
			return self

	# a bit slower, still supports floats
	var newExponent:int = int(temp)
	var residue:float = temp - newExponent
	var newMantissa = pow(10, n * log10(mantissa) + residue)
	if newMantissa != INF and newMantissa != -INF:
		mantissa = newMantissa
		exponent = newExponent
		calculate(self)
		return self

	if round(n) != n:
		printerr("BIG ERROR: POWER FUNCTION DOES NOT SUPPORT LARGE FLOATS, USE INTEGERS!")

	return powerInt(int(n))


func squareRoot() -> Big:
	if exponent % 2 == 0:
		mantissa = sqrt(mantissa)
		exponent = exponent/2
	else:
		mantissa = sqrt(mantissa*10)
		exponent = (exponent-1)/2
	calculate(self)
	return self


func modulo(n) -> Big:
	n = _typeCheck(n)
	_sizeCheck(n.mantissa)
	var big = {"mantissa":mantissa, "exponent":exponent}
	divide(n)
	roundDown()
	multiply(n)
	minus(big)
	mantissa = abs(mantissa)
	return self


func calculate(big):
	if big.mantissa >= 10.0 or big.mantissa < 1.0:
		var diff = int(floor(log10(big.mantissa)))
		if diff > -10 and diff < 248:
			var div = pow(10, diff)
			if div > MANTISSA_PRECISSION:
				big.mantissa /= div
				big.exponent += diff
	while big.exponent < 0:
		big.mantissa *= 0.1
		big.exponent += 1
	while big.mantissa >= 10.0:
		big.mantissa *= 0.1
		big.exponent += 1
	if big.mantissa == 0:
		big.mantissa = 0.0
		big.exponent = 0
	big.mantissa = snapped(big.mantissa, MANTISSA_PRECISSION)
	pass


func isEqualTo(n) -> bool:
	n = _typeCheck(n)
	calculate(n)
	return n.exponent == exponent and is_equal_approx(n.mantissa, mantissa)


func isLargerThan(n) -> bool:
	return !isLessThanOrEqualTo(n)


func isLargerThanOrEqualTo(n) -> bool:
	return !isLessThan(n)


func isLessThan(n) -> bool:
	n = _typeCheck(n)
	calculate(n)
	if mantissa == 0 and (n.mantissa > MANTISSA_PRECISSION or mantissa < MANTISSA_PRECISSION) and n.mantissa == 0:
		return false
	if exponent < n.exponent:
		return true
	elif exponent == n.exponent:
		if mantissa < n.mantissa:
			return true
		else:
			return false
	else:
		return false


func isLessThanOrEqualTo(n) -> bool:
	n = _typeCheck(n)
	calculate(n)
	if isLessThan(n):
		return true
	if n.exponent == exponent and is_equal_approx(n.mantissa, mantissa):
		return true
	return false


static func minValue(m, n) -> Big:
	m = _typeCheck(m)
	if m.isLessThan(n):
		return m
	else:
		return n


static func maxValue(m, n) -> Big:
	m = _typeCheck(m)
	if m.isLargerThan(n):
		return m
	else:
		return n


static func absValue(n) -> Big:
	n.mantissa = abs(n.mantissa)
	return n


func roundDown() -> Big:
	if exponent == 0:
		mantissa = floor(mantissa)
		return self
	else:
		var precision = 1.0
		for i in range(min(8, exponent)):
			precision /= 10.0
		if precision < MANTISSA_PRECISSION:
			precision = MANTISSA_PRECISSION
		mantissa = snapped(mantissa, precision)
		return self


func log10(x):
	return log(x) * 0.4342944819032518


func absLog10():
	return exponent + log10(abs(mantissa))


func ln():
	return 2.302585092994045 * logN(10)


func logN(base):
	return (2.302585092994046 / log(base)) * (exponent + log10(mantissa))


func pow10(value:int):
	mantissa = pow(10, value % 1)
	exponent = int(value)


static func setThousandName(name):
	other.thousand_name = name
	pass


static func setThousandSeparator(separator):
	other.thousand_separator = separator
	pass


static func setDecimalSeparator(separator):
	other.decimal_separator = separator
	pass


static func setPostfixSeparator(separator):
	other.postfix_separator = separator
	pass


static func setReadingSeparator(separator):
	other.reading_separator = separator
	pass


static func setDynamicDecimals(d):
	other.dynamic_decimals = bool(d)
	pass


static func setDynamicNumbers(d):
	other.dynamic_numbers = int(d)
	pass


static func setSmallDecimals(d):
	other.small_decimals = int(d)
	pass


static func setThousandDecimals(d):
	other.thousand_decimals = int(d)
	pass


static func setBigDecimals(d):
	other.big_decimals = int(d)
	pass


static func setScientificDecimals(d):
	other.scientific_decimals = int(d)
	pass


static func setLogarithmicDecimals(d):
	other.logarithmic_decimals = int(d)
	pass


func toString() -> String:
	var mantissa_decimals = 0
	if str(mantissa).find(".") >= 0:
		mantissa_decimals = str(mantissa).split(".")[1].length()
	if mantissa_decimals > exponent:
		if exponent < 248:
			return str(mantissa * pow(10, exponent))
		else:
			return toPlainScientific()
	else:
		var mantissa_string = str(mantissa).replace(".", "")
		for _i in range(exponent-mantissa_decimals):
			mantissa_string += "0"
		return mantissa_string


func toPlainScientific():
	return str(mantissa) + "e" + str(exponent)


func toScientific(no_decimals_on_small_values = false, force_decimals=false):
	if exponent < 3:
		var decimal_increments:float = 1 / (pow(10, other.scientific_decimals) / 10)
		var value = str(snappedf(mantissa * pow(10, exponent), decimal_increments))
		var split = value.split(".")
		if no_decimals_on_small_values:
			return split[0]
		if split.size() > 1:
			for i in range(other.logarithmic_decimals):
				if split[1].length() < other.scientific_decimals:
					split[1] += "0"
			return split[0] + other.decimal_separator + split[1].substr(0,min(other.scientific_decimals, other.dynamic_numbers - split[0].length() if other.dynamic_decimals else other.scientific_decimals))
		else:
			return value
	else:
		var split = str(mantissa).split(".")
		if split.size() == 1:
			split.append("")
		if force_decimals:
			for i in range(other.scientific_decimals):
				if split[1].length() < other.scientific_decimals:
					split[1] += "0"
		return split[0] + other.decimal_separator + split[1].substr(0,min(other.scientific_decimals, other.dynamic_numbers-1 - str(exponent).length() if other.dynamic_decimals else other.scientific_decimals)) + "e" + str(exponent)


func toLogarithmic(no_decimals_on_small_values = false) -> String:
	var decimal_increments:float = 1 / (pow(10, other.logarithmic_decimals) / 10)
	if exponent < 3:
		var value = str(snappedf(mantissa * pow(10, exponent), decimal_increments))
		var split = value.split(".")
		if no_decimals_on_small_values:
			return split[0]
		if split.size() > 1:
			for i in range(other.logarithmic_decimals):
				if split[1].length() < other.logarithmic_decimals:
					split[1] += "0"
			return split[0] + other.decimal_separator + split[1].substr(0,min(other.logarithmic_decimals, other.dynamic_numbers - split[0].length() if other.dynamic_decimals else other.logarithmic_decimals))
		else:
			return value
	var dec = str(snappedf(abs(log(mantissa) / log(10) * 10), decimal_increments))
	dec = dec.replace(".", "")
	for i in range(other.logarithmic_decimals):
		if dec.length() < other.logarithmic_decimals:
			dec += "0"
	var formated_exponent = formatExponent(exponent)
	dec = dec.substr(0, min(other.logarithmic_decimals, other.dynamic_numbers - formated_exponent.length() if other.dynamic_decimals else other.logarithmic_decimals))
	return "e" + formated_exponent + other.decimal_separator + dec


func formatExponent(value) -> String:
	if value < 1000:
		return str(value)
	var string = str(value)
	var mod = string.length() % 3
	var output = ""
	for i in range(0, string.length()):
		if i != 0 and i % 3 == mod:
			output += other.thousand_separator
		output += string[i]
	return output


func toFloat() -> float:
	return snappedf(float(str(mantissa) + "e" + str(exponent)),0.01)


func toPrefix(no_decimals_on_small_values = false, use_thousand_symbol=true, force_decimals=true, scientic_prefix=false) -> String:
	var number:float = mantissa
	if not scientic_prefix:
		var hundreds = 1
		for _i in range(exponent % 3):
			hundreds *= 10
		number *= hundreds

	var split = str(number).split(".")
	if split.size() == 1:
		split.append("")
	if force_decimals:
		var max_decimals = max(max(other.small_decimals, other.thousand_decimals), other.big_decimals)
		for i in range(max_decimals):
			if split[1].length() < max_decimals:
				split[1] += "0"
	
	if no_decimals_on_small_values and exponent < 3:
		return split[0]
	elif exponent < 3:
		if other.small_decimals == 0 or split[1] == "":
			return split[0]
		else:
			return split[0] + other.decimal_separator + split[1].substr(0,min(other.small_decimals, other.dynamic_numbers - split[0].length() if other.dynamic_decimals else other.small_decimals))
	elif exponent < 6:
		if other.thousand_decimals == 0 or (split[1] == "" and use_thousand_symbol):
			return split[0]
		else:
			if use_thousand_symbol: # when the prefix is supposed to be using with a K for thousand
				for i in range(3):
					if split[1].length() < 3:
						split[1] += "0"
				return split[0] + other.decimal_separator + split[1].substr(0,min(3, other.dynamic_numbers - split[0].length() if other.dynamic_decimals else 3))
			else:
				for i in range(3):
					if split[1].length() < 3:
						split[1] += "0"
				return split[0] + other.thousand_separator + split[1].substr(0,3)
	else:
		if other.big_decimals == 0 or split[1] == "":
			return split[0]
		else:
			return split[0] + other.decimal_separator + split[1].substr(0,min(other.big_decimals, other.dynamic_numbers - split[0].length() if other.dynamic_decimals else other.big_decimals))


func _latinPower(european_system) -> int:
	if european_system:
		return int(exponent / 3) / 2
	return int(exponent / 3) - 1


func _latinPrefix(european_system) -> String:
	var ones = _latinPower(european_system) % 10
	var tens = int(_latinPower(european_system) / 10) % 10
	var hundreds = int(_latinPower(european_system) / 100) % 10
	var millias = int(_latinPower(european_system) / 1000) % 10

	var prefix = ""
	if _latinPower(european_system) < 10:
		prefix = latin_special[ones] + other.reading_separator + latin_tens[tens] + other.reading_separator + latin_hundreds[hundreds]
	else:
		prefix = latin_hundreds[hundreds] + other.reading_separator + latin_ones[ones] + other.reading_separator + latin_tens[tens]

	for _i in range(millias):
		prefix = "millia" + other.reading_separator + prefix

	return prefix.lstrip(other.reading_separator).rstrip(other.reading_separator)


func _tillionOrIllion(european_system) -> String:
	if exponent < 6:
		return ""
	var powerKilo = _latinPower(european_system) % 1000
	if powerKilo < 5 and powerKilo > 0 and _latinPower(european_system) < 1000:
		return ""
	if powerKilo >= 7 and powerKilo <= 10 or int(powerKilo / 10) % 10 == 1:
		return "i"
	return "ti"


func _llionOrLliard(european_system) -> String:
	if exponent < 6:
		return ""
	if int(exponent/3) % 2 == 1 and european_system:
		return "lliard"
	return "llion"


func getLongName(european_system = false, prefix="") -> String:
	if exponent < 6:
		return ""
	else:
		return prefix + _latinPrefix(european_system) + other.reading_separator + _tillionOrIllion(european_system) + _llionOrLliard(european_system)


func toAmericanName(no_decimals_on_small_values = false) -> String:
	return toLongName(no_decimals_on_small_values, false)


func toEuropeanName(no_decimals_on_small_values = false) -> String:
	return toLongName(no_decimals_on_small_values, true)


func toLongName(no_decimals_on_small_values = false, european_system = false) -> String:
	if exponent < 6:
		if exponent > 2:
			return toPrefix(no_decimals_on_small_values) + other.postfix_separator + other.thousand_name
		else:
			return toPrefix(no_decimals_on_small_values)

	var postfix = _latinPrefix(european_system) + other.reading_separator + _tillionOrIllion(european_system) + _llionOrLliard(european_system)

	return toPrefix(no_decimals_on_small_values) + other.postfix_separator + postfix


func toMetricSymbol(no_decimals_on_small_values = false) -> String:
	var target = int(exponent / 3)

	if not postfixes_metric_symbol.has(str(target)):
		return toScientific()
	else:
		return toPrefix(no_decimals_on_small_values) + other.postfix_separator + postfixes_metric_symbol[str(target)]


func toMetricName(no_decimals_on_small_values = false) -> String:
	var target = int(exponent / 3)

	if not postfixes_metric_name.has(str(target)):
		return toScientific()
	else:
		return toPrefix(no_decimals_on_small_values) + other.postfix_separator + postfixes_metric_name[str(target)]


func toAA(no_decimals_on_small_values = false, use_thousand_symbol = true, force_decimals=false) -> String:
	var target:int = int(exponent / 3)
	var aa_index:String = str(target)
	var postfix:String = ""

	if not postfixes_aa.has(aa_index):
		var offset:int = target + 22
		var base:int = alphabet_aa.size()
		while offset > 0:
			offset -= 1
			var digit:int = offset % base
			postfix = alphabet_aa[digit] + postfix
			offset /= base
		postfixes_aa[aa_index] = postfix
	else:
		postfix = postfixes_aa[aa_index]

	if not use_thousand_symbol and target == 1:
		postfix = ""

	var prefix = toPrefix(no_decimals_on_small_values, use_thousand_symbol, force_decimals)

	return prefix + other.postfix_separator + postfix
             # WORK IN PROGRESS! NOSTR NOT IMPLEMENTED YET!

# Ported from: https://github.com/lionello/secp256k1-js

class_name Secp256k1 extends RefCounted

func uint256(x, base:=-1):
	if base != -1:
		push_error("Base not implemented!")
		return

	return Big.new(x)

func _init():
	print(uint256(7).toString())
	print(uint256("79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798".hex_decode()).toString())
       # The TrackerClient is a simple implementation of a WebTorrent Tracker Client
# Learn more about it here (js): https://github.com/webtorrent/bittorrent-tracker
# TODO: DOCUMENT, DOCUMENT, DOCUMENT!

extends RefCounted
const Utils := preload("../lib/Utils.gd")
const WebSocketClient := preload("../lib/WebSocketClient.gd")

# Classes
class Response:
	var type: String # The type of the response ("offer" or "answer")
	var info_hash: String # The info_hash which the repsonse belongs to
	var peer_id: String # The peer_id of the other peer (who've sent it)
	var offer_id: String # The offer_id that this offer/answer belongs to
	var sdp: String # The sdp (webrtc session description) of the other peer

# Signals
signal connected # Emitted when we connected to the tracker
signal disconnected # Emitted when we disconnected from the tracker
signal reconnecting # Emitted when we are reconnecting to the tracker (after unexpected disconnect)
signal failure(reason: String) # Emitted when the tracker did not like something
signal got_offer(offer: Response) # Emitted when we got an offer
signal got_answer(answer: Response) # Emitted when we got an answer

# Members
var _socket: WebSocketClient # An internal reference to the websocket client
var _peer_id: String # Our peer_id that is used to identify us
var _tracker_url: String # The tracker we are connected to

# Getters
var is_connected:
	get: return _socket != null and _socket.is_connected
var tracker_url:
	get: return _tracker_url
var peer_id:
	get: return _peer_id

# Constructor
func _init(tracker_url: String, peer_id:=Utils.gen_id()) -> void:
	_tracker_url = tracker_url
	_peer_id = peer_id
	
	_socket = WebSocketClient.new(_tracker_url, {
		"mode": WebSocketClient.Mode.JSON,
		"reconnect_time": 3,
		"reconnect_tries": 3
	})
	_socket.connected.connect(self._on_tracker_connected)
	_socket.disconnected.connect(self._on_tracker_disconnected)
	_socket.reconnecting.connect(self._on_tracker_reconnecting)
	_socket.message.connect(self._on_tracker_message)

# Public methods
# This method is used to share our answer to an offer
func answer(info_hash: String, to_peer_id: String, offer_id: String, sdp: String) -> void:
	if not is_connected:
		connected.connect(answer.bind(info_hash, to_peer_id, offer_id, sdp), CONNECT_ONE_SHOT)
		return
	_socket.send({
		"action": "announce",
		"info_hash": info_hash,
		"peer_id": _peer_id,
		"to_peer_id": to_peer_id,
		"offer_id": offer_id,
		"answer": {
			"type": "answer",
			"sdp": sdp
		}
	})

# This method is used to
func announce(info_hash: String, offers: Array) -> void:
	if not is_connected:
		connected.connect(announce.bind(info_hash, offers), CONNECT_ONE_SHOT)
		return

	_socket.send({
		"action": "announce",
		"info_hash": info_hash,
		"peer_id": _peer_id,
		"numwant": offers.size(),
		"offers": offers
	})

# Private methods
func _on_tracker_connected() -> void:
	connected.emit()

func _on_tracker_disconnected() -> void:
	disconnected.emit()

func _on_tracker_reconnecting() -> void:
	reconnecting.emit()

func _on_tracker_message(data) -> void:
	if not typeof(data) == TYPE_DICTIONARY: return
	if "failure reason" in data:
		failure.emit(data["failure reason"])
		return
	if not "action" in data or data.action != "announce": return
	if not "info_hash" in data: return
	if "peer_id" in data and "offer_id" in data:
		var response := Response.new()
		response.info_hash = data.info_hash
		response.peer_id = data.peer_id
		response.offer_id = data.offer_id

		if "offer" in data:
			response.type = "offer"
			response.sdp = data.offer.sdp
			got_offer.emit(response)
		if "answer" in data:
			response.type = "answer"
			response.sdp = data.answer.sdp
			got_answer.emit(response)
         # TODO: DOCUMENT, DOCUMENT, DOCUMENT!

class_name MatchaPeer extends WebRTCPeerConnection
const Utils := preload("./lib/Utils.gd")

enum State { NEW, GATHERING, CONNECTING, CONNECTED, CLOSED }

# Signals
signal connecting
signal connected
signal disconnected
signal closed
signal connecting_failed
signal sdp_created(sdp: String)

# Members
var _announced := false
var _peer_id: String
var _offer_id: String
var _state := State.NEW
var _answered := false
var _type: String
var _local_sdp: String
var _remote_sdp: String

var is_connected:
	get: return _state == State.CONNECTED
var type:
	get: return _type
var offer_id:
	get: return _offer_id
var gathered:
	get: return _state > State.GATHERING
var announced:
	get: return _announced
var answered:
	get: return _answered
var local_sdp:
	get: return _local_sdp
var peer_id:
	get: return _peer_id

# Static methods
static func create_offer_peer(offer_id := Utils.gen_id()) -> MatchaPeer:
	return MatchaPeer.new("offer", offer_id)

static func create_answer_peer(offer_id: String, remote_sdp: String) -> MatchaPeer:
	return MatchaPeer.new("answer", offer_id, remote_sdp)

# Constructor
func _init(type: String, offer_id: String, remote_sdp=""):
	_type = type
	_offer_id = offer_id
	_remote_sdp = remote_sdp

	session_description_created.connect(self._on_session_description_created)
	ice_candidate_created.connect(self._on_ice_candidate_created)

	var err := initialize({"iceServers":[{"urls":["stun:stun.l.google.com:19302"]}]})
	if err != OK:
		push_error("Initializing failed")
		_state = State.CLOSED

# Public methods
func start() -> Error:
	if _state != State.NEW:
		push_error("Peer state is not new")
		return Error.ERR_ALREADY_IN_USE

	_state = State.GATHERING

	if _type == "offer":
		var err := create_offer()
		if err != OK:
			push_error("Creating offer failed")
			return err
	elif _type == "answer":
		if _remote_sdp == "":
			push_error("Missing sdp")
			return Error.ERR_INVALID_DATA

		var err := set_remote_description("offer", _remote_sdp)
		if err != OK:
			push_error("Creating answer failed")
			return err
	else:
		push_error("Unknown type: ", _type)
		return Error.ERR_INVALID_DATA

	Engine.get_main_loop().process_frame.connect(self.__poll) # Start the poll loop
	return Error.OK

func set_peer_id(new_peer_id: String) -> void:
	_peer_id = new_peer_id

func set_offer_id(new_offer_id: String) -> void:
	_offer_id = new_offer_id

func set_answer(remote_sdp: String) -> Error:
	if _type != "offer":
		push_error("The peer is not an offer")
		return Error.ERR_INVALID_DATA
	if _answered:
		push_error("The offer was already answered")
		return Error.ERR_ALREADY_IN_USE

	_answered = true
	_remote_sdp = remote_sdp
	return set_remote_description("answer", remote_sdp)

func mark_as_announced() -> Error:
	if _announced:
		push_error("The offer was already answered")
		return Error.ERR_ALREADY_IN_USE
		
	_announced = true
	return Error.OK

# Private methods
func __poll():
	if _state == State.NEW or _state == State.CLOSED: return
	poll()

	if _state == State.GATHERING:
		var gathering_state := get_gathering_state()
		if gathering_state != WebRTCPeerConnection.GATHERING_STATE_COMPLETE:
			return

		_state = State.CONNECTING
		sdp_created.emit(_local_sdp)
		connecting.emit()

	var connection_state := get_connection_state()
	if _state == State.CONNECTING:
		if connection_state == WebRTCPeerConnection.STATE_CONNECTING:
			return
		if connection_state != WebRTCPeerConnection.STATE_CONNECTED:
			__close()
			return

		_state = State.CONNECTED
		connected.emit()

	if _state == State.CONNECTED:
		if connection_state != WebRTCPeerConnection.STATE_CONNECTED:
			__close()
			return

func __close():
	if _state == State.CLOSED:
		return

	close()

	if _state == State.CONNECTING:
		connecting_failed.emit()
	elif _state == State.CONNECTED:
		disconnected.emit()

	_state = State.CLOSED
	closed.emit()

# Callbacks
func _on_session_description_created(type: String, sdp: String):
	_local_sdp = sdp
	set_local_description(type, sdp)

func _on_ice_candidate_created(media: String, index: int, name: String):
	_local_sdp += "a=%s\r\n" % [name]
               # TODO: DOCUMENT, DOCUMENT, DOCUMENT!

class_name MatchaRoom extends WebRTCMultiplayerPeer
const Utils := preload("./lib/Utils.gd")
const TrackerClient := preload("./tracker/TrackerClient.gd")
const MatchaPeer := preload("./MatchaPeer.gd")

# Constants
enum State { NEW, STARTED }

# Signals
signal peer_joined(rpc_id: int, peer: MatchaPeer) # Emitted when a peer joined the room
signal peer_left(rpc_id: int, peer: MatchaPeer) # Emitted when a peer left the room

# Members
var _state := State.NEW # Internal state
var _tracker_urls := [] # A list of tracker urls
var _tracker_clients: Array[TrackerClient] = [] # A list of tracker clients we use to share/get offers/answers
var _room_id: String # An unique identifier
var _peer_id := Utils.gen_id()
var _type: String
var _offer_timeout := 30
var _pool_size := 10
var _connected_peers = {}

# Getters
var rpc_id:
	get: return get_unique_id()
var peer_id:
	get: return _peer_id
var type:
	get: return _type
var room_id:
	get: return _room_id
var _peers:
	get: return get_peers().values().map(func(v): return v.connection)

# Static methods
static func create_mesh_room(options:={}) -> MatchaRoom:
	options.type = "mesh"
	return MatchaRoom.new(options)

static func create_server_room(options:={}) -> MatchaRoom:
	options.type = "server"
	return MatchaRoom.new(options)

static func create_client_room(room_id: String, options:={}) -> MatchaRoom:
	options.type = "client"
	options.room_id = room_id
	return MatchaRoom.new(options)

# Constructor
func _init(options:={}):
	if not "pool_size" in options: options.pool_size = _pool_size
	if not "offer_timeout" in options: options.offer_timeout = _offer_timeout
	if not "identifier" in options: options.identifier = "com.matcha.default"
	if not "tracker_urls" in options: options.tracker_urls = ["wss://tracker.webtorrent.dev"]
	if not "room_id" in options: options.room_id = options.identifier.sha1_text().substr(0, 20)
	if not "type" in options: options.type = "mesh"
	if not "autostart" in options: options.autostart = true
	_tracker_urls = options.tracker_urls
	_pool_size = options.pool_size
	_offer_timeout = options.offer_timeout
	_room_id = options.room_id
	_type = options.type

	peer_connected.connect(self._on_peer_connected)
	peer_disconnected.connect(self._on_peer_disconnected)

	if options.autostart:
		start.call()

# Public methods
func start() -> Error:
	if _state != State.NEW:
		push_error("Already started")
		return Error.ERR_ALREADY_IN_USE

	_state = State.STARTED

	if _type == "mesh":
		var err := create_mesh(generate_unique_id())
		if err != OK:
			push_error("Creating mesh failed")
			return err
	elif _type == "client":
		var err := create_client(generate_unique_id())
		if err != OK:
			push_error("Creating client failed")
			return err
	elif _type == "server":
		_room_id = _peer_id # Our room_id should be our peer_id to identify ourself as the server
		var err := create_server()
		if err != OK:
			push_error("Creating server failed")
			return err
	else:
		push_error("Invalid type")
		return Error.ERR_INVALID_DATA

	# Create the tracker_clients based on the urls
	for tracker_url in _tracker_urls:
		var tracker_client := TrackerClient.new(tracker_url, _peer_id)
		tracker_client.got_offer.connect(self._on_got_offer.bind(tracker_client))
		tracker_client.got_answer.connect(self._on_got_answer.bind(tracker_client))
		tracker_client.failure.connect(self._on_failure.bind(tracker_client))
		_tracker_clients.append(tracker_client)

	Engine.get_main_loop().process_frame.connect(self.__poll)
	return Error.OK

func find_peers(filter:={}) -> Array[MatchaPeer]:
	var result: Array[MatchaPeer] = []
	for peer in _peers:
		var matched := true
		for key in filter:
			if not key in peer or peer[key] != filter[key]:
				matched = false
				break
		if matched:
			result.append(peer)
	return result

func find_peer(filter:={}, allow_multiple_results:=false) -> MatchaPeer:
	var matches := find_peers(filter)
	if not allow_multiple_results and matches.size() > 1: return null
	if matches.size() == 0: return null
	return matches[0]

# Private methods
func __poll():
	poll()
	_create_offers()
	_handle_offers_announcment()

func _remove_unanswered_offer(offer_id: String) -> void:
	var offer := find_peer({ "answered": false, "offer_id": offer_id })
	if offer != null:
		offer.close()

func _create_offer() -> void:
	if _type == "client" and has_peer(1): return # We already created the host offer. So lets ignore the offer creating

	var offer_peer := MatchaPeer.create_offer_peer()
	var offer_rpc_id := 1 if _type == "client" else generate_unique_id()
	add_peer(offer_peer, offer_rpc_id)

	if offer_peer.start() == OK:
		# Cleanup when the offer was not answered for long time
		Engine.get_main_loop().create_timer(_offer_timeout).timeout.connect(self._remove_unanswered_offer.bind(offer_peer.offer_id))
	else:
		remove_peer(offer_rpc_id)

func _create_offers() -> void:
	var unanswered_offers := find_peers({ "type": "offer", "answered": false })
	if unanswered_offers.size() > 0: return # There are ongoing offers. Dont refresh the pool.
	if _type == "client" and has_peer(1): return # If we are already connected in client mode dont create further offers

	# Create as many offers as the pool_size
	for i in range(_pool_size):
		_create_offer()

func _handle_offers_announcment():
	var unannounced_offers := find_peers({ "type": "offer", "announced": false })
	if unannounced_offers.size() == 0: return # There are no offers to announce

	var announce_offers: Array = [] # The array we need for the tracker offer announcements
	for offer_peer: MatchaPeer in unannounced_offers:
		if not offer_peer.gathered: return # If we have ungathered offers we are not ready yet to announce.

		if _type == "client":
			# As client lets announce the host peer multiple times. Since we cannot have multiple peers with id 1 setup
			if unannounced_offers.size() != 1:
				push_error("In client mode you should have just 1 offer")
				return
			for i in range(_pool_size):
				announce_offers.append({ "offer_id": Utils.gen_id(), "offer": { "type": "offer", "sdp": offer_peer.local_sdp } })
		else:
			announce_offers.append({ "offer_id": offer_peer.offer_id, "offer": { "type": "offer", "sdp": offer_peer.local_sdp } })

	for offer_peer: MatchaPeer in unannounced_offers:
		offer_peer.mark_as_announced()

	for tracker_client in _tracker_clients: # Announce the offers via every tracker
		tracker_client.announce(_room_id, announce_offers)

func _send_answer_sdp(answer_sdp: String, peer: MatchaPeer, tracker_client: TrackerClient):
	tracker_client.answer(_room_id, peer.peer_id, peer.offer_id, answer_sdp)

func _on_got_offer(offer: TrackerClient.Response, tracker_client: TrackerClient) -> void:
	if offer.info_hash != _room_id: return
	if find_peer({ "peer_id": offer.peer_id }) != null: return # Ignore if the peer is already known
	if _type == "client" and offer.peer_id != room_id: return # Ignore offers from others than host (in client mode)

	var answer_peer := MatchaPeer.create_answer_peer(offer.offer_id, offer.sdp)
	var answer_rpc_id := 1 if _type == "client" else generate_unique_id()
	answer_peer.set_peer_id(offer.peer_id)

	answer_peer.sdp_created.connect(self._send_answer_sdp.bind(answer_peer, tracker_client))
	add_peer(answer_peer, answer_rpc_id)

	if answer_peer.start() != OK:
		remove_peer(answer_rpc_id)

func _on_got_answer(answer: TrackerClient.Response, tracker_client: TrackerClient) -> void:
	if answer.info_hash != _room_id: return
	if _type == "client" and answer.peer_id != room_id: return # As client we just accept answers from the host

	var offer_peer: MatchaPeer
	if _type == "client":
		if has_peer(1):
			offer_peer = get_peer(1).connection
			offer_peer.set_offer_id(answer.offer_id) # Fix the offer_id since we gave the server alot of offers to choose from
	else:
		offer_peer = find_peer({ "offer_id": answer.offer_id })
	if offer_peer == null: return # Ignore if we dont know that offer

	offer_peer.set_peer_id(answer.peer_id)
	offer_peer.set_answer(answer.sdp)

func _on_failure(reason: String, tracker_client: TrackerClient) -> void:
	print("Tracker failure: ", reason, ", Tracker: ", tracker_client.tracker_url)

func _on_peer_connected(id: int):
	var peer: MatchaPeer = get_peer(id).connection
	_connected_peers[id] = peer
	peer_joined.emit(id, peer)

func _on_peer_disconnected(id: int):
	var peer: MatchaPeer = _connected_peers[id]
	_connected_peers.erase(id)
	peer_left.emit(id, peer)
          extends CharacterBody2D

const SPEED = 300.0
var chat_message_time: float

func set_message(message: String) -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id(): return
	$Label.text = message
	chat_message_time = Time.get_unix_time_from_system()

func _handle_walk():
	var x_dir = Input.get_axis("ui_left", "ui_right")
	var y_dir = Input.get_axis("ui_up", "ui_down")
	
	if x_dir: velocity.x = x_dir * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if y_dir: velocity.y = y_dir * SPEED
	else: velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _process(_delta):
	if get_multiplayer_authority() != multiplayer.get_unique_id(): return
	_handle_walk()
	if chat_message_time > 0 and Time.get_unix_time_from_system() - chat_message_time > 10:
		chat_message_time = 0
		$Label.text = ""
           RSRC                    PackedScene            ��������                                                  . 	   position    Label    text 	   velocity    resource_local_to_scene    resource_name    custom_solver_bias    size    script    diffuse_texture    normal_texture    specular_texture    specular_color    specular_shininess    texture_filter    texture_repeat    properties/0/path    properties/0/spawn    properties/0/replication_mode    properties/1/path    properties/1/spawn    properties/1/replication_mode    properties/2/path    properties/2/spawn    properties/2/replication_mode 	   _bundled       Script +   res://examples/bobble/components/player.gd ��������      local://RectangleShape2D_368qq r         local://CanvasTexture_8dapy �      %   local://SceneReplicationConfig_6io5i �         local://PackedScene_bvkkk l         RectangleShape2D       
     �A  �A	         CanvasTexture    	         SceneReplicationConfig 
                                                                                                     	         PackedScene          	         names "         Player    collision_layer    collision_mask    script    CharacterBody2D    CollisionShape2D    shape 	   Sprite2D    scale    texture    Label    offset_left    offset_top    offset_right    offset_bottom    horizontal_alignment    MultiplayerSynchronizer    replication_config    	   variants                                  
     �A  �A              ��     PA     �B     C                     node_count             nodes     ;   ��������       ����                                         ����                           ����         	                  
   
   ����                              	                     ����      
             conn_count              conns               node_paths              editable_instances              version       	      RSRC              extends Node2D
const PlayerComponent := preload("./components/player.tscn")

var matcha_room := MatchaRoom.create_mesh_room()
var local_player:
	get:
		if not $Players.has_node(matcha_room.peer_id): return null
		return $Players.get_node(matcha_room.peer_id)

func _enter_tree():
	multiplayer.multiplayer_peer = matcha_room

func _ready():
	_create_player(matcha_room.peer_id, multiplayer.get_unique_id())

	matcha_room.peer_joined.connect(func(id: int, peer: MatchaPeer):
		_create_player(peer.peer_id, id)
	)
	matcha_room.peer_left.connect(func(_id: int, peer: MatchaPeer):
		if $Players.has_node(peer.peer_id): # Remove the player if it exists
			$Players.remove_child($Players.get_node(peer.peer_id))
	)

func _create_player(peer_id: String, authority_id: int):
	if $Players.has_node(peer_id): return # That peer is already known

	var node := PlayerComponent.instantiate()
	node.name = peer_id # The node must have the same name for every person. Otherwise syncing it will fail because path mismatch
	node.position = Vector2(100, 100)
	$Players.add_child(node)
	node.set_multiplayer_authority(authority_id)

func _on_line_edit_text_submitted(new_text):
	$UI/LineEdit.text = ""
	local_player.set_message(new_text)
              RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script     res://examples/bobble/bobble.gd ��������      local://PackedScene_w0qvu          PackedScene          	         names "         Bobble    script    Node2D    UI    layout_mode    anchors_preset    offset_left    offset_top    offset_right    offset_bottom    Control 	   LineEdit    placeholder_text    Players    _on_line_edit_text_submitted    text_submitted    	   variants                                   ��    @D     �D    �"D     |B      A    ��D     XB      Type a chat message...       node_count             nodes     6   ��������       ����                      
      ����                                 	                       ����                        	   	   
                           ����              conn_count             conns                                      node_paths              editable_instances              version             RSRC            extends Node2D

RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://examples/lobby/lobby.gd ��������      local://PackedScene_ruifc          PackedScene          	         names "         Lobby    script    Node2D    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC        extends Node2D

var server_room: MatchaRoom
var client_room: MatchaRoom

func _on_start_server_pressed():
	$start_server.disabled = true
	server_room = MatchaRoom.create_server_room()
	$server_roomid_edit.text = server_room.room_id
	$client_roomid_edit.text = server_room.room_id
	$start_client.disabled = false
	$logs.text += "[Server] Joined (room_id=%s)\n" % [server_room.room_id]

	server_room.peer_joined.connect(func(_id: int, peer: MatchaPeer):
		$logs.text += "[Server] Peer joined (peer_id=%s)\n" % [peer.peer_id]
	)
	server_room.peer_left.connect(func(_id: int, peer: MatchaPeer):
		$logs.text += "[Server] Peer left (peer_id=%s)\n" % [peer.peer_id]
	)

func _on_start_client_pressed():
	$start_client.disabled = true
	$client_roomid_edit.editable = false
	client_room = MatchaRoom.create_client_room($client_roomid_edit.text)
	$logs.text += "[Client] Joined (room_id=%s)\n" % [$client_roomid_edit.text]

	client_room.peer_joined.connect(func(_id: int, peer: MatchaPeer):
		$logs.text += "[Client] Peer joined (peer_id=%s)\n" % [peer.peer_id]
	)
	client_room.peer_left.connect(func(_id: int, peer: MatchaPeer):
		$logs.text += "[Client] Peer left (peer_id=%s)\n" % [peer.peer_id]
	)

func _on_client_roomid_edit_text_changed(new_text):
	$start_client.disabled = new_text.length() == 0
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script .   res://examples/server_client/server_client.gd ��������      local://PackedScene_spjnt %         PackedScene          	         names "         ServerClient    script    Node2D    Label    offset_left    offset_top    offset_right    offset_bottom    text    Label2    start_server    Button    start_client 	   disabled    server_roomid_edit 	   editable 	   LineEdit    Label3    Label4    client_roomid_edit    logs    RichTextLabel    _on_start_server_pressed    pressed    _on_start_client_pressed $   _on_client_roomid_edit_text_changed    text_changed    	   variants    )                  jC     7C     �C     NC      Server     �TD     ?C    �fD     VC      Client      SC     dC    ��C    ��C      Start Server      OD    ��C            Start Client      �B    ��C    ��C     �C            �A     �C     �B    ��C   	   Room id:     �#D    @2D    �5D     �C    @�D    ��C     �C     �C    �RD    @AD      
       node_count    
         nodes     �   ��������       ����                            ����                                                	   ����                        	      
                  
   ����                                                   ����                                                         ����                                                   ����                                                   ����                                                   ����             !      "      #                     ����      $      %      &      '      (             conn_count             conns                                                                                      node_paths              editable_instances              version             RSRC    GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح����mow�*��f�&��Cp�ȑD_��ٮ}�)� C+���UE��tlp�V/<p��ҕ�ig���E�W�����Sթ�� ӗ�A~@2�E�G"���~ ��5tQ#�+�@.ݡ�i۳�3�5�l��^c��=�x�Н&rA��a�lN��TgK㼧�)݉J�N���I�9��R���$`��[���=i�QgK�4c��%�*�D#I-�<�)&a��J�� ���d+�-Ֆ
��Ζ���Ut��(Q�h:�K��xZ�-��b��ٞ%+�]�p�yFV�F'����kd�^���:[Z��/��ʡy�����EJo�񷰼s�ɿ�A���N�O��Y��D��8�c)���TZ6�7m�A��\oE�hZ�{YJ�)u\a{W��>�?�]���+T�<o�{dU�`��5�Hf1�ۗ�j�b�2�,%85�G.�A�J�"���i��e)!	�Z؊U�u�X��j�c�_�r�`֩A�O��X5��F+YNL��A��ƩƗp��ױب���>J�[a|	�J��;�ʴb���F�^�PT�s�)+Xe)qL^wS�`�)%��9�x��bZ��y
Y4�F����$G�$�Rz����[���lu�ie)qN��K�<)�:�,�=�ۼ�R����x��5�'+X�OV�<���F[�g=w[-�A�����v����$+��Ҳ�i����*���	�e͙�Y���:5FM{6�����d)锵Z�*ʹ�v�U+�9�\���������P�e-��Eb)j�y��RwJ�6��Mrd\�pyYJ���t�mMO�'a8�R4��̍ﾒX��R�Vsb|q�id)	�ݛ��GR��$p�����Y��$r�J��^hi�̃�ūu'2+��s�rp�&��U��Pf��+�7�:w��|��EUe�`����$G�C�q�ō&1ŎG�s� Dq�Q�{�p��x���|��S%��<
\�n���9�X�_�y���6]���մ�Ŝt�q�<�RW����A �y��ػ����������p�7�l���?�:������*.ո;i��5�	 Ύ�ș`D*�JZA����V^���%�~������1�#�a'a*�;Qa�y�b��[��'[�"a���H�$��4� ���	j�ô7�xS�@�W�@ ��DF"���X����4g��'4��F�@ ����ܿ� ���e�~�U�T#�x��)vr#�Q��?���2��]i�{8>9^[�� �4�2{�F'&����|���|�.�?��Ȩ"�� 3Tp��93/Dp>ϙ�@�B�\���E��#��YA 7 `�2"���%�c�YM: ��S���"�+ P�9=+D�%�i �3� �G�vs�D ?&"� !�3nEФ��?Q��@D �Z4�]�~D �������6�	q�\.[[7����!��P�=��J��H�*]_��q�s��s��V�=w�� ��9wr��(Z����)'�IH����t�'0��y�luG�9@��UDV�W ��0ݙe)i e��.�� ����<����	�}m֛�������L ,6�  �x����~Tg����&c�U��` ���iڛu����<���?" �-��s[�!}����W�_�J���f����+^*����n�;�SSyp��c��6��e�G���;3Z�A�3�t��i�9b�Pg�����^����t����x��)O��Q�My95�G���;w9�n��$�z[������<w�#�)+��"������" U~}����O��[��|��]q;�lzt�;��Ȱ:��7�������E��*��oh�z���N<_�>���>>��|O�׷_L��/������զ9̳���{���z~����Ŀ?� �.݌��?�N����|��ZgO�o�����9��!�
Ƽ�}S߫˓���:����q�;i��i�]�t� G��Q0�_î!�w��?-��0_�|��nk�S�0l�>=]�e9�G��v��J[=Y9b�3�mE�X�X�-A��fV�2K�jS0"��2!��7��؀�3���3�\�+2�Z`��T	�hI-��N�2���A��M�@�jl����	���5�a�Y�6-o���������x}�}t��Zgs>1)���mQ?����vbZR����m���C��C�{�3o��=}b"/�|���o��?_^�_�+��,���5�U��� 4��]>	@Cl5���w��_$�c��V��sr*5 5��I��9��
�hJV�!�jk�A�=ٞ7���9<T�gť�o�٣����������l��Y�:���}�G�R}Ο����������r!Nϊ�C�;m7�dg����Ez���S%��8��)2Kͪ�6̰�5�/Ӥ�ag�1���,9Pu�]o�Q��{��;�J?<�Yo^_��~��.�>�����]����>߿Y�_�,�U_��o�~��[?n�=��Wg����>���������}y��N�m	n���Kro�䨯rJ���.u�e���-K��䐖��Y�['��N��p������r�Εܪ�x]���j1=^�wʩ4�,���!�&;ج��j�e��EcL���b�_��E�ϕ�u�$�Y��Lj��*���٢Z�y�F��m�p�
�Rw�����,Y�/q��h�M!���,V� �g��Y�J��
.��e�h#�m�d���Y�h�������k�c�q��ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[          [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bx3nh1p0p1oeg"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                extends Node2D

func _on_bobble_btn_pressed():
	get_parent().add_child(load("res://examples/bobble/bobble.tscn").instantiate())
	get_parent().remove_child(self)

func _on_lobby_btn_pressed():
	get_parent().add_child(load("res://examples/lobby/lobby.tscn").instantiate())
	get_parent().remove_child(self)

func _on_server_client_btn_pressed():
	get_parent().add_child(load("res://examples/server_client/server_client.tscn").instantiate())
	get_parent().remove_child(self)
         RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://root.gd ��������      local://PackedScene_lvbyo          PackedScene          	         names "         root    script    Node2D    bobble_btn    offset_left    offset_top    offset_right    offset_bottom    text    Button 
   lobby_btn    visible    server_client_btn    _on_bobble_btn_pressed    pressed    _on_lobby_btn_pressed    _on_server_client_btn_pressed    	   variants                      �C     PC     D     oC      Start bobble            � D    ��C     D     �C      Start lobby      �C     �C    �D    ��C      Server / Client       node_count             nodes     >   ��������       ����                      	      ����                                             	   
   ����                        	      
                     	      ����                                           conn_count             conns                                                                                      node_paths              editable_instances              version             RSRC[remap]

path="res://.godot/exported/133200997/export-bab7f66da158eb92d4a519c9e5bf8439-player.scn"
             [remap]

path="res://.godot/exported/133200997/export-61e474ebecd96a8a7bfc183b8acbdb18-bobble.scn"
             [remap]

path="res://.godot/exported/133200997/export-61bb896f3c9c05f0d1e2c55a3eacd5ad-lobby.scn"
              [remap]

path="res://.godot/exported/133200997/export-54c952f023ea1e258f1d375059f8166d-server_client.scn"
      [remap]

path="res://.godot/exported/133200997/export-6581cd44ca730c421bddc3302d6ce6cc-root.scn"
               list=Array[Dictionary]([{
"base": &"RefCounted",
"class": &"Big",
"icon": "",
"language": &"GDScript",
"path": "res://addons/matcha/nostr/Big.gd"
}, {
"base": &"WebRTCPeerConnection",
"class": &"MatchaPeer",
"icon": "",
"language": &"GDScript",
"path": "res://addons/matcha/MatchaPeer.gd"
}, {
"base": &"WebRTCMultiplayerPeer",
"class": &"MatchaRoom",
"icon": "",
"language": &"GDScript",
"path": "res://addons/matcha/MatchaRoom.gd"
}, {
"base": &"RefCounted",
"class": &"Secp256k1",
"icon": "",
"language": &"GDScript",
"path": "res://addons/matcha/nostr/Secp256k1.gd"
}])
  <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             �$��)T&,   res://examples/bobble/components/player.tscnCx�@Lr!   res://examples/bobble/bobble.tscnM|,�g�e|   res://examples/lobby/lobby.tscn�O����g/   res://examples/server_client/server_client.tscns�4�\��*   res://root.tscnfS�e�U8   res://icon.svg            ECFG      application/config/name         matcha     application/run/main_scene         res://root.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     audio/driver/mix_rate.web      D�  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height            display/window/stretch/mode         viewport   display/window/stretch/aspect      
   keep_width  #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility4   rendering/textures/vram_compression/import_etc2_astc           
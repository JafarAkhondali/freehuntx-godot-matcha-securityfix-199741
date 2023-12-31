GDPC                �
                                                                         \   res://.godot/exported/133200997/export-54c952f023ea1e258f1d375059f8166d-server_client.scn         L      �B4�S͑���U:l]�    T   res://.godot/exported/133200997/export-61bb896f3c9c05f0d1e2c55a3eacd5ad-lobby.scn   p     x      ��śe e��sk5�    T   res://.godot/exported/133200997/export-61e474ebecd96a8a7bfc183b8acbdb18-bobble.scn  P     	      >���c���5�H@B�    P   res://.godot/exported/133200997/export-6581cd44ca730c421bddc3302d6ce6cc-root.scn`�     0      ��S����vc���;K�    T   res://.godot/exported/133200997/export-bab7f66da158eb92d4a519c9e5bf8439-player.scn  P�            �*7�h�œg�u�yb�    ,   res://.godot/global_script_class_cache.cfg  ��     �      �B ����f�e�9ڮ�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctexP     �      �Yz=������������    D   res://.godot/imported/logo.png-cca8726399059c8d4f806e28e356b14d.ctex +     ��      �c�;��2t��[��       res://.godot/uid_cache.bin  P�           ������͚�{�@Y�ώ    $   res://addons/matcha/MatchaPeer.gd    �      �      k�|i�Ţ~/7�J9    $   res://addons/matcha/MatchaRoom.gd   ��      n"      C�����dι�7v�u    $   res://addons/matcha/lib/Seriously.gd        +K      ��l�j��Ad�y\        res://addons/matcha/lib/Utils.gd0K            �=/��������+ɨ�    ,   res://addons/matcha/lib/WebSocketClient.gd  PL      �      4�<��G� �W=U        res://addons/matcha/nostr/Big.gd�Z      �K      ��'8�/�`k/�G"X�    (   res://addons/matcha/nostr/Secp256k1.gd  �      �      @��#$!�fk�����    ,   res://addons/matcha/tracker/TrackerClient.gd��      w      ,p����/�����        res://examples/bobble/bobble.gd `�      �      !�����8�    (   res://examples/bobble/bobble.tscn.remap  �     c       f�!˵[��6m毽    ,   res://examples/bobble/components/player.gd  P�      �      8 1%p��%~F�
�w:    4   res://examples/bobble/components/player.tscn.remap  ��     c       ͅX�j�Oc6�i�        res://examples/lobby/lobby.gd   `            ��,�H6���aqct�~    (   res://examples/lobby/lobby.tscn.remap   p�     b       ��4Br�`����8�0    0   res://examples/server_client/server_client.gd   �           #������]Vwx�) =    8   res://examples/server_client/server_client.tscn.remap   ��     j       �m���0 BВ��(�T       res://icon.svg  ��     �      C��=U���^Qu��U3       res://icon.svg.import   0*     �       �Kå�#����ڟ)       res://logo.png.import   ��     �       JC�U�4�dNZ�       res://project.binaryp�     �      � ~�Xfn�ɐ�	�       res://root.gd   ��     �      �2J�<�"�[���
i�       res://root.tscn.remap   P�     a       ;�/q�;X�����=�k                # Source: https://github.com/freehuntx/godot-seriously
class_name Seriously extends RefCounted

const OBJECT_AS_DICT := false # Should objects be serialized as dict? (more performance?)
const INT_MAX = 9223372036854775807
const INT_MIN = -9223372036854775808

enum CustomTypes {
	# Ensure the values dont overlap with an existing TYPE_*
	UINT8 = 50,
	INT8 = 51,
	UINT16 = 52,
	INT16 = 53,
	UINT32 = 54,
	INT32 = 55,
	UINT64 = 56,
	INT64 = 57,
	TYPED_ARRAY = 58
}

static var _serializer = {
	TYPE_NIL: {
		"pack": func(_value, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			return stream,
		"unpack": func(_stream: StreamPeerBuffer):
			return null,
	},
	TYPE_BOOL: {
		"pack": func(value, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u8(1 if value else 0)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> bool:
			return stream.get_u8() > 0,
	},
	TYPE_INT: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_32(),
	},
	CustomTypes.UINT8: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u8(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u8(),
	},
	CustomTypes.INT8: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_8(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_8(),
	},
	CustomTypes.UINT16: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u16(),
	},
	CustomTypes.INT16: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_16(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_16(),
	},
	CustomTypes.UINT32: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u32(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u32(),
	},
	CustomTypes.INT32: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_32(),
	},
	CustomTypes.UINT64: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u64(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_u64(),
	},
	CustomTypes.INT64: {
		"pack": func(value: int, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_64(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> int:
			return stream.get_64(),
	},
	TYPE_FLOAT: {
		"pack": func(value: float, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_double(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> float:
			return stream.get_double(),
	},
	TYPE_STRING: {
		"pack": func(value: String, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value.length())
			stream.put_data(value.to_utf8_buffer())
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> String:
			return stream.get_utf8_string(stream.get_u16()),
	},
	TYPE_VECTOR2: {
		"pack": func(value: Vector2, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector2:
			return Vector2(stream.get_float(), stream.get_float()),
	},
	TYPE_VECTOR2I: {
		"pack": func(value: Vector2i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.x)
			stream.put_32(value.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector2i:
			return Vector2i(stream.get_32(), stream.get_32()),
	},
	TYPE_RECT2: {
		"pack": func(value: Rect2, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.position.x)
			stream.put_float(value.position.y)
			stream.put_float(value.size.x)
			stream.put_float(value.size.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Rect2:
			return Rect2(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_RECT2I: {
		"pack": func(value: Rect2i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.position.x)
			stream.put_32(value.position.y)
			stream.put_32(value.size.x)
			stream.put_32(value.size.y)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Rect2i:
			return Rect2i(stream.get_32(), stream.get_32(), stream.get_32(), stream.get_32()),
	},
	TYPE_VECTOR3: {
		"pack": func(value: Vector3, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			stream.put_float(value.z)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector3:
			return Vector3(stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_VECTOR3I: {
		"pack": func(value: Vector3i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.x)
			stream.put_32(value.y)
			stream.put_32(value.z)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector3i:
			return Vector3i(stream.get_32(), stream.get_32(), stream.get_32()),
	},
	TYPE_TRANSFORM2D: {
		"pack": func(value: Transform2D, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.x, stream, TYPE_VECTOR2)
			pack(value.y, stream, TYPE_VECTOR2)
			pack(value.origin, stream, TYPE_VECTOR2)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Transform2D:
			return Transform2D(unpack(stream, TYPE_VECTOR2), unpack(stream, TYPE_VECTOR2), unpack(stream, TYPE_VECTOR2)),
	},
	TYPE_VECTOR4: {
		"pack": func(value: Vector4, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			stream.put_float(value.z)
			stream.put_float(value.w)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector4:
			return Vector4(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_VECTOR4I: {
		"pack": func(value: Vector4i, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_32(value.x)
			stream.put_32(value.y)
			stream.put_32(value.z)
			stream.put_32(value.w)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Vector4i:
			return Vector4i(stream.get_32(), stream.get_32(), stream.get_32(), stream.get_32()),
	},
	TYPE_PLANE: {
		"pack": func(value: Plane, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.normal, stream, TYPE_VECTOR3)
			stream.put_float(value.d)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Plane:
			return Plane(unpack(stream, TYPE_VECTOR3), stream.get_float()),
	},
	TYPE_QUATERNION: {
		"pack": func(value: Quaternion, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_float(value.x)
			stream.put_float(value.y)
			stream.put_float(value.z)
			stream.put_float(value.w)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Quaternion:
			return Quaternion(stream.get_float(), stream.get_float(), stream.get_float(), stream.get_float()),
	},
	TYPE_AABB: {
		"pack": func(value: AABB, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.position, stream, TYPE_VECTOR3)
			pack(value.size, stream, TYPE_VECTOR3)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> AABB:
			return AABB(unpack(stream, TYPE_VECTOR3), unpack(stream, TYPE_VECTOR3)),
	},
	TYPE_BASIS: {
		"pack": func(value: Basis, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.x, stream, TYPE_VECTOR3)
			pack(value.y, stream, TYPE_VECTOR3)
			pack(value.z, stream, TYPE_VECTOR3)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Basis:
			return Basis(unpack(stream, TYPE_VECTOR3), unpack(stream, TYPE_VECTOR3), unpack(stream, TYPE_VECTOR3)),
	},
	TYPE_TRANSFORM3D: {
		"pack": func(value: Transform3D, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.basis, stream, TYPE_BASIS)
			pack(value.origin, stream, TYPE_VECTOR3)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Transform3D:
			return Transform3D(unpack(stream, TYPE_BASIS), unpack(stream, TYPE_VECTOR3)),
	},
	TYPE_PROJECTION: {
		"pack": func(value: Projection, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(value.x, stream, TYPE_VECTOR4)
			pack(value.y, stream, TYPE_VECTOR4)
			pack(value.z, stream, TYPE_VECTOR4)
			pack(value.w, stream, TYPE_VECTOR4)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Projection:
			return Projection(unpack(stream, TYPE_VECTOR4), unpack(stream, TYPE_VECTOR4), unpack(stream, TYPE_VECTOR4), unpack(stream, TYPE_VECTOR4)),
	},
	TYPE_COLOR: {
		"pack": func(value: Color, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u32(value.to_rgba32())
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Color:
			return Color(stream.get_u32()),
	},
	TYPE_STRING_NAME: {
		"pack": func(value: StringName, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(str(value), stream, TYPE_STRING)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> StringName:
			return StringName(unpack(stream, TYPE_STRING)),
	},
	TYPE_NODE_PATH: {
		"pack": func(value: NodePath, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			pack(str(value), stream, TYPE_STRING)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> NodePath:
			return NodePath(unpack(stream, TYPE_STRING)),
	},
	TYPE_RID: {
		"pack": func(_value: RID, _stream: StreamPeerBuffer) -> StreamPeerBuffer:
			push_error("[Seriously] TYPE_RID is not supported")
			return null,
		"unpack": func(_stream: StreamPeerBuffer):
			push_error("[Seriously] TYPE_RID is not supported")
			return null,
	},
	TYPE_OBJECT: {
		"pack": func(value: Object, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var prop_names = value.get_property_list().filter(func(p): return p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE).map(func(p): return p.name)

			stream.put_u16(prop_names.size())

			for name in prop_names:
				pack(name, stream, TYPE_STRING)
				pack(value.get(name), stream)

			return stream,
		"unpack": func(stream: StreamPeerBuffer):
			var object_size := stream.get_u16()
			var dict := {}

			for j in object_size:
				var name = unpack(stream, TYPE_STRING)
				dict[name] = unpack(stream)

			if OBJECT_AS_DICT:
				return dict

			# Create dynamic object (bad performance?)
			var source_code := "extends RefCounted\n"

			for name in dict.keys():
				source_code += "var %s\n" % [name]

			var dynamic_object := GDScript.new()
			dynamic_object.source_code = source_code
			dynamic_object.reload()

			var object = dynamic_object.new()
			for name in dict.keys():
				object.set(name, dict[name])

			return object,
	},
	TYPE_CALLABLE: {
		"pack": func(_value: Callable, _stream: StreamPeerBuffer) -> StreamPeerBuffer:
			push_error("[Seriously] TYPE_CALLABLE type pack requested. This is not possible!")
			return null,
		"unpack": func(_stream: StreamPeerBuffer):
			push_error("[Seriously] TYPE_CALLABLE type unpack requested. This is not possible!")
			return null,
	},
	TYPE_SIGNAL: {
		"pack": func(_value: Signal, _stream: StreamPeerBuffer) -> StreamPeerBuffer:
			push_error("[Seriously] TYPE_SIGNAL type pack requested. This is not possible!")
			return null,
		"unpack": func(_stream: StreamPeerBuffer):
			push_error("[Seriously] TYPE_SIGNAL type unpack requested. This is not possible!")
			return null,
	},
	TYPE_DICTIONARY: {
		"pack": func(value: Dictionary, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value.size())

			for key in value.keys():
				pack(key, stream, TYPE_STRING)
				pack(value[key], stream)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Dictionary:
			var dictionary_size = stream.get_u16()
			var dictionary = {}

			for j in dictionary_size:
				var name = unpack(stream, TYPE_STRING)
				dictionary[name] = unpack(stream)

			return dictionary,
	},
	TYPE_ARRAY: {
		"pack": func(value: Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var array_size := value.size()

			stream.put_u16(array_size)

			for i in array_size:
				pack(value[i], stream)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> Array:
			var array_size = stream.get_u16()
			var array = []

			for i in array_size:
				array.append(unpack(stream))

			return array,
	},
	TYPE_PACKED_BYTE_ARRAY: {
		"pack": func(value: PackedByteArray, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value.size())
			stream.put_data(value)
			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedByteArray:
			var array_size := stream.get_u16()
			var data = stream.get_data(array_size)[1]
			return PackedByteArray(data),
	},
	TYPE_PACKED_INT32_ARRAY: {
		"pack": func(value: PackedInt32Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()

			stream.put_u16(buffer.size())
			stream.put_data(buffer)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedInt32Array:
			return PackedByteArray(stream.get_data(stream.get_u16())).to_int32_array(),
	},
	TYPE_PACKED_INT64_ARRAY: {
		"pack": func(value: PackedInt64Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()

			stream.put_u16(buffer.size())
			stream.put_data(buffer)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedInt64Array:
			return PackedByteArray(stream.get_data(stream.get_u16())).to_int64_array(),
	},
	TYPE_PACKED_FLOAT32_ARRAY: {
		"pack": func(value: PackedFloat32Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()

			stream.put_u16(buffer.size())
			stream.put_data(buffer)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedFloat32Array:
			return PackedByteArray(stream.get_data(stream.get_u16())).to_float32_array(),
	},
	TYPE_PACKED_FLOAT64_ARRAY: {
		"pack": func(value: PackedFloat64Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var buffer = value.to_byte_array()

			stream.put_u16(buffer.size())
			stream.put_data(buffer)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedFloat64Array:
			return PackedByteArray(stream.get_data(stream.get_u16())).to_float64_array(),
	},
	TYPE_PACKED_STRING_ARRAY: {
		"pack": func(value: PackedStringArray, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value.size())

			for string in value:
				pack(string, stream, TYPE_STRING)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedStringArray:
			var array_size := stream.get_u16()
			var array := PackedStringArray()

			for i in array_size:
				array.append(unpack(stream, TYPE_STRING))

			return array,
	},
	TYPE_PACKED_VECTOR2_ARRAY: {
		"pack": func(value: PackedVector2Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value.size())

			for vector in value:
				pack(vector, stream, TYPE_VECTOR2)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedVector2Array:
			var array_size := stream.get_u16()
			var array := PackedVector2Array()

			for i in array_size:
				array.append(unpack(stream, TYPE_VECTOR2))

			return array,
	},
	TYPE_PACKED_VECTOR3_ARRAY: {
		"pack": func(value: PackedVector3Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value.size())

			for vector in value:
				pack(vector, stream, TYPE_VECTOR3)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedVector3Array:
			var array_size := stream.get_u16()
			var array := PackedVector3Array()

			for i in array_size:
				array.append(unpack(stream, TYPE_VECTOR3))

			return array,
	},
	TYPE_PACKED_COLOR_ARRAY: {
		"pack": func(value: PackedColorArray, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			stream.put_u16(value.size())

			for vector in value:
				pack(vector, stream, TYPE_COLOR)

			return stream,
		"unpack": func(stream: StreamPeerBuffer) -> PackedColorArray:
			var array_size := stream.get_u16()
			var array := PackedColorArray()

			for i in array_size:
				array.append(unpack(stream, TYPE_COLOR))

			return array,
	},
	CustomTypes.TYPED_ARRAY: {
		"pack": func(array: Array, stream: StreamPeerBuffer) -> StreamPeerBuffer:
			var item_type: int = TYPE_NIL

			if _can_array_be_typed(array):
				item_type = typeof(array[0])

			stream.put_u16(array.size())
			stream.put_u8(item_type)

			for item in array:
				pack(item, stream, item_type)

			return stream,
		"unpack": func(stream: StreamPeerBuffer):
			var array_size = stream.get_u16()
			var item_type = stream.get_u8()

			if item_type == TYPE_NIL:
				return null

			var array = []
			for i in array_size:
				array.append(unpack(stream, item_type))

			return array,
	}
}

static func pack_to_bytes(value) -> PackedByteArray:
	return pack(value).data_array

static func unpack_from_bytes(bytes: PackedByteArray):
	var stream := StreamPeerBuffer.new()
	stream.data_array = bytes
	return unpack(stream)

static func pack(value, stream:=StreamPeerBuffer.new(), type:=-1, add_type_prefix:=false) -> StreamPeerBuffer:
	add_type_prefix = add_type_prefix or type == -1 # If type is unknown we add a type prefix to identify it

	if type == -1:
		type = typeof(value) # Check the generic type of the value

		# If the type is an array, lets try to make it typed (to save data)
		if type == TYPE_ARRAY and _can_array_be_typed(value):
			type = CustomTypes.TYPED_ARRAY
		if type == TYPE_INT:
			type = _get_int_type(value)
		if type == TYPE_OBJECT and value == null:
			type = TYPE_NIL

	if not type in _serializer:
		push_error("[Seriously] Unknown type: ", type)
		return null

	if add_type_prefix:
		stream.put_u8(type)

	return _serializer[type].pack.call(value, stream)

static func unpack(stream: StreamPeerBuffer, type:=-1):
	if type == -1: # If we dont define a type we try to read a type prefix
		type = stream.get_u8()

	if not type in _serializer:
		push_error("[Seriously] Unknown type: ", type)
		return null

	return _serializer[type].unpack.call(stream)

# Private methods
static func _can_array_be_typed(array: Array) -> bool:
	if array.size() == 0: # Typing empty arrays makes no sense
		return false
	if array.size() == 1:
		return true # If an array has just 1 entry thats 1 type. So it CAN be typed

	var array_type: int = typeof(array[0]) # Lets check if all other entries have the same type
	for entry in array:
		if typeof(entry) != array_type: return false # This array cannot be typed because there is a mismatch

	return true

static func _get_int_type(value: int) -> int:
	var unsigned = value >= 0
	var bit_size = 8
	if abs(value) <= 0xFF:
		bit_size = 8
	elif abs(value) <= 0xFFFF:
		bit_size = 16
	elif abs(value) <= 0xFFFFFFFF:
		bit_size = 32
	elif value >= INT_MIN and value <= INT_MAX:
		bit_size = 64
	else:
		push_error("[Seriously] Unsupported integer: ", value)
		return -1

	var type_name := "%sINT%s" % ["U" if unsigned else "", bit_size]
	if not type_name in CustomTypes:
		push_error("[Seriously] Unsupported integer: ", value)
		return -1

	return CustomTypes[type_name]
     # Generate an random string with a certain length
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
var _event_channel: WebRTCDataChannel
var _event_listener := {} # We store event callback functions in here

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

	if initialize({"iceServers":[{"urls":["stun:stun.l.google.com:19302"]}]}) != OK:
		push_error("Initializing failed")
		_state = State.CLOSED
	_event_channel = create_data_channel("events", {"id": 555, "negotiated": true})

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

# Allows you to send an event.
func send_event(event_name: String, event_args:=[]) -> Error:
	var pack_array = [event_name]
	if event_args.size() > 0:
		pack_array.append(event_args)
	return _event_channel.put_packet(Seriously.pack_to_bytes(pack_array))

# Allows you to listen to an event just one time. If the event was triggered the listener is removed.
func once_event(event_name: String, callback: Callable) -> Callable:
	return on_event(event_name, callback, true)

# Allows you to listen to an event. The return function can be used to remove that listener.
func on_event(event_name: String, callback: Callable, once:=false) -> Callable:
	if not event_name in _event_listener: _event_listener[event_name] = []

	var listener = [callback, once]
	_event_listener[event_name].append(listener)

	return off_event.bind(event_name, callback, once)

# Unregister an listener on an event
func off_event(event_name: String, callback: Callable, once:=false) -> void:
	if not event_name in _event_listener: return
	_event_listener[event_name] = _event_listener[event_name].filter(func(e): return e[0] != callback and e[1] != once)

# Private methods
func __poll() -> void:
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

	# Read all event packets
	while _event_channel.get_available_packet_count():
		var buffer := _event_channel.get_packet()
		var args = Seriously.unpack_from_bytes(buffer)
		if typeof(args) != TYPE_ARRAY or args.size() < 1 or typeof(args[0]) != TYPE_STRING:
			continue
		if args.size() == 2 and typeof(args[1]) != TYPE_ARRAY:
			continue
		_emit_event.callv(args)

func __close() -> void:
	if _state == State.CLOSED:
		return

	close()

	if _state == State.CONNECTING:
		connecting_failed.emit()
	elif _state == State.CONNECTED:
		disconnected.emit()

	_state = State.CLOSED
	closed.emit()

# Handle an event
func _emit_event(event_name: String, event_args:=[]) -> void:
	if not event_name in _event_listener: return

	# Remove null instance callbacks
	_event_listener[event_name] = _event_listener[event_name].filter(func(e): return e[0].get_object() != null)

	for listener in _event_listener[event_name]:
		listener[0].callv(event_args)

	# Remove once listeners
	_event_listener[event_name] = _event_listener[event_name].filter(func(e): return not e[1])

	if _event_listener[event_name].size() == 0:
		_event_listener.erase(event_name)

# Callbacks
func _on_session_description_created(type: String, sdp: String) -> void:
	_local_sdp = sdp
	set_local_description(type, sdp)

func _on_ice_candidate_created(media: String, index: int, name: String) -> void:
	_local_sdp += "a=%s\r\n" % [name]
       # TODO: DOCUMENT, DOCUMENT, DOCUMENT!

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

# Broadcast an event to everybody in this room or just specific peers. (List of peer_id)
func send_event(event_name: String, event_args:=[], target_peer_ids:=[]):
	for peer: MatchaPeer in _peers:
		if not peer.is_connected: continue
		if target_peer_ids.size() > 0 and not target_peer_ids.has(peer.peer_id): continue
		peer.send_event(event_name, event_args)

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
  extends CharacterBody2D

const SPEED = 300.0
var chat_message_time: float

func set_message(message: String) -> void:
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
  RSRC                    PackedScene            ��������                                                  . 	   position    Label    text 	   velocity    resource_local_to_scene    resource_name    custom_solver_bias    size    script    diffuse_texture    normal_texture    specular_texture    specular_color    specular_shininess    texture_filter    texture_repeat    properties/0/path    properties/0/spawn    properties/0/replication_mode    properties/1/path    properties/1/spawn    properties/1/replication_mode    properties/2/path    properties/2/spawn    properties/2/replication_mode 	   _bundled       Script +   res://examples/bobble/components/player.gd ��������      local://RectangleShape2D_368qq r         local://CanvasTexture_8dapy �      %   local://SceneReplicationConfig_6io5i �         local://PackedScene_c3wqb l         RectangleShape2D       
     �A  �A	         CanvasTexture    	         SceneReplicationConfig 
                                                                                                     	         PackedScene          	         names "         Player    collision_layer    collision_mask    script    CharacterBody2D    CollisionShape2D    shape 	   Sprite2D    scale    texture    Label    offset_left    offset_top    offset_right    offset_bottom    horizontal_alignment    MultiplayerSynchronizer    replication_config    	   variants                                  
     �A  �A              ��     PA     �B     C                     node_count             nodes     ;   ��������       ����                                         ����                           ����         	                  
   
   ����                              	                     ����      
             conn_count              conns               node_paths              editable_instances              version       	      RSRC              extends Node2D
const PlayerComponent := preload("./components/player.tscn")

var matcha_room := MatchaRoom.create_mesh_room()
var players := {}
var local_player:
	get:
		if not matcha_room.peer_id in players: return null
		return players[matcha_room.peer_id]

func _init():
	matcha_room.peer_joined.connect(self._on_peer_joined)
	matcha_room.peer_left.connect(self._on_peer_left)

func _enter_tree():
	multiplayer.multiplayer_peer = matcha_room

func _ready():
	_add_player(matcha_room.peer_id, multiplayer.get_unique_id()) # Add ourself

func _add_player(peer_id: String, authority_id: int) -> void:
	if peer_id in players: return # That peer is already known

	var node := PlayerComponent.instantiate()
	node.name = peer_id # The node must have the same name for every person. Otherwise syncing it will fail because path mismatch
	node.position = Vector2(100, 100)
	players[peer_id] = node
	$Players.add_child(node)
	node.set_multiplayer_authority(authority_id)

func _remove_player(peer_id: String) -> void:
	if not peer_id in players: return # That peer is not known
	$Players.remove_child($Players.get_node(peer_id))

# Peer callbacks
func _on_peer_joined(id: int, peer: MatchaPeer) -> void:
	# Listen to events the other peer may send
	peer.on_event("chat", self._on_peer_chat.bind(peer))
	peer.on_event("secret", self._on_peer_secret.bind(peer))
	_add_player(peer.peer_id, id) # Create the player

func _on_peer_left(_id: int, peer: MatchaPeer) -> void:
	_remove_player(peer.peer_id)

func _on_peer_chat(message: String, peer: MatchaPeer) -> void:
	$UI/chat_history.text += "\n%s: %s" % [peer.peer_id, message]
	players[peer.peer_id].set_message(message)

func _on_peer_secret(peer: MatchaPeer) -> void:
	var sprite: Sprite2D = players[peer.peer_id].get_node("Sprite2D")
	sprite.modulate = Color.from_hsv((randi() % 12) / 12.0, 1, 1)

# UI Callbacks
func _on_line_edit_text_submitted(new_text) -> void:
	if new_text == "": return
	$UI/chat_input.text = ""
	$UI/chat_history.text += "\n%s (Me): %s" % [matcha_room.peer_id, new_text]
	local_player.set_message(new_text)
	matcha_room.send_event("chat", [new_text])

func _on_secret_button_pressed() -> void:
	matcha_room.send_event("secret")

func _on_chat_send_pressed() -> void:
	_on_line_edit_text_submitted($UI/chat_input.text)
  RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script     res://examples/bobble/bobble.gd ��������      local://PackedScene_y84l7          PackedScene          	         names "         Bobble    script    Node2D    UI    layout_mode    anchors_preset    offset_left    offset_top    offset_right    offset_bottom    Control    chat_history    text    scroll_following    RichTextLabel    chat_input    placeholder_text 	   LineEdit    secret_button    Button 
   chat_send    Players    _on_line_edit_text_submitted    text_submitted    _on_secret_button_pressed    pressed    _on_chat_send_pressed    	   variants                                   ��      �    ��D     HD     �A    @D     �D    �5D      

            �A    �7D    ��D    �BD      Type a chat message...     `�D    �D    @�D     3D   "   Secret button
What will it do? :)     ��D      Send       node_count             nodes     q   ��������       ����                      
      ����                                 	                       ����                        	   	   
                                ����                           	                             ����                           	                             ����                           	                              ����              conn_count             conns                                                                                      node_paths              editable_instances              version             RSRC       extends Node2D

RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://examples/lobby/lobby.gd ��������      local://PackedScene_n4lr0          PackedScene          	         names "         Lobby    script    Node2D    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC        extends Node2D

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
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script .   res://examples/server_client/server_client.gd ��������      local://PackedScene_5ofkt %         PackedScene          	         names "         ServerClient    script    Node2D    Label    offset_left    offset_top    offset_right    offset_bottom    text    Label2    start_server    Button    start_client 	   disabled    server_roomid_edit 	   editable 	   LineEdit    Label3    Label4    client_roomid_edit    logs    RichTextLabel    _on_start_server_pressed    pressed    _on_start_client_pressed $   _on_client_roomid_edit_text_changed    text_changed    	   variants    )                  jC     7C     �C     NC      Server     �TD     ?C    �fD     VC      Client      SC     dC    ��C    ��C      Start Server      OD    ��C            Start Client      �B    ��C    ��C     �C            �A     �C     �B    ��C   	   Room id:     �#D    @2D    �5D     �C    @�D    ��C     �C     �C    �RD    @AD      
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
uid="uid://bhelyt757vn5r"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                GST2   �   �      ����               � �        ��  RIFFx�  WEBPVP8Lk�  /� / �(l۶�#I��� =s�CF�0ٿ���n@�A�H���A��^�QI��y����#<lIR4��v�0��=c�GAF�C2�;�
�C����������{�/q�Ȓǐ!��mk����ڤ�5� ���U�d�-I�%I�m�X]>���ڕ�o!I�$�j<
N�}N�%�NZ�d۶��uy�B�Yc_S_( C�� ��1Я�4h�m[�$I:�}QUCws�H�jf�A33C2V8��*��{&�ٶme�$g�}������&C�@���033��S�����P�F��I���f���w�ٞ$I�m۶#�1�Zk�w��P��y�B�Q���O����p�(.I�U[�d��>�QfDT7����������9{�4|K�dI�d[D���u�������%�̈́|K�dI�d[Dl������s��0�_�$��mۖ�G����13�?/���Z���{LС��2���m�m�mc�}H�Χ�.��S�A�)�i]�$�����F� I�D�<�z�^�7]�U��/�+�M�#�Vm۶-���Ra��b13�3q@�J��$ɒ$ɶ��3�>�����%B�bI�$I�ș��_ޟ�Pڶց�ޠK�mն#�����E!��yD233sf	����LR>����k�J�m�Զmc�s]����o��_6��PQe�ӲU���m����5�繯��Ԯm۱M�t�u�"2R��m�<X�Y�Y��=�`۶m#3#����:Cm�6�����@A�$E���U=p{����-��6VE|Ó H�$I���,������j��
3!�oI�,I�l��Y�#3���ߚ�a[۶C������H��j�m������Z�k�m۶ͱ=S6�:��i��m۴�a�z�c������4/�m�����?@G��m۶����%"wxc�9���I�lKD���="��j��+33��[fffff�� w7S�����j�ǬK̖ d���G��Z9�4(Y6P�`�P)�	�%:D�$m2�bP�( lBJ �@��hdPi�
%D�;�HƂ ��F"&J�Kbm$�]P�84Jd$ۄp�X 	h`��Uf#�t�DZ$*��ʤՂ�&yi�Yn�T8��cq���hd+�,�G��2���ɞ�GF 8����?GZI-X��PR�`A:�%���c�Rz��vp�('P� ��c	KPZ���(�x�Dt�n�H\��We,�X�@HG���`��A@%�.(]v��$�T��"I�U2P�Q`@)4B�$�e��gK9��`Y��e�j�0X���H1j3a�z������$���ܥP̅��HJI	 �J�4HJ� �	K��E�@-��,��mL7�aϖ�|�۰���h�B{�q�%%]4���ј
^nmkn��T�1�Z�ؚBc�%-���]�H+� �@"H`)����H ���r�쾕
���dN���	ͨ�hC{.��KFp��ՠ��h��3,���|PND��-iIZA0 A@�l�0��A�B[
8 -�:N/X଄��CFf��4��1ݸ
\M�}r�p����9V�����4�Je����!vȀ0n Ppր�"I�FR 2iA��R2,+E�D2Vcw��*ՊYXe�E	��d-l}�Y � @�M�[�"0}ĊJ�؝{@}�ҕ$Q;J ��M,�4D��r� 1�B�C9B�jf�l�����hp��"���tC[��h�X������B�Q$2l��6�z4aE�ӵ��rEy8�ܤHeY����#:�DF��8�ȫA5ME�D�Lݹ�D��0Ԁ+e=&xL��<�c+J\�5YV+
�D�a�*�1^�1�jX���I����*Y2�4P�)(Y!Oh���i�h�h!��)�Di����zn��$�=�@����a�/>���1�HDn暵�Q��e(ˁ�����lXRJę�@��J�E	���E�FI�%��LIԂ�%[�D �$���AY�K�(�d%?�u,F�A�c�,�u�D�a��d(`�ذ$�iyH��Ne%�R22-0"Z&+Y�+-D�(iځ�5^�b��Y"�!�0̞b�l׳kK�.}��Q���8������5�=���1>����uH�u\c&����V�Ppi�
p�Z��v9*R��":����
E�$-���))�������-S(EV-��],Jd���e�U�E<�E�T3�jO5rCюr�E��R��Ӓr����@�B,%X���#70[z%���m���Z{�غf{�z���|�==�x�{+�O��ym_x����E�q@XI��y�O�_���o�߮`����˥�6���J67Z�I V��h�U4:e�H�IXJ�3j5D�R$Q�D�ZHF�Jm��JNؠ

��Pn���h5K�8g�����JX��
�F��xuu���b0�ӥd�2�9���a��h�$ ǩ)*��3!�va�<��|�~�{������W�^�{����x ��9��B�Ģ5�ִ���$�����}����ޯ����ǉ�qX����1�LϞPe*Y�NOV�V�텒l/E�F�P����d� ��l�O
@�S��V+��'�_e�i	L���P��%�Z����,�Z�\eLg ���%E%�H���]YQ%UH1i	��m�4���|�/�~^���o�}�Շ�=��8��:���aj���32D0 ���!g5Tc�Z�p��������o�s�g���`����m�"E^[h԰Ҿ$r*إ �B����d� �ɤQ4Т��y:
��j��e���s����g�c�Lյr�9a3��h�rVbŬԆ��-j�AR���dW�4$�A1J�p,�خ��@er�T�����'������y������������>߷�uy�5nPs�CB� �(!�F*��c`0CYƖf%H����nY�:����_���ٯ�uѯ���,^��D�h'QE"E� ��KAQ6 �� @)S�+�"$@�@+���XW�1��	��>\$���Au�DƝr�w1�B ���V�"5��BhT���$q��;�.`�d�k=�����|��������^x�˫�jl����L�>O�ؤ!�A�#	JaP�2�lAXwˢ5�˾h�ϛ��v�����/���7s?���˜���vuͭ&Q�&*�x	 ���`"�(M@a�Ma����g��c��6�
 �0�W��q-�HK�"+����ZF����WS�	@�.���Y�gb�@	W
��i1Ti(aY�}����::��7�F��?��w����>]�I��T�o�M��� ����fƞ�#S"�@��QR^���:�aI̳��k��>��o^��c_���ѻ��5C|ކ����5(�4#2��$��@PT:��P6T�u��P�fE2�wnH :ie`=K2(E	�v� ���<B��
�W��`G�"Wj�$�""i�%#M�-5�f ����c���6�>3�_�q���7y}*�|�Y�?���FXK D�Ydİ�� �03lFax)i\@Ę(�P���X[\ RX�i\X���x�m���ϯ�_�}<��r�yF�k��J@�V+�`	P D�BUh�@^A"�0ډ�} k��I=~��Q��"r���b�����[���T�XUAR�   ��c�%�I��@d��Y�y-������������]g����#蘨'�}�Ԉ:8ü�����*'\�bC� �	 ���K��Ha/e��.�VR5ry\��C����Ǿ~��M_�F~C_��
¢~!o
HFJ@C$R�Rg��Y� ��:� rڴ;�Vf�Z}f���H�,W7h�Q)�������Je��A�)���EA��Z�ظM�������ד��;k�S>zz�aƮJGf�f��ɥ��!A']��0j��G1 dA@T Hjp$��0d*ɐC�`�"�ki�%c���:��f�]��Q7�>_���!�Y>�.d��x���(E�@����H˨-{��\/�Laa�@���D��ɠ9VV�)�)�Y+&\a#�C�W�3jH��!��BD%+XZ�X6j����7ﯧ/����]_w�wp�i$��uO��f�46������D	��EĔ*�(]�SO8����9lSr`l�1RlXQ���J��i:�c��۱�7G>����1��Jj:���J�"a��+X_�1a$+���+��2����X2,l��`� Z߂�#�a���t�� �V �&� Ŕ "im��
������s������x�������Ф�����y۞�
�oyD�^;���� c�������΃�W��y|����g�y]���>�P�[ZYEz2WDu�񜚷��(���z|�`��˞g�T�y�5�t�T7%��  2P(�|,&L1�(;E�8��L�V'�*LQXr@*�n�!hjZ9��H��#.��X���cx��k~���}V��e,���x�RLjb
1����S�.ny�-��g6�iMc�":)	�H|�(��j�ɐc����>]}���p^p���fVѻX6!4,��J��\�>^5ǽ?�Lj����KGҀ�ż��a���$H������E���D&��$p?��@��� +ˊ�xlK�#�)�����\ˢ
M5��<�.ǵĀ�f��9��}}��ٕ>��/R�Z$5� �p��S��vc�S��<�lE�  ��pp4   !�c �'^�L�I ��haK��y����1�����5q�R��y���,2�L�=������Y9����U}��&4��sR�B*�ѡ&!0�*E�-jAc��%E���V���C��7�FV,�c�����i�	%	����SGI�&%�dtZ�2����+�����[��k��p%2ue=�"B�������Y���]�3۞��Cሀ
*T�bR
"�1��p1Z0����qn�9�L=|��u���(�䙄�Z�E�tK|]�������ů����"rŁ�yo��Bh��d�$�Hƞ %%%e���!+�����T`�\�
�G��Ғrs�cEOe�Z*4�Hi*�tN˽������s~8�to���p�@�a��WT�]&��}��g�s�ϼ��S��h:E��3�
   j0"}[2&�@�`��jMV��k�����^��n��8��Ix�%�,�Y��4w����\�������_[Es��|d�;� J���z+Z��`Dº�1����r�0NPVJVW�lވtY�f�^���`}H'�)�nUg�Ot��^u�cAg����9�]�����Ӎ���$T��]a(l*G�H3�\�����yoZJBF27���T�Ԩ�H:���~��y3�~8Q"�HPH�y� W�З��m޼��9PCf�x��RG�h)ze^tN�M?>1�nzk��$�t��7n�'<5V%RZ돱/�d���z��H	���j�=��?�H(a�}�Zu+7�A2o:��n�\j`�mZI�Q��y>x����/f��h�x� ))"�cq&�V��Y�ٯ�|n@AoEE<�Ä���8�p$������Y���w��j�G���2M!U��RkZ���v�֡��6���^�cHpi�1���\f���T3�]�ޯ�����P�ߤ����W8�����M��:*t&`M μW��;�� Ea� �nUVF��ceQ�))#ၴ��|Y�e�:�m	�U/{t\߿��cN�fg٥��$�l���PS`b6�_��'ˌ;�1h.1B�k����'��4�Q@"� � *d���>��?޽?���ė��.���� ��v�Ѹ���p͝Q���zQDJ������;���s��!/��ԗ��֢a����ʞ�b�h*<.�.I��`]i�0n֩��n��o`�K�>"% �WJ�(�p�:�!r�N�6�9ܯ>����ʸa7Co"\FAKa ��3����m����@��K,��4���S !eP+�AB��=�Ƿ_:��K_�EVV ��"Z!= k <y����=���M[|����\�=��J���-E9�(�:�֬�k:�߳?V�k�����O=��,�(l�)�U��s���B��H��U�T	 ]�Z�W�Z��7Y/C����;t[�Ln�|ȧ�����P���qB	rblz��*������k��,�O��83x�_�������cq��3�����PA�6,x~��޽�|x9�q��E�Bb�@XЬ5�Y-�t�:z�D�dE�iǩ��)�����0�nꢠ}u�����ߧ��M��{��_�_ߢ4i�T�q�Y�p\c	����
6����I�#�A�n��� R`�#�y�����<ǏzC�e�D�j������ʺv������t���X��̅��1��:8 2Ȅ� � 8�@�ϯ��׽���c�,G+B��AA "R,bⲀ�8�ɂڵcǣ�+��S4zw&�q�`J8�x�b���T��~_.����d_�r4��)�P�%�x{�E���.�*��ﯸV�}��ЂHL
)��#�4���f8��y�e����]�Y��F<[M��]T�G:�׹����N#<ҷ�A��a�W��`("(J�( *H"E��r}�?}�t��s�<�� @aE��^w�Lړ�6�$����w�Vk�=M�S�u�B�|W�t�J�+,鞚q�q�u_�\��D�<��-�K�3楈��f5��\*��pE�݊�2��tI�b	���@	����ᢎљ'T����9�8�x�������/dOh͍�
Nlr+J^���;2��6��h]��U�Q�%.�x���Xjq��SLu�r�!&���dd/�����&LF��O�����糯E��T��P�M�!V ,Y�H�B�4+�;G�z��茖E_��{�(���K"�"�J���Ǯ���oN�ymV|�я�h1�y�a������� PC ,+�:i(�(Bpҗޫԭ�yLa�}���?�=��߫����|��|�˸�Rc'RYj�&Uf5?w���}v�Y�E��x3%:�)c o&4娏��\ �d�(2�"C:B� �K73�S����������=12o�sdH�0Z| F��0՞�Cȓ��Ai�v�{<zx[��촮�c�&��-������RP����濝6O��z7*��폷9�0�7=Zh�2!��:��-��A	�:n�
fq��� Q5ړ�Չ��ݓ'���G����믿���^>�'�}{� Ml*�:��>��y����aM�m�KL��-)��IAc� ����@xD8Ǹ�N��(	�$�Y��|<���_���?N���k~��K� -# :��]�3S	���Iv4yҞf�����AL���ho\U��eF�Só=;K�
�F��>������<n�����Ѣ�����?ٗ���-[z4����{yZ�xP��1Z� �����UX�%Ph�*�H�{��,V�Qx�K�d��_T�x�����c�8��ɟ��S����u�k���=�������pOt{��+=��$t�"� �d�x1��!`��`��"�@*yT ���ت%� dR��j=��L51d�D��("#u� ��T�ݺuÙ9���o��Ϯ�!��y]f�\l���x�ho������/�K��Bv���t־x_���Ó��m5"Q��@ґ)���,,��Tl�J��Q���n�Y(�BLvY@�V�/u��_�y�u+M��?�|7CX��ƺ�u��8��?����uy��r��I�T#���R"Ue� 1�d$��%��DE#��d��Y�T��F�ޞ5�%U�%A�@�� �"���A��[U���B=�6;�9�����5�<��~�]��=�9�]�M�~zp��=�������ů���D�����V*���֠� HӲ��%�� ��@�h 0
Y�VT1"��R	�r�!�s��^�c���g���s�>�5���)��9 ߡ�������/����P5����� F�ZM0hBQdH"��HJ��dĢ�TR  %�!�so�Lh�P)R�H����J�j�D,e�f�#���+����͉�����'nַ��G˟gNvQ���������ۻ�N����CӰ("�h7r�� �2r�5`�h�CD&� G����CP�� `�
X���\eP�sN��Z̯�?�cǋ�/2#��D��?����mo��x�}��?����Z��ں3�t�(�i�JA�QI�C,�� ��DD! ��� )ƀ�$Q�2Z�j�ٹ;*JJ�6�R����"
F�J�HJ$��t�CH%d/�@�j]*������x��y���٣�|8g'���~�z�_�~��N��/���
g���5S�s��b(��H����(�Y���J�X�ˮ��  ��C�
����k*^�_�v�O��T��Ȧ��M��ִ��~�����?�湽��
T�Ҥ�A#�X�"�LBW��z���� B�))� �IB�&���@T�F�،�2�KŦ1����T@B����#,��!��Jk� E��u��n'�7?8~�0y����tШ���}��ˌ����W�����%q�S;^�Y�e"@
��4�X�H��@�  Lָ�Hj��"��@�Ųί���
/��Ƴ�OZl�3�ɷ`���v?��/<�yo\,q�LLH�z� 4��D �6C�hXB��.O��Q� g�"f@�U)�JQ�3;hJ��EJ@�J\�	+PB1RPnf�6�X�k���R���#�Zc����m^�|��z|��a�o��V#ђ�Lw����޿�r���+�K����,8 �D�DWXbq@E,`We�+.�ݒj�$ ,Y�J
(�U��II��,���q�1~v׫���~���"Ε?��U�޽��~�sO�I��}��B�5�TA�&��5�!UZ�BS!�	!T2�( �% IG$]H:�j�[�����:AT �D!Q(K��E*���P�j����(ۈ{e��˛��������Oߪ����8����&����������u;�kuZ=�q	��%�RG@�Ӣ !��22 � �AI�,��fbY�Y��S$"�YZu{�������O���*7��H��ڧ�_�ko^��9_9�J���am� ��Ǹ�$��fAc8� 0�H@BAJ� ��4E,N�#���J���!S˔� @�I�(/,�hD�
��(t�h�5hT�%:����n0t7�y���-�}�s�f���۲��)��J�-3u�^������%�,μh6�MR1[ZEG-eU�f�	@��RtD@@J
 .:���S�9"<����x9.=���#���z���~�w�y����'/<���ܻ�4�Bpɡ��e���Q��� �X]�X��B��@�%"*B ��7���Q��]ن�,l��ˈ8D�؃I@�SyD-hA�@A�2�-T#6֡VJ5�+L3cٱ��R��|w�&���2��p���$^��{{�$�pu�g�����k._�$ņ�(rdH�$d���"�����L�]� @C�  \!���_g�R��ޭz�g-S�R�xE�������s��_�5�25@�G\=&IQ�A !LJNRV c�Xd0 A "����'&������
�C6�UHd�R��ZVW���I�H ��)T��%��m5�N�`�R���P����ӝK�<xܗ�_�۰oh:٘���O�����'Gշ�_�T���L �d�X��%�E�ƇбK�`JY,VR�UX���H��Z�w>xy���6�[��I^��L�Z=�|����C����F���+Q+A� " �r]�]���1�BP+TD%!�8=A�N�AՔ�W+0b�C�(�E����QDc!)�H�$� �"� ����p�EѦ�P�UU��l{����~\�<|7{�g_NjD����P]�{������K������j�4a/�� -���92�$��QK^a�jV ,8����W������y}��5��i�� �'N�������o��7���t56mX�W� ��EQ ���dE�(��I&BaJAp�L�� �y(��@]q�J)���<!�=���%�Ƕ�H�rA��(($A�TI"I���F�T�x��I���Jc:٫��i0!�՞O��7�տ�8��w|k�L�P,B&L�Wz���n����ش^&�S�'Q��e)S� 3Y��L4`%eH�.�Q2G%-���>_^�~�u���Ue� Q��k���@�3�Z]QN�PqQ���T3����D�5#i�D�a�b"PX�i��@	 �d`D�p���,O�;��0TʆGJ",H5
4Q�Td")�@�Ue��1��!�D�4U��]���Ԉ������a����\�/=�nX	�I�{�GB~0��j~e�ջ8���Ūh(,��K&Y�l+6�R�t���E;0 ���s�@I^��7/�WB���" �E=�ǷW��d
��B�$�F�"�rh[⤱j%�
1"�AJ�7�H�xfL\K@ b"����c.e�[�t��FZ�����HG	P	�eB#��j5N$Q�P�4�%UE�F���e��;����K�ܣ��{uk�c�΄���X���t�������'�6�I٥��+^�0�UF.�"� �,��@h	MOZh\�L�3��x�2&UɈЖV$V�|��x��X-����FmD�Qb�5ՠ@�FT�����D��8cL8�1EC�x,*@!bvd�y<�.Q���0^kMH�H��NPcS��j��,�UL	�Q�
�B�`�`�TA�СSVd�(Ew��rYn�������;?���� ����8�����V�\s�L�;/�%�H$�tp�VX��"qm��(�rۖ��i�����ܹ:��+3��4U�Q4��/W}���qp��VD�K�2����k(�L�#����$I�$�R>�!G�f�M�E( 	�$� ��!B�u+'9p��
��Z��ȍ���j@��Jbd;!UY����h((5RS�9����tQM���>��Iw���3����˦�1T�d�+K!����������/���zv��-Ê�N 
�]�P�IRVR+��rD�gX����[�����X���L]�>����|W#R�p��e�#�D�V���I$	Ć�@Be���
JWT3
���� �G�I3�I�!I8��a�g�_���:���"}�V"M�"6jl�(���21��#)a��dN��R��!S'� �B�T缲s��~N��o�����P`FP��9�v�vj�y=�-��1�J�r*�DNX�F8��$!݊�Q;��Y���̙�Y��n�O��6Os
�#|�֧��쾹�U-���@I55!1
��	��d9s�Nm"\�@	�E\9F�!���A "��R3 T��oi=���Ws��F�E�.Bjb%�Hk��FT�9�"
S
���ɦ���|y�����?��6�E0 R�4E�H�Gs{O_;f6�'���A�K�����Y�p�/���#|O�����5���Q66�r�,��d � {YO�{yi��8�ye���x�*���%�x��a=�s�0GSTKNR�%� FL ��I�Hb3���f��p�����0 f (aA0c�01�*�C�q��A?Z����O��~å��w1:^O%�D��V�R�M_�DD�
%�g/�y�/���\�}X}���`Hd�.k62�Jc�Z�6q�L�}��<�wk�ce�X�cR)"���%������C��E���K��l�K��!5�$�jU�N���ҋ����YE�R�S�$FD��o<���:�8o����Qcסwc T��#% "ఉE����p�Ɂ�KY:3cb���<E�X#�W  � cF�y���:������G��߼��W��f��,���!��s���ZB��z��l&�Z��D��擧y�t_>���sng��;z��#+��6�iTB�UjQh��pN�<G/���]�8�8z�͝E ��q���f��VV��,X%K�d�嬈�2�!,���Bc���SѺ��^�8�-��В���>�����6�����XP�@['E�L7��MLD����J���A�s\<d������� 1U�-�   �$�h�:�������>������z~o�����i����ݳ����xdq��Em��	t2�g�s��#�Ž/�c���6y��e����]HÈ(�'�%jf��w���*?����B�N���^������7ϙh\��VGQ�*����B��ɕ*#Zx�������b픓�&�R�/�·�'�%G��t�j!c��:Du�F�M��	���4���'�t�������ykn3f) �@���b@Dؠ�oT0@�@.-U�j������������>��G��i��[�<rw��i6�m�4�������֞�nʕ�͍��������e�\/Nf�A
&�X�0jG�v�*Q�����}�˰�y�G�����h��7?���/Ӻ�I $�j%	J�HGU�F;R-�֪g�����������f�q#Ϥ��tp��Y�nf�#�0��� ��PtK�0Gg6M����������?����6� R&�cFt*��
&�2�~�,`��l��`z���u5��ח�}��K=�q�Ǿ�G�u�/�?Ο���uᵛtu��9��f�<躪��ֵy�L�ӻa��B�)�;� T�	FCJ��Е�{P�zq\��c�����r����ҽՁ@��{*�W?�����0�  �3�lϠq\��D���yY���ԣ����$�N����Y�����"MkE�E#T�21��T H%�M���.G��y�^��}y��K���⥖�� dD�2�_B�E� 5F�@B�
�C�^���g��1ּ%�(�y�3�yV�Ǿ8V6�V�&�y�gu_ۮ���u48qYYǒUfN�@��v�	�h�v)�DQ�-64 :Ѥ�����t?��;���i1dX�;����7������(.9%���ŤtF�M3��3sLM��T�(1 �KK���z*f?:��fE0�HV�Q�2T�;6:1HY2a�#�;4�}���V?-~��<�u�u����L��a"P$�A&�J`�,����D�e��%������饄��XX%��cƣ�{u?���)�.�c_��\��x�χ��m�������~���*{B��3a�1Q:\h\$@��i��:����e~<��ˇ�#?����2"a�f ��qɸ���:r�Q�� J"�LX;�E]����Y$��y��:��;��1���(��@ci�&]�;#S�40#�j�(2a,*&�΂�IJL��9{�5�o����gγ�������Zo>�N^��.��-�\�Y`S�Kb���l�jr�u�7����x������i\��5ێ�u��:.2g ����������ɫ��N_�vi˪����=m念��d��<63Yg�)Y:5cD@GQLKE�Bm4��.%�VYq�c�r�}z��Gui:YdJ������:���PyK�aP$ ��Ћ;�!9W�ZM�^8���c\؞-��Ĭ}��H�M�]\;3333iF���ĆM����l쬄��0���$%{S0�>x�_�����'?�}x�����ϟ�����o���&J�b�5��2��Rc���M�?=1d��|`�'G��8s��:�=�T�����|���Yw__�������u�N�?�3���3���i�b�`#��!b���0abh�TV&	#qP��h]����P��M�Q���|ﯶ~�x��%���&���"����ޥN��Y�P^�)�:ep��x$be�q.���K�9�ߵ��SZ����H����D�jugѨ�!&��#L��
��I'�.��&k"���7��[������87v���yy���q~�*�ࡁ���(�@*���I�,�<c�t_xV�}���w�q��rGӖ?���%V=��շ���|�2�s��, �K�� Q�щT�a&��fH�IH��F�'���0"(M3-��C7��-�v��'�a5�ݛo2Bq�SnNA����N�MM�:W�ܩg�x���)���m���t<�)V<��r�c��(�(Čh�C���i����eW�M˚92�w�^�ׇ�_>?������~���c~r���P�a��g�� &��!�BN�6��~��3����]�W��q}i�Q����֪#�R�M[��g��1�Hp��H�Q*�&�4Y���C2AM1B'���23T%�J�3Y��"{�ȏN�t?Z��J��U���e�W��p�������H(A�Y�
&W�g��C��e*B��"�Dj)Ҷ�ஔk�ގ]���Q]5�xM�I�Ť� ӕ�����j$�+��,M��x�w��}���1��|��(W��G�Ab	8`��|L�`']wד���~�9�u���gd3*QsgR�a�;��=�����W���0���41aИ�0i�����C��#�498�x 	�4�Ǌ��i�8��y��>m�/�N�V)�V�,P�������C�&���٢�-Ϡ�D�N`�9����e�N\�t�@,b�Å�Nu���3{Z%�؛4��4If%t�ҒYˁ%+=�dG���IBbpٙkh�yw\��^;�~j�ö>�h��yWqΫ��h�L
- ��B�46H<�^����7۵;>�~<��gF���ڷ���1��������_�v���Һ�BT
�X&`� �bXdD��Q)��pCl�6�lC�������n��=�|3+Uld��N3],M����;ׇ���Q��%��������C>V�;'�f���)o͌7Z'�L�r��B�k1o��d���;<�}%Y���E�N��b����d�Ya��f�F���\�W�ϝW�B�,>9xՈ�u+�HM�	0��`	W�&�v�]�½�<=��Xڋ=�~Z�۽#�ަ>�׺��������?>�/�B�8@tQE�Ц�D�!�	�@�$�(�:fHz�j�	�X��Т�5w;RC�<�󬞠�����`�L�f�V�����=�2�SQeJ2��)�Pqe���秗���Q�q&��n8/�x�l��h�o0�!��l��*C	�=��Z)-�Z9H�HƵ����s�f��V�&kI�#7Ykrm$� �$	�7�&�`*&�TPXV�rX}x=�?���jE5�jmd?�ΩV��=;Uը�V5Y۳�r�6?�ڶ%� 	B��D IJ�E��L� )�$��8���@�1�4�ј�;h"�Y����5Ϗ{����7���<6{�H�z����x��N?��׫���"9�Ki�m�}AE�s�۟���Wu�Q&�H��q����t����{ٸ�A����8��"jGYf� BY"���$�c�X]x�=�b��ヷ��-"�� AP �^ȰT\�bh�ih�Y]���g�����7�������c/�|�ԓ�bJr�ԏ^����9Jǣ�e]M')�0��*�F1$�	"�(P�q�.��4I-#݆�I��$K%��B�4A��#T�x{���|�����Y��եf7v��8�괵��_Ts����__]�"f�55����b�Ő��Ο��qeP*R
l ��J��nȭ�~���Ȏ5�h�H*�JR��Sڈ(�b�l��m�F�s��9W}�����f�^KZ�,#B;fAIq�MY�(g}�/��ux�J��i��YV����?��M���z�,��-\v�GVb�+�b%��ʪ���� �Ic�"��y�H eB  2
�"mzY��� �ƍI�@h��`]V�;I ��$�DBt����n�痾��~�Tgޤly�S\�x��M9�ݏ�]��i�mQ{�-ِj
m��޹��_f=��)\(3�i�-|��:g�ɻ��L��&6�0(2AB��6�,�&*N��@$HJ�b�Lq���^?�o���KZEe�p�4��`����%��c/�!X�������j����y<�������I��=�X�c�ݷf���wE	U��XǵQ�뢠��
�d�2�<ቲ�$�$��(j�MK@����FqHo��$�ttbB��m$R5�o;����>~9����4�,޻ڣA'���,XU��u���ś6f͐;�<�@��\�jt�׫����*�2�R�=&Kr�=���Z�~Ic#��W��BNR8H"a	j��%������W>�pgvU�Z��:���y����&�	�	���|W��t�E�������|�ڳ.�aF�3Ϟ�����og/ה���@��l�o����_��^�zx繺{�E�۸� 1,� !R��VH	$I	tf��$i��1F�u���$��x�B#;h������?�)����޶���%�����ү��y/^?�kw��L���.�D�]�~��}\w�+2dJ0�V�H�$��ݣ#�cLb���4Ү��H��ZP���F)��$[T�*��w�)���_��l�Uٓ���銤s�$$�!�����*�Y�^au�V}�bNӏ�S�?w9~R4��Q�v�?_���b/��i��̚щ��iy>7��r���P��_/g�cܭ��A�+�@!���:b�22�FL� �$�Nh#B�i��I��3&�BlV�+�#_�օ��2`���f���j�Bz]wF3}��Z׋[W?%� A
:�;�>�o��U�Q�
 a�0��q��e��ϥ����lX�H[��vI�F���,�� p��$D%a�5���>z~\�G^�`n�geXK3�6��x�P��hq
�J�T��0�P��|��?��X��:w��ہ�������W��J�Lݛz��G�m[��8��/�o�6��;��*�)��-�y*�9�d�It��Є�
4Q�n��Ը���L�2�I�'���Q����q��|��kgͨދ6:���A�I���>xv���>;����*Y����}S�0u���C���N�>َL[p��4�ILDl	�W�H�bH��lLTIѰ�u����~�<���c��֑NQ�,Z(<82x$2 ��0lp���3U�tZ��ǻ����s�_�3n��r��]���`k��X<[�����,�n˹����:մWO��|��N.�MGaq��|����I��`��2Η�>^�J�'��D	�6I2N��q�L$1��d�^S"���r�*��.�3?y��f&����IFI� �
�Գo}pk��0ڳ�iÜ��̰>�Y뚂(�=1Ó��L�;��>D�F��	n��c}��hJ&�� R�@
R���U�(lC���uo�b~��ɧ�<�u���:	���2l��؈�$�Y��D��&Us��w�����_.�"r4|\�Y>~�8vF�}h�Ku���d����]���+�o>�_㺳��<B�n�7Sk��b��#��+������u)U��(	I{B�tb%]w!�wY��1L�Ĵ�.�!��G*q��/���{{%b�ީd�Vp$X�f�Ҭ�������z�6͢J	��|?��4�����L��9W���;GU�D{Ȍ�X)8��T~T�rBb�"#�$�C��(x��u��g}}����������@�Q*�u=c��`�`"&��Z<$�M�x�1�<
�`��/�a=������k�#�)#5\J�-��JFf\��R�gfC{��2N��C��75��\\��<�����]�$ݶZ�Sv���
.��k��UͪW�iӰHLLp ��Hh�0�j �!NL�#݆b�h�S����y{��7}�K��֡vl����:�F�N�9{��[v��k'L!S���{�o�&b�)SBP�p��z�Ɣ�I^Q�``�S� ��D��ꆉ5�m�r�QE� M�����k>յ�XU���)$E����F0�����qIQ�G���x�:���V9�-����P����E�'�t��3ͷ�%�����_\�����������r�PsG��N
],&���!�4!�&*�tˆ�dI�!�6mOH�iܢ$v���*��*��N2�λ�?x�+��mβe��Q͂�mр
�������x�R�)���?���5*�T&JP�W𲲕�=����NE!8v<cCj��]�Qdb��Ը�DB�P�4B��rn/l}�����W}�]�+.���`6B[M��VrTuF|<h��!�&fRs�^�z�ޟ<��[������H��`-L�ĞU�`�;Y2ZĊ�0�������U��z�����~�]��Kq�e�t���ÛGn��.�d�I�Ҧ�	tQ"	@0�qb��&�����j"Jzm� �A9�}����'ݪ�U�z��Բhk<�A�[�ͫ���S��d�66�ɷ:?CjC'� �LE+���1�<M%=X��1t$m��i<�o� P@Oi����*�׷�Շ�ݮӇ^rr�3�,ա����7l-2f�d� $�j�(���ϒ�"�OW�p}�,�����r�yVT"=AU�R�E����z��������ٸU�\wN���gq�7�k�צ��S�GS�r��%1H $F�qBiCC ��#������Z,�.����������o��{����h�co_�2⨗9l�O�s|�v�9�*S�7��D�ĳ�!Lٕ�<�vw�W���%��C��Қu�Yf�"-	*��� ԕ�4�@jW�o�ڽ\}�%���2�mo�֖���q��)]�0��O�d�I�-�[}���lk'����IR�RO��x7����:X��R�:DГa���eСD��Ew�%Y$%q4]���SOЫ��V_�ah��>xn�x���������{o��ڝ�dj�V5t 4i�IӲ ��8��"h	��D�9qԘPD��r����������(�n������I�����.��N?^��am�V(��d�����z%̊�5�|�;��@o���FA�X�ص㘘�����Aa�+J ��ٯ����������W��Y
��^�P"vT9(�0uk��V]t�I��i|��a�ݥ��ね������Z�˓�kAO8AB!A�Ds�[�'YX�W67� �=ʆ�r�=�m�����nuk?��|c�����4z��~X��X�[ٺ�5�X�@�k�	�&��i���8	��`R$4��"��ީ�h���A8t]�<�U�鱭"��uW�N��ۇ�cU��|��C��K�)��V���4�,ˣ�㘕��Kt$�u�ca)B˄�Fb����X&bՋz��1�y��^}~n�ސ4@e��z:}P2�uǪ��n<�K?Q��O=�>���x�X�I���.�Vs~r<V  �<�	��"D%��@��r����ű�,���Fw�x�����0���ݲ�'�����\֥�Rw�+}�ahk=�%�dI��6]�IҒ$q�
�@aX0Mʻ�n���9ȹ��L�0�ƩU����3�H#ϛA�G�o�>��KP6+�"�^N{u+�/�9�c�	�������H;��
�)�D��I���ҤZ�W�{u���_���zo{��w�c+���R��oݢ2ZX2ј4�1��7n�\�����<k�G�ن-�nx��:N��L-j��� ���S  ���

I $�#�T��RVi�\���ڏ���a_?�n�g����ۇ��O��.�i�a.�)��i��m�Si�ݤR�HC�h�hB�$$�M�FF�L,���z��W�ڭRX����s�.�u++��:�٬����ejcI�KX�;( *(L��{NX�59��:�%:�!u~Y1K�
"��R٤R%��Zغ`!�^َ�G۵���7���=_v`n\�(�ԭ[K�n#=2��A&&f���������pe���~�<_�P�K��K�åVR�`�%�� `@�`@$7Q)H��i$�1zԎ��'�8�����������ryg/�cuɛ��m����tL{>�VN-B�����L����ȒDL�;!N�:I	 2���(�-����~���j*$]�.=]4�"�ƲTD�9:g����&��{�G�q�0-E�^܎>2�܁'�U#�u}�D�ڒ��1�.H%�T)�"��e���^>��v���}��ox�C5��Di#�SlF�㎷�)��z��&c�gu�q�X�!�g׻�N������e�V| ��F��  I�� hr$���2;?�fx`���e�l�����so�4�}��|�ퟸv�?���S/[w;�mP�ܤaX�e�KN��ҡuL'��^�� T
J��6ZJk^���q�G�"jQ�YWW�w-�7�ԥ��E%��ZYA����!��������U�����S=]:�tIHl��eJKbS3l���8�$H�6� @��:�=�S���_f~�c�ʹ�T�˦�$d�;��w�ЇiTv|�[Mq�7?]�_���?�+����&��oH��7k�IO��H#(���,%Z�,�O�z}a�8��p�X]�/��wof�?��f��g8y�kx}r�2��W}�&!��D�'Ɛh�	q�&	4��%��dD��y�ݷޜی�L*>�mt2^Vk)�-Z�^ztg����}��q�5���S
w0���둡`wAӯ���;q��FDF�,��U�DD�����D8�q�#J��e���~;O۟\�~;������!�)T�w�f�-����-Mܩ��;���ә���7d571 �N� ��b9ưKn$l$I�E��� @Ҳp�@*�Q�he8J���M�����H�un��>�햻��?��͗���������?�q����+SɸCLd�%�["1�Mb"�XI�XPM�u���t��`O4K�|��=!�����������pγ�EW8@T��aED�	_�˩�d$9:��Q���2���2�t#��F4 
�:!&�!��͘�����~�ؼ�z��r�䡩'Q�Ti�����v<x`C�Q>��Ͽu)�����~���g�����:�����K�C�� @@)�`P���f�"W�`0ɔFB���Q�z샃-�h^������	����܇�k�����?�[}oλ�e�L��	�aX�!{�4�B�I�DI+��L�z��O��C�Jf�(G:�Za��e�U�|L��g�&����� �d ʫ���,��\��rmK�tj�X֩����Q�$�I=1R�8���O�v�}�%�~}������R���^Qi�8ȫ]_�bZo��K:����^��~�΍?'|���}���W��Mf��0u��",
A� a� AC"M��.��3�H !���-��y�8bVRX�� �j�Z'}6cڸ�_^�������{��mu�W�]^�aJ�q���`�4&I�Az��ƚ2����� 
i�������u��uo�^���p�窒q�'g��y�G'2�	`�5&N��Ɉ�Wo?#�������54#6��T'΢�(K�*D�-��IQ\zk�j}݌�|�~_<ο���>�om�'O$���G]uFQ˖-��p���8�w�1d��</��K�D����'�����o�:��`a�0@Ad 
E���0�JVR��1��QW�e �ҨZ�T��6�搼9�w��v�Wg���I����1�C�L�ښ��>�#q�� kU.��
�/���.��x"�������L����KhӚ�.=�}��}I�\qS�
L	���wh�.��s��Y��fı�k���Ql�NBg"d�E"M���\����/�w���狹\+�]�D,�B˙���Qd�E�����������+�z_{������|Nz����ß���|[=/Ϲ/�p�8@ `P�H��`X$'C�NS�!8#A����h
�� �b��kʪ�Ų�./�}���h��}��w������jǗR�n����I�1�!�`$,�d��$iآ}{i�����z�-�a�H��>�r� �M5�*�i�:ǖXϳ�թ�
�U��N5�f�<7�ͧ����E��[f�EF��14��!$���F�-���J�:�O���~�-��'���\n�NO��F4��B�fݕ�f�Ƒ���_$!�.?�?����Z�q.���t�u��ߟ�������[���}�6�H&&��   P�h!� L
�I��v�W�����%�Q'5�Tm_�?~���K�GnnC�:��^�Z��Bp�L0b�Ĺ�Т�%E���H*�"����_�`�jQ�w8��{s��Ɛ�HG���X�������U&0t*d��@e�nƚ�>\NOi#�������ܥ�����$]�H��bI��H<����y�9�X���	/�n�7�!�����8�#��Z?�7����?>��S�AM�=�o��̇�m���3���������̟�SP�H�� i&X$C� �C�E�@KѢk��ץnL3�,�@�+�����E2�����L����o<���>j��֫H�f��[�-E��W�C6�"���T�^�>}�����q��>_��g���ȝ��d}�n+Pnտ���/�����+7�A����t�c$���֞�d�Y�[��<"0t��R���E[Z;�{T�^og��>����}�'�'N�顼�(�@��#G���h�;�T&XB�g��������U��N����������g>u>E���#��D�[	 @2d��A"!<]D�[���944�t�B��D	wM��c��ʟ���s���<����}��3/��W:麻g�D��C�"B=FX�R5�ir~�}����ڃG�G�}S��^G[���$ᄫuKպ�TJ^ED�).t������G��S-8�%J���! �Ѷw�͋A�j�8���S���~�o�\����
��v݌�CV���(����N+��o�$u%U1�~��+�C-��(Ϟ)=�w�~�e����������PH$ $d ,ePR�f�*d��iaHn�0e�U�QS��ElfąH�I ��{^����=���Z���q��^�e�9�=){J�����Q�Э����Vk�_sw�\��?�q���UR`U�'�IU��6+�2�Y�b�[e��4?u�h�D�5y�<�0�ն���F���J�_�e�ԬGn?{�z�z���>��y����[��� V�#UԚqZ��Ю*f?���{;�K�Z�>Ҋ<ٱ2�x#'���;�~f������ �
�NEQ$��	)��"Sp���ɼ�_Ni�r
!��m��CB�x:q71�Ⓖr���_������'�q��ێk=�h�_~���:=􊇇m�m���6����h�3�~������q�_���?U�.m+� W$
Z�������T�
���a� ��4���J�9��>Q"-l�U�R��ә���@�ņBI1!AqL]��|�����'����;�����_P�cX%�����*���ә�As�w�_$��z/zw���c(lD����ݙV����@�8@�1@#`L%HM �E�`�����AEw�
XDPFid%���+��^Uf���������������c3��_u�ۚ�1KM/+�r��f[�B�>�͎3�˛���7?�LL�U�Ҁ�����(	b��Q&o<�ݴ!6mFἭ���"� ���V�t����!( � �@����۽���{�?��s������rQA�KA�#�u�t6ȆOñ��s�v���z�t�+3������AL � g�3�� An�"  �(   A� �$�hP5����qV��N�D��ȐK{:ja5iWz�J�^�������|�w��?��/sNrO�����RwO:9|�>������3�[�/���u5��.���j��}Q??M&O(9Ҕf����)-�״N��+���
qՃ����K�Rj���}r�McžС����T��}H�" @ (�;�VT8ѳ>~%��l��L�P�84�5!dd�.� 4�吓ޝw_�������]��觮����������枇RSI��N*���Q�Be@�:XB%H�׊*���*"�F��Mv�7�r�p{�ߑsf�_PN�b@ 4!�Q�dAk�X�3's�=��Jn��W���v8��'�[�q��Y��|N��ӧ�a����+��/s�����.__����_?��/~~��dH�E�t�Y��Q�*[��밾��[�2��T_�A8T�iJW����	 J˃��E�nP0A� I
FC�(5qл��ˇ-;�~;����AL$)	aQFv�  �t�����?��G�������������+o�s߼���P�D�	$��F# %Q�b�^k��2u�3����`���@O�{�{����������˟
	�!@=(
 v0"�� K:�jl]^r&͋÷K���5��?x��=6���y:y(U�Kv&�ޞz�}�1�~M�=l�����;��x��������t������kr\��I�0��5��JMR8.�b5t) Z I[��4����M߮uV)"��W҄�,.Q<���BR�d��jk������Ԭ댗J�����,D�D�p�b��c�Y���ӯ��������^����/~����y�#o�LƱ:�Nkn(2�A8�i�h��q`/S��H�p�g�k�����_o�98��au��wa!	Ƀ�D	�Iw r�C��e95<����V�'�����]�y�`�]��^��ћ?���2�R�~�m?����1�����|����������J���Z�4=���cˢ�<U(��)Ǻ��@�u&,5��bP��U�GA]y�HI
F����x� � @S�Dirc�;���s�h�?j'�6�wz�g#�0�6v�b��t ggz�����:~���/j�o�����?}�~��pgjD�vH���Q4	J�B�AKX�j��(8$8�t�, t@��P�]��M��<��c^H�
��p@���C"ABH�9�$d�	g�T�������o����������~���J����ҕy��{i�g���pfξ`�t�~[�_~�7�nz�W�����@�L5I��n'm�Ō-kQ��;�8��l��ٖcv�t�%*Z�*'Z�b��Fd@���#H�4E�ظ1��3�8����_���Α��I�(��WE< ����Y�O�|����_{�ի_pϧϫ�|�������~�	Yaa)��6F	�j"B�RQ
��ֽ���^[���&ZD �lg9����d��ボ���>& Q < P$@Q(���A
Qt�H+��g�`���Ï������{������Gd�����ǿW������vK���z����dҩ�5�l��;�RzC$c���8�dk��Ŋ�J�2ƣi�Fi�v�Ff���6q.p"��� R(�D�A�� �ԥ7�z^GF�Q沊j��d�o2p�[R@$P�@�f����~��~��W?��������������\�� �2���F� 0 *Q!m��4Tb���R*U��`펭��c_O�O�}pwfW� � J�� �t��S�<B�@ Cr�" 'AQ:n�̮V�Ų�?��Uo�Wɲ���N��˽Ϭ�=^z�Y�����s�������y�B��&&�S!T�o�,G��gB"�^��Q��!)U����s�e�9(Ln�h��XP+�3�J��f�Kk6T[�ny�Z���:Ǚ7��jc�sH�@a�VArSCWa&Z������[���G��w��/o��?�����%\�I4�1!I�M��D  �"%*��F-T�6*D�D�jwQ�֖Ɩ���7�S{=�>��)
`�A  �B")L&
�R�씝��G����u� �q�9z���M�:\i��F]zJs�a��7k��ǟ�<n.A�"��41RB	���ЄqHei\�^�3���3F�?�vX��)d�xA[5BU�8B���L(ݲ;���}����ɭ�����7��:��z�G.��?��K��w��~XD��h-@	3d�U~��R�-����|�����|�/���<���\�� șt�z��A�hT��1V�$!��a1L+j+
�V��:Т�V�7'��ͬ���y?/C(�(B�Q��  `�!@*B,��A����鋗x����}x{n��������w��ӧ_<e�>#�{́W;�����_������϶^�5��*ITtҖH�	Tڼ�m[R�F��J�A�[�=Oe�k�߆z���0��l�F�i�m߶  �
T�XU�d?���)/Ν�6���{m�c��w��S>s����3=��ϫWZ���Y��w,�RLM��نA�^���7���'?v�����������w�y8��B
�dh ����@5  "J(թ-���E�(Zb)@����u���]���]� J�$�)R��$R�@'=��hD�g����oo�Ӈ䝏���������ӯ����������?�����V!�6~_��1����?�߾N�f���H�U�������H�z��<�յ�J���1I��:ۮ��^��������q��Q��"� "0B���K땟y	m?�e��K�쯔tIK��?;=�z�cח�w�����Z������$��i�>�e{	����s^�_fߺ��'������]��z����+w7J�h d�T�$�&�LDB�D QGZ�qJ��@J�8���mG���&�C?��I��X\�DAA� z��"�@�@�K
X0V>}f�<w�/�����|�P��ɿ9��f��qK]���'�������?�sZ�?�_�X��������}�������&W-ȣl4�U�����nk��ծKhZ�S�o�@��7���w��U鏯�>�����Ç����rGW��X���Nt�z�p��w�v�翴��s7������A?��c��_�o����.u�8����g}���3z�T�8�ͦNn�Q*��p�j]^Y'޸^�Y�����������_���	�1	6�@�T�ʈI�ZL�X J�- ж��jZiQ�BCs.�r�Y�C?��'?bq�d�0���H A)H�Y��-Оh�m��k�|o;�[��}Ƽ��+P������~�����{���]��wf�~�����������y�_�}�-�J�@i��"�dStVK
�A�E
\G���1�����{���O�o���?O~��>��x/^��5��>��0��"�f��p���KG/�~����������G���e���U��J��ڧL���1m�¿���k��\�����>���.��w��6Y�^�ٟv�zo������?{����>�(�H@�5� �$U$)(�0Q l;X�ڊ��D�V-�m�nZ�j϶�a{s�M��g2wJB�0D9` �BA�����I�J�rp�o�zk]>�ם/4�{Z�:�~9z��DM�\������y�?n?yoɺ�����O�W��?/����>���a�x�^Ҍ+���H�nza��^�2�,��`jTdY�lg�����q_}tu���~x�����~�3�����w������"�˖�w������}���c�����_��;^��z����1��gNG�=S�A����a��rL���x����G�}���?�/�����K8�S�G������U�<��~��:�* H,�E"��FMD�@!�(*P :Ej�(����f��zy��rC� `�$�BJ��x
�ie�y����gΥ�}���C�����s���z��j� �I����������ֻ�z���_������3\Bpv�Β�+(�l"6-Z����z#Kh[�[l�D2�[r�U�צ2�~}�����w}�������������?Ͼ���^��ר�� ������{vx����W�}��ϭ��n/��I�ʔ��i~Ю��	��!ݎ��f����e�o]��>s��=� /��q��|<��N�ٷ�+m����w���2F:l���D	B�Z!�BQghQZ��u�  ���Du(����nw�����|�8��p��C ]!
�C�D J2y*��mZ٭��s�x��9u��������ar�a����qv���H�
�)AjrM߼�>���񱖽��x�������io������Ú%b�Q�s	81���ST��X�6����V�B�B�jc��vH�Ͷz���>�����/^�}�}���o���7~�~�7�\�����;�����gߘy�61��\����9.�w����!9FaU ��OT]N����eqq�н�J�
;ǽY����毼<T�����'����ǝk���k�����>]o9�B��d@�D5PAU�$!��`�2���hU�bR��#�
��V� �vt��P�5/O����9�x�����Mr0�
 �v�����::�s��}����r����[�;��4��ZS�o4�A�$	�0_?�Ss�mꫫ޳h]��;�������oyk��0EFU�L���(FRxd��5�z�'Ү��TB�I��X��9��=���M���~����/���O�����ӿ��?���?��==���~y{�N]���'=]8�h1��!�h:A�����Xi��/�2d�D��V��>Z��牷�m�/�N���_���n�l��z{*���<� A4��A4DM� ��I�
�YZiA	�Ă���"����A�Jh�6�@(νq�ss��L~��������u �d�� 9V�)&9
2,��:�ȵW���׾���Z�������+6�]$ǎFT8e0:�Q�2�����h�'\^l��谮l7��8EeM�*}�L;jȺ�\�%\r>݌=˥�!��TN��j�X�G��~�뽬�3�q��5�;g������~��g���{u�������>?���]����4��:��u� aDRB���1��2�U�
����w��y���mo�fۇ�ɶ��s_�u�d��R���H�$J�hb$��P-�"Jb;��"�-����&��	�M�E�=�L���mι��y��>��叼��������='�{�%Y ���f]:���}��s����[�۞���ԝ6��s����K�&�H������[:�d�Q�oW�v�����e�iw+��F�'-c\C��&e�\� �x�}�7Z<���J"��]�����x�șemyz=�auU��]�7_W�����g_ϫO�q����W����F� ��&��)�2ں���C��Rgf�ܛ���ɞ����k녛��^�[�~�`�h�b\ǂ@P���#�PРtU�6Qm��l-	iU˞����բ���:�n:s�����?���_��W���}?2���w�qp[�Zv�������aq����_Z{�/��ړW���c�����%�A�c�}y� iL'((��km�g����cO�ݶV��ѱ8���01r�$�sĐʠ���p=5qn�M�Ou�SY�Ahzb�s�����v�M_�v2�����Q Q��������k�;۩Q���+K�ݪ�Pv9Afk����O���;Ku��==�s��f��m���󆡚��Ƹǉe6#�45�n�e5TT�(�A�U�$j"e�T�V�B�J�PU�k�)Zl7����������g~�_�x^�����?�z[=��������7��|c�����?-/�+�^��~X�����G�~Ľ�ȋ����ݚ�MH�%H��)1RX�*��Ǎ��Tw���J�ZOz�ݡ��=�SG=����,�g�7����M>'�l �U��,�>Ʈ�8��S�����m�� `���ִ̬M���:/�Q&(�A̯y�J������HZޣv4�|�^{�Z�W����ǋ����u�7�U��a$ Z����HH0G)�$c ��2`4� h�RZÊ" ��f������;YK��rϏ^�O���W�����}���u���X�3�r}�P��k߀S�/4n������]�9�%����K����2���G�`kD��P`�&�i�B���[]�G�(�������K%�����J�8�Ρ�i*
�}���a="��z���J��j�e�x�~��S�C�^�1�}"�P�����k�P�r&�d.�����H����v��s�|�b�M~�p�=F	c��5�Ȫ������,��+٭� �8
`��@bS�:� ���j�5E�fD���"h�%j)c��K+�1G���L�<f�w��~�W��?���y�>x���䋀}����l/ʳ�}�����G�5_������'o�<o�&���߻)@�4 �BY� �(P  "���bm&�;-7J,��O�W��R���l޸ıG��ɧ�Z���L���$h�Jn,�����cKG�ZhA�1�R0��~��y�����kn��^�{�F��GM�]��f�����'v����4�&+	�%���aa��3;9��*�"�ThQ�H�QԢ�@pG�e6PJ���")�b,�b�" R���nvC�ܥ��xy�߼��|�~���&�˵\��W�����e���)���V֙�O�a]��;���w�c�2:G{޵W!�\�� �!�(�  �AH� Hh�B���pT��i�F9m=˼�e��Z�������������87���g�'>� (�H4u��ԯ�¸8��M�\m��x{�;�!���ԥ��hrp|�ڭ���ɇ��n}�u����6����2�����ڂS+��}�(�K���j�S{�1Yx��m�lm�ͺ���!	�$��( V%hH�F$�-R�@���`- D�lU���Ve��qM�O����}���ʧ���G�q��Ю�n������ǆ���볹˧�a�_]<���[C0DH$D�d� R�H$��(�Dd#CA9��h��B�2��a�1@d��YN�F�	��,�{���:�ګ�O�c�ґ>%S�D������y��}��k��|��-U,��I�t1���C����|?~u�}�y�3̦�sb8������E��o���a�T��WQ�@j�2N�G�=�5��Wo��x�H#= #$I�TT�b�1�:�������	�DZL4I��T[�J�&w����������w��c��ۉjր�!]{���D�������湋�9�eq��jm��H^e'��% @Z�C �C�)��QW� ��eQ�#`us���eFTj_Z,��۶F�U�r��3����Gh�/�Y��G�u�g���5�8}�jܭ���Y��zK�e���D��%�Z|�p�t�x߿�'����;^�����K��C�vV��Z?����ǧ��<���^�F]�z�82S?��FgK׷���cj� V@2��(B�(Q@-��h�(ԪN��ED�X#E[����&	)�h+)qz`���=��_�o�����r���xK��\maEH�&M����>���9�����ʃ{Kww�2� Ba�"x �� I�D�I�&K��%��R2���.�@a��NW��z$0���S�C���w>����G�]s4���]�U�m�>'��eАҏB�R ���	)�i�������s�y��������R����2<�/�x����y�N�����5.J��=�s�jO��?�����EP" �V���"@$1��H(��J��f�
�%h,j���A���Cw1�-������/zs|����?f�]:��YymPF��D$��en;xsT~��F�3F}���)*2Bite�@��@	� �*#��@Ҩ�O�\ߜϗ�t[c�t��AB����f\�K�U��׷����:V 1Q��M�9����Y_��y)[��XE�F%�DX�Y�ꑻ����_����ߞ�졯�����{wc�\�_�Puu�uK�(i�Y���%_�#e���=��Is��t �&ƐX@j�jE$HcԘh�%
!4jª U�(�
$D��dη��/��������}*�����7��	3Vf�I������L*��|0w�6�n�@xd�
��(�%�
aqH��8f���#�/��el�~�8\�Z�Q�ѵ��3�/�lgG���G�u���)D�������zP�zN���$T�tIW֞�A�ib$���H���n~ls�\�W�?+�\�Ü�&2�u$T��n֎UF���ym�\���e��In�$R�QPM��������(�j 
�PQ��B50�������<<���q��\l39��'\�A6\b%!0�ɬD�5%�)�?�����Ѻ;E�N	! ��H�"A�vP D�
hޒj-t�ڟG�s�����a�O��0��
���:ǚ��u�2Yj/�9���'�s����mX�.�l�ڭ�����yiݭ����!�Ƒ�lu��W�pd�C؝�Z/�9h�����[L���d�Ĳ%Gaۘ;�?Z���z~2 D��dx�0j���	Xh��l[�$&��A�E��J"	�-�@�m5�[�u8�����z��?����
�<R(B�(��f/S���7y�=��>���Oš�J��d:-JI�R�	A 1V	Ej�����Nዯ��N��HV�s���m�v.���q��㚶l�&���~�=?�/���XAlRk�����5���r��^��׈�5�Q �b,���p,"�d�����	/�W�UuV�hv�1�qP�S����mu?�����������.a3��&`�(1�րYTcj�"(*�P��TA��jGZ�D�w��T�<t.'"���T��X3��%�w=����?�ݞ�@@�HE
%
D� D, @ ���\��~�	����<��zv�t-9�4F����j����$��פ����:�:D�)����R�=�������s���;Fid����X��!6�<ѫ�����%��C�6�Q��HE�n��[�f�o��ZI[I�U- fHn�7{�����K�nŭ��E� �B+R�T�֠"E�!�*0����ND��[��ط�����ڳ���(��Y=��<�T=f� �.	��I�x����R�̍-�Q0D"A!;JҢ A2d����D�(����O��W����34�C���G�h�O���^��{�]��	���>��S��V�����7ړm�q�>�]���|k5F$�c�0RLp�� �X�D��8t�ۖ�������{E��f���NA!q'�x�z)�r�Q���QB��,���B[F�f�%b$H]��JA) J	mh�l�`|�����Lì���y��0%��9Q
fxWI+Mvh�����y�\k?3����4$��tA�( �R���}��w�뷿���ܠ�yf�S�h�$���i���v-��Z��V�;�>�Ϸ�O�ܝ�Q٢���~��Ǎ^��������Z9��e��^���n���L�RBҸh���L�HL/���f QKAL�Z5�s��R$����W��}�}]����n�^�2���Q4P��H+��- ��6a�Q�=z�����������K'������`(�2�L}w{�����������'>������.�D��
��F1�{�T0SL�S�!�z^����?2`Jӳ�Q5�)�P�����
�K��i D������y�)�Mֶnl�0
��ח��2��������zO���1Rb#c̠�i�$V��RGV\gXô�Jh��("�Nt5�u��4��=ܽ����z��u[{��K�v��@��T�FD%�h��i�iC�[���������+��'ޯ�䴷�ʍF�k�]�s�f_>9��}ޞ��x�������Əg���ıF �h�J�b(j�چ�)z�7Ϡ7�`�3��̞�\����!-�F0���\}�^u��25�s�eM�ƛ?���z���a�WP�
��s�����{�]���߇��}����D�K�4� (�j$�Y dc�P���L�UfA�%�"�.w2u9��<*R�T9o�i̩E\JVl�65�O�%@�*ZKj�娻�o�߿�[��?����>6�L�t�$ŅS�\��>^n�w��K�<y~�������7�C[�@� ()�����̞��{fcvz�S����׉N��pR~p��VM,J�~�\K��>O�K'�7�419y�������mmJ%�ƥ��|���j�������D��h�D�P��Q��1��#,X5�BDRDJ�9��k�؅��-Θ�V\�,�FS��
MU%ETu�%�xb�Ǝl��{�����?�w~�?��ݷ�xbv���s�WO|��z�߿�����e~�ۏ�������'����:��ɨD� +Q
E��
��L:ճ1����7S<��4��4[k�:,���(�
�J���z��1�Y^�=�,�T�;�����u<߽PC  #�μ|����S�_��/���]F�/Yz�(��"���kDjL�,��bE��	
����R�P�q���#wme�5���Eӱ4kw R(U�j�)���ms��'��x���W��G��/~��?�g[�]gg���!���=��9�ۯ��/^�y���~��������b��M����J��#RE*R�����g��J���T��{�}|=���j�YXvS���=ل��C�s��?�֠��y���Z<�����T�]؝�K�T�T*i�u���g���o��ojV�9]j�	F�q�Mܨ��(D�� Z\�,B��"iV�.\T8�Z�[Ԯ.V�*�[�CR�T�T%:g���T�B(�6-J��:��۝y\��Ǻo?����������?�ߞ�׬����מ?�Û>����|~~���?�������/?޲�uf_ֺ��;�R�m*��تU��J�G��=�{�����{������lq����*Wi���n���7M����LLE�єR@X-7+�Q���V��X"������c��������N��*ڸ6��ō* �"%X 
)AeI��EL�*!@�.���:U�z�jEu���*6Ř��:�DD�J��(VGѱՆƹ�an�G^��?���G����o��O����m?����������������������~����7�Tc�Z�i�"�R�R�ؚ����J�1�y�m?��ڷ��@��&�ҳ��7�rK��yΫ��:j+ ��x����x]l��� �E%��s��Պ?�z��īo��Z�4*lԨX��դ���R���"5X[YE���s��U킥�HJ�V�C���A �X�BŶ:b��4
�׺��n���go?~���/���7�'���_����Q��ۭ/|6���Ͼ�3�/���⧏@�4�=������Q�R��i�V*��~H�UW�&��O�]9��eM	�"�eOEY�Ǭ��"C\Ò���� 5� ٓs>~t���O�G���#��!��~q������U��h��X�BC�F�K��(H�D#)B4K[����P�"��T��P�b�L���dj�b�
Qm�LE��P��j���"ln�ٴ������|���W���_��[���W�uen��ٳw/^��w/~��ɓ����k���/#R*X�%P[��-M�N�=���e���7�g����x�^D�I�*aM�\C�Цy�e���H^�n��irԊp\?�v��>ߒ�+��R�?����[�_o��R;X����D�jTD51EX\`�+\#!���FWU�:wg6�RW�ԠR%M�W,1�NC�������Fdp���׭��yfΕ��,�<��w^�>��G#�����������ǘ��iu�b�X�+R�
B�R�`��fЛ2:��-;���`��|D�D3|6��(y��O��֛*s�� #q��� (�&Y�u��w:�ց�l;��X�p���ի�����39��Mj���b�&,jj�ZąV��JRA�*��M��ܭ]t�T���UhE�X$h�T1�Zh�" �� H�j�� �U�%ܺ��Ά��t���\��0�=�������]�zlZ]�� ԊTP���h�J��Cf�;f�oy�
�M�i�������޳��C8?�"�H.)�P�h��0�KM@��a��n]�G�5W}B�is��9���+�ǿ�_���:��u��ګ�JP��߫(� PAA�Em0�PlUD����z�pYEt�2P�
��R�#C-@�D�X�� �Xi-�V�=َq�}�Iϝ}1A��i��:�5.�V��̺#�b�
�5hU*5�n����(}Oz�Q�m�7n���mi�#���4�K��|��v�y�q���|)_�UE�.�`a)��1��әϷ���"2�1"qR=��7)�K���i��YK�@-^�i%��k�X�P ������f�
{)U��������%$iuMǄ.[�Z2��5+'D�PQw��@т��ֆj�����)�x��3=`��W���S���&�g�XP�V-T�{U�U�J���`JI�Ɲ���/COK����i�̒NDXq��]���ë4�n�f3ږ�P(�(]��^;9����|���ƺ7U������Y_��~|�>\�]�i��qy�K��
j�jA�(,� �T�(mKD)����UA��J��K��%+Sd��g�� ��
@�4m� `A�VH�[Q�P�K��B�˼4q�!S�̥h�U]JA+(�EmU�TmI���%��W�m�>"=Q4EgC�P1���˭�05&�[Ϋ��+%#�%�v���g��o����z�T*N�����z�_o�圡�T}<��1�w	  E��hJDQ�AQ�X��
kTk��ڻ�/wiTҠ�R�uX% Q�v�HZ*JD��*�XAk
��b�n ���*k��A�i��j�*PcAj-�R[�ͤ{p����ƫ�Ѣ D+��������?~�'��9:k�+ʤz��5dB�Q@�3�1%�6�kN��PW��bɊ(V�����5ׯ�5{kK�5}��6�[ǩ�PM 4�J��aak�TE�nƠZ�U�ʹlUĒ:3���f-aI�>���BS�ր� j�X@j��j+H%`i]V"+�� m�*�Z�bQ�K,�
h;*J�y�:��.ܗN)�1mV�>+٢��#����l$�V��M{E��-K��\О������?�kYG�Qޒ�Z@F����1�����3��qӷ�5���(A�VX�VD��TP�AЖ��JuE��"s-V���d�.�|3S�s �Mu�b"P�" :hAP�� H;�6B��Qc/T�V�UE+UJmْAj1�+�Mn:��yk��U�.�B�(
�:�E��V{���q&J�R�Se{��ђ��N[0$O��{�]��I�o��Y<��AJ������͟���Y9��fQ��
�B��A� ZAQ�����U�R�*WeI��՝�v�\�42�El��B ԁ�R�ЂJ�J�m�"�F�RV*`�5J�V��B[�U��B�tFOy���W{U��ݨ����2���ߩ�͞5�E���8���j3 �N�2����X&��������<���+J�2�-��}�������uQ�Y~,�@#D����m����.�*n�R��Fdõj]�.��T�U$P`]e�*��L�*��U)(��,E mE ��+X�"(
�X��*�ZжhU�@�i��*H��]�ң���7Y��"Hڸ�Al��3���)��Z�ѧ �$�T�v�\ʂ6t�@��45��*�m3-���b~<y�|9��u>���m��X��z���o.�'s����� J"��@Q��U�m�Q������*��O�2�QW"�R(�l1m]�T�P� hE��"T�b�Ua;
�j!X)R��RhiAK[$Z*ڶ��]���hQ�&����w��>�xƴ�� ���i7L��g����k�%U�ʱ��,;R%HyJ�bL#�W퍫
�s�dO/�ҩ;���-�~�n��o��������d�"�J�	VhID��V��b	R��"���-rձ�.���4.s��%#�)�}$V�4�� 4b� Q
���*�E@ ť�T�@A��	�P��-Њ��"����T�6-��.�i���kE-�I��ȑ���h��c_~�5Z=�dQ�.��2�N���MNCM��]��-�ƤQG7�����l�G##DH�i;f��q-��s�̅c�iQ H-X� �DE(
�Q	��`���Bw�T��.�
Q�B'U��
���*"T�
��ˀZ
 T
�P��T�k6�(A+����*JU�H�#Vv��J�(m���"=w�����vݫ(�Z��F�c3.���w~��������t����q
�M���,ŀ(�DV��)t����:]\d��$q�Kbw�,ǽ�|Y��H.{l�Xh�F�HH�JEA�(P�nAZj+-�]�g�N�
��R���
(����P1�ZĨ
�CT�1�P�H,��6*Z�.a���*��j��_�f�HkOu�HMv������ǭ7w3ﵜ6�B�M��Qiy�������)V9��ҵθTU�lAN�	���$��TRP��=��80_���;���𨧏+%�������>^=��b{�LR����Tm��B"b+��T�BY-RՖ�h!ݻ�6w7J��6rm]t	L�6U]zD�D 1A(�DMhKl�P[-�++��tY�Z��h� 
N)B�"�~���	��-��]���{N-�DD ��Q���~����鶇�笝5[�#UV���gWK�aACɱ��P��,;��h����>�m~�ӹ!(է&�m>mN_s{�u���u_�>�[(���^X�
���jW� 5����_�WMmE��uEL��&�Q�c��/Y@� PZ�VD!U��X�"��B�
�"m��R��u!m�Z)����m����^���o<�~�59fUI�+�萁�#�����Iϟ����m��u���&R\��8 �ZRPФ$A�II��d��}3=Dg6|�/�V
-�"ެ4���z�櫏_�����/��<�U
�f3�f0RU���T@�X*j[)�Q��Z��q�}l�v]����csg+fU�5Lt%Q1�"P+@��R1EP��V��Zm�
`�*�TK)E�)-�b�!E�ޝ{�\7?��?>Я�RS��)�B�IC�?����]��S����)�# P ��S� �d�]�LjQ�"�h���Z�����^��Fő"S��V��W����O^�~���;Q���"K�jQE)EZ�HW�k�k���VI�2��������0�Ѐ���&PTh�
4
E�"���Ra�����i���B��Ŷ)MA���Ԫ1u:�O�5���'�ٳ��w�6p�:�����=�~ϥf�(q�\����Z^���,$�	`AdaA ,)99�K48�n��k8��y�~�Q�֢V�`U+���Vf~��/~�K���q��!I\������k҂TZZ������T��JlCe6uQ�6\������k�1h(#��@�,(�EJ	8�
���
�k؊T+
�`��V͍�[>��������o��ۚV��"6�V1���}~z?}���(Rϣ�\xJ�u�@ ��\V �aJV)	��e-���#����t<��L'G�5�&����]gk��p���o����_�y�2�%�h!T)�[���B�Z��U��Jk%�Z������(@	��BLE62�&.(�A��� j�J) T [)�6,+��R*T�ZF���x�� 9�b�߿?�q^<�goި�� �)�ڹ����{=>��q������
Vt��B,@ ��N+�H�$�6E"b)h�@����v��Q9礈FA���d_���<{���?�ҧ���u�i\�QE�bqڰX��^��d���-2d��ym�`
S�*���4u�V-(�! VD,@@:�XіF�� ��`	 ����@)"�B���&�.�YWyv�߿g��[���pxv�܏"�V�E�y�&������?�Y�f�`���Y��K� 'jH�����ad��+wr��ϸv}����0;MV����vœ�˕!k$?{{?|���|���O����Ǉ\�5^�4- �*Z�^R�\�eᲗ��v*����%�F�ԧ��P[-(
!l���.���HZ��`�-E
 �P��HAj�)�I�Y1���?���{�W��������Q,%4��*,]�y�ӧοo������W���tE̊��\�R�ȵҵ�D���d�5W�g�Mًj�u�a����6[�3���mg�}�����;���n_�ɏ�����|ˮE�U(����
Pl���JX)\�vMQ�j�����4>E3A�:���T��-�* ���D ۈ�AC���V��&�
UC��a�U&�"YNr��p�b����o\��7�}q�<��If�&���<��������O��N'CO��-Z.�����2,�auCLg�vE���dP'�T2��=���6y�,X��z����|������h�1������������������~W2�@@D�I'Mv��b��NohH��LhP�1D5de:lP�O��
��+�9RE����PDcC;��   .j�c6:�d=�kC��
��/i��H�X)9�����z��E�����yI��w�XCn\������hY� eT��r��>nA�	,����:ٷ�{J�Y8����}x�5~�_6WV}�v����������0~�џO���BE�0U y#N0�Z�nH� �1c���%}CaSM�GfQ�NkDc� G (KC�"({���@I.�355b�PXq�%(TS}J���I�.w5]ɪ�yPh�
�@*�\�u<���<z��n^}��ùƋI���q���H�G+��2 6, �L`	��6	h祵W8����~�mw��ܯ]�~�=�ihn��r�Ë�5��������_��g�O�v�S)Kd"^[�B��-2�$h�1� :�����Δ�e���>VF�9�lE�,����
�(�B �PB�hp U�!��I�� N<��2C_r�2
y����3��6)��Օ�㢂tu���>S:G)7[���#�M�J`08]P8���A��-�T�`d0а��������ô5l�EjW__���2|��y� aP�^��>��ۿ����������چ���;nq�7cGb#��E��A�1�e5��(��
�([�Ƈ"�f��q1F��˂ %$�P# ��@�4T@�QW#��#�4Cn�V]Zq�96��q��	R�  g��������Ks�=�:X��F ����G�*P@ �ڰ�V���(h�`��uX��ڧ�a����Yy{���`?����|����g��h�N����>�՟����i�5�b%$ ���bÆ�#�x�Nw�2��[�*bS�S��!%4ֺ#�T.@��A�1ʖ�0 ��6��LM���'.J�[�`���*�-S����j��Gΐr�3Μ8GZ]���-UA�5�à��������￮o˜�v�N:=$e��:�����
�"���[��$D6��V5�V^m���3�΁�]7���[ߟ|j��v}T{����irjo%�~��x������G�%�_�{C�XEB�e�aˈ��[&U���-[T���N[Jl�U3��ǆ)��	�
�	R�qA]� � �Ɖ̢�rw���~I7����Tn���ju��b��[�)���0�H�$��z�KZ��E}��eq����t6�m�RU�$��(�C��ud�ue`( ,A:�D�n���%��3��հ�D?������27?��wr�i�2�Ć2%;{��z<~+*6�>>�>hO�P�W@r(BK��PB�@�XbA��4C�,�X� 3��-��aA�dP@�`H@��P4 Q R�ū������U|6f�SSܭ_C�I�H����k}�qUK�	R�֩�
j����<�_x��/�x�}x�\z�2G�sV�b*8 L=D ,�iY4��(��t����כ;���<�����\{������7~{K��E����v�O��v��:�|;��C՟ɧ�k��d-lJJ�c�!QrH�!Y�l����Uúe�)C*-q ��(���`�.�YL"(�` ͬ�t����c�k�������Y����F�rh'���3�m�B��(�@Jd��d��s>�!��2^NCC)#����$�S@E�W���&�,H6��pP�f���;���2���ڪn�c�/�"�3��?�v�Vퟜ��V��Y�i�k����������M�$*գp�*�e�(�G�P�8#�������u@S)s�Aa�(� �]��Q��C����1�%7���_C�g�r7����t%9j�rN��x���O����L�
D*�Yc�?~Ȱ߫�W�^ǃ�ו��<��2��@pQ!�$8P�F���ʨ0����BnM4�ƀppg<�Z���a������[�������W}�O�_�]I��|JAW��^�o��G���>W�1T����G���0���a�j�0s]�,d$��3V	�c-�Yu C�d�y�$�
�%  ���hYf��(��9�c�r��t��K�X�7��tuuxkL���L��������z�>����_����F�<�}7�5�G	�Щ��CG/Ŷt�"�j�
�P�ȕ�(�h8�	�qLw
8�0����s��\��)�qw/y���uR�.{��D}xU���Z�f���n����JyU�2.�eY�ጢ6�m�M���jhR��B� Ŷ
�J��$$ 0���@EC	\f`ƌP\!XyU^M�ʈi}�.)���ۜ<�֮�FB�FP�R|�3Ҳ�Trex���IH�0������{ܩ]�5���P�Zݴ��Akd�"��En*�EfA�	C@ltz�v�h����ɯ��=?<�f朊�?�?�����O���K-�9�}h`o���Y���V=���tQZ�0�R�T�.�vo��0lbڝ-+�P�BƧViA���% J��`EQ\@���d�"Q$�+.q7ݥ�dkI2�?՞����Z�&[�)��hs��a���3|;۷�G�����^B:���1��EY:� �.͂�*U��6p��7M��5]	u��e��X �8��JWFm/�����X��<ׯ^�'x��ԛ|���pe\��Lu+�����r������ة�Y嚶R\mk7�f�#�y6ʭ�uK��U��_T]4 �a5 �@-�E�`�c��2�!Q�����B��<��C�ә����������F(��rKT���m�g��_��lF�����2,a�hTO -1���B@: ,�R��ۀ@$��49��Ԇ� 1�$ @�
���u_?oĵ��N�V?��|���=��ԧ��a0���k��F��oe�{�������1�QUf�X�ҷm�xvoM�6s�P�1(c�G5L�T�@R���H ��,c�1R�0�Eb*�03Ӹ?6�a�s�8��4ߕG
[����";��u�����i��R�t��b��g ��
�Ԕ xTa�
�]��z�S�i �RU�l,
���-!s`e!���P�!��v5���J_�/^���x��9��P��9���O}�.�tq���}y�\����i�9����P�"�S�s�}����V��n�N���FK�\6cj$:bI4)`@0���D��Fᐨc��u�]ϟ�xRy������v��c��B�z����xS������R=������L���Y����Q$a�$:�r����*�` � �@��rv.ÁPl�IVV�6�D��CD�<a��`�!�rj=l���6��gΓ�:�z9��n�����wY�o��l���K�|�N�\#Nzi�l����S4�%n�����kg��-í��gU`u6�l�U�1��`#��X �1`,�is�u���8��������I��k�<��M�ֲ�٫�z{���y��{�m�K���*)�X�-ԌA�D��j�\�ڲaT8q�p�(�fիA5��U�2Z!l���JA4�䍚�
��Snt+�2w�p)�r>Q�=��������e )�je��qRqW~�ws�PU���|�[�;}�|��ņxz�Y��Yv�Ķ֎I5�j  5��bQP��H X@�Kz�T���=^w�~�����pqtΣ�>j60tA��v��i�Y��S�/�����e�3��a>�|��(mB�
��'P��'�z0e�読EtʢD��Z
�-��� ����l�,
\�m��$T%l�,�zs2l�s܄��n���k�߽�;��V�"oyz��\[f�Ur������}����V�>���TѦ�g�j���U���fBb�p���(�D ԀCfpj��32�4����������{�������I����m\A���f�����㛮>q��z�}S�]�����ɕD :m�0P�B9 ]�r�4p� ��
`*%� ,�XH
���@g��A $D8IH.�X�eh�dp\aB`E���S1���4g��<\��2ǋ�ZO��ow�>��B�5�5��]>��G|�����6�ŧ�������ߏ��kM�9��+�i'o�6��v7{|K�
�5��r��x��rm`/t�������?�����������yt>c�h��}s-c�UÌ��C�X~�_��ɟ_��A���Q���-5�f�:�k�e@C�(p�EUj@	�4%�@��p :z��), ��=��,B���Za�֡@���Ed��V�����D%gZ<ۛx��/�/�T��C�<�&��+ۘQ��P���1�B���9��������/ޯn�9��>�u/�g[��{~z�f;�g[OĘ�F��!��Y�y"j &0Ps� ��sߟ�����?~��S?����tbd�Hs�za��eT��fw|�������[�u�H�i����T�)����t���\*�BJ��6BaJ�	ZO�2-G��J�=�Dp�4a�����40z�ذ��@��hA��B*���|�e�\��Y.���;/�~W���t��q����=c̓~������ǱS��zп�����{�����������~u����ח���=?�Ǐ��n<&/mS���2ͦC�b��Ct0��O��̘���������W~���������z��޿ުQ?]~�q����SKA4Ū��6��l>7�����/�{;���_�uZ�V��+D�Ȉ�;V$�� ��RF�Ta�u`j4 ^���p@ ����B"�"((��  T��-
�{$F ډ�X�0P5�~J�=�6u�;o���^�m�_�~n����M3�WTF�4��:���_~?��ߗ?��퟿���?�����}�O������O���=s�����miٍo���S� ���`���޺tϹR�<��������___����ٛ��7?�?��^o' mO.�W �Sھ�<t��ͧ����������Z�g�j�A����H�{�D�*Y�� �Mװ� �u��C�*
�8`�:���C��W��."ѱsP�0P �Q�� 9�ҴhTAd٣ !s*g��\����|���ۧ����f���5������)>�{t����_�}���O����޾����:�l�������e�W{ힻ���
a����T��T���hpm�����:��<���=>�g��ُ?�������Fg�l<�à�8�f����W�#��շ;|��_��	?��.1�+�N{:-1��%Dș\j!�2r��Љ�FXv�7�	M�EFO�����D�uT �*��#!�J�h��46]�A�VH��*4V(e�ps�4r�Ӂs��|�멽6ߝ��˻?�ͅ�M	AxͶ��#�^\�}����o��o�����������}�������O������}����}�|�ܾ����M�9�e�c�\�n���}>��u__���߽�W���������?߻?�?���|`�:lf�ɊH��t�mT�g�=�oy{y�*���9��L%%�����ѱ�0�`'B��*#S���i`C)]����!ҙ����2�Z����
DK���JhI�H�u4l�U�$@cZ �: 4UP�^$��r3j��Ƒ;�Xe^��<��>}�~�N_^}��\�%�E}����]n�~^�����^���������~�~���{�Y�������r�>��}����|�����{}��}�/g��'~��������|�� �<����=����{����?O�ߙ;��<��|U�P� m��x̍��ӟZ_�}�=|+WO�4ϯ��v��%�-�-M��6�^g�Ԩ�Vr � 4P�X!��C��M�Lhlf��1�L� �=jHn���C��,���.H�(G�6�C�1��j�ѡ��DhC�pd�a�Qe�6��%���v�
����2Zv?�YK&~<��sN���pu�z�{}��|����I�������}���׽���������������������އ�~�����v?���{�3f��E+nO}����uw������/��o���87v.�����︵'�����<�>Ο�S?:��}{^=��u|�r��Y��	�Z�NF�Cb��TW�0�cS��q����ٴ��TYCe�u���BC]8;�� {�Y�}]-�
�IYr��' ��Ѩq���xt�����K�2̆�%3v(Q'q�,��(McqZV���"�V�:���ᶟ�U}�n��������\�w�㑹�R�]?ߋݼ�=����������޿�ս�}���}�ٷgO>�f��c���qu�ON5����m���P�ox�O�X�O}��t����n�����}y�������/�{37�{J?����CS�6�"G$]�"��%5�9b����H�N��5^�y��g���g_��'�~����9��Y��y���O^�Nǻ�ŵ�P��&���da�"X<{�="�v_ǃ�C��D?�^�x��O��t�.a�a$�T�A^�9bTϢ��2QZA�C�㱿��*���}���{��e{yW����|B�}W}���e��s������_�[���i㶹��y7;y �]\e��1��8ͅ���y��]~��q��?O�[�?��~�z�9�2��팃ғ}o�=ۥ�θ!�.)i��4Y��e��RQ�I0���]���b��v���?������w�����x�'o�}���q��?��_��'���>���^O��E��zV��,����󩡨��O���Ӌw��~(��;tͯ=��_ٲ�*uW�S�9+J�A�5N5���<.�Y�W1�s-T��S����z<���G���~������}���}��{ܻ����\���:{�*�[nǖ����V���W��Ql0=� ��*�c{�q��jS�S���~��|_��_���������O?w�a~��3KG�]#Y��h*����r�"VŽ�K�ZM�С�t�k{������=����������~����_��߾����K�?��?��������o|����ΓO�,��f�0         [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://e42i05ja4vdi"
path="res://.godot/imported/logo.png-cca8726399059c8d4f806e28e356b14d.ctex"
metadata={
"vram_texture": false
}
 extends Node2D

func _on_bobble_btn_pressed():
	get_parent().add_child(load("res://examples/bobble/bobble.tscn").instantiate())
	get_parent().remove_child(self)

func _on_lobby_btn_pressed():
	get_parent().add_child(load("res://examples/lobby/lobby.tscn").instantiate())
	get_parent().remove_child(self)

func _on_server_client_btn_pressed():
	get_parent().add_child(load("res://examples/server_client/server_client.tscn").instantiate())
	get_parent().remove_child(self)
         RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://root.gd ��������      local://PackedScene_he38l          PackedScene          	         names "         root    script    Node2D    bobble_btn    offset_left    offset_top    offset_right    offset_bottom    text    Button 
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
}, {
"base": &"RefCounted",
"class": &"Seriously",
"icon": "",
"language": &"GDScript",
"path": "res://addons/matcha/lib/Seriously.gd"
}])
           <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             �$��)T&,   res://examples/bobble/components/player.tscnCx�@Lr!   res://examples/bobble/bobble.tscnM|,�g�e|   res://examples/lobby/lobby.tscn�O����g/   res://examples/server_client/server_client.tscns�4�\��*   res://root.tscn)(l�,�(   res://icon.svg�lfl�   res://logo.png  ECFG      application/config/name         matcha     application/run/main_scene         res://root.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     audio/driver/mix_rate.web      D�  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height            display/window/stretch/mode         viewport   display/window/stretch/aspect      
   keep_width  #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility4   rendering/textures/vram_compression/import_etc2_astc           
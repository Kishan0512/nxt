// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_user_broadcast.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeedBroadcastAdapter extends TypeAdapter<Need_Broadcast> {
  @override
  final int typeId = 3;

  @override
  Need_Broadcast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Need_Broadcast(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      count: fields[3] as String,
      date: fields[4] as String,
      last_msg: fields[5] as String,
      last_date: fields[6] as String,
      is_selected: fields[7] as bool,
      br_msg_content: fields[8] as String,
      br_name: fields[9] as String,
      br_profile_pic: fields[10] as String,
      br_exist_user: fields[11] as String,
      user_mast_id: fields[12] as int,
      br_modified_time_show: fields[13] as String,
      br_msg_type: fields[14] as dynamic,
      br_modified_time: fields[15] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Need_Broadcast obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.count)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.last_msg)
      ..writeByte(6)
      ..write(obj.last_date)
      ..writeByte(7)
      ..write(obj.is_selected)
      ..writeByte(8)
      ..write(obj.br_msg_content)
      ..writeByte(9)
      ..write(obj.br_name)
      ..writeByte(10)
      ..write(obj.br_profile_pic)
      ..writeByte(11)
      ..write(obj.br_exist_user)
      ..writeByte(12)
      ..write(obj.user_mast_id)
      ..writeByte(13)
      ..write(obj.br_modified_time_show)
      ..writeByte(14)
      ..write(obj.br_msg_type)
      ..writeByte(15)
      ..write(obj.br_modified_time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeedBroadcastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

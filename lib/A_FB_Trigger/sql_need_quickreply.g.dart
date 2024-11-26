// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_need_quickreply.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeedQuickReplyAdapter extends TypeAdapter<Need_QuickReply> {
  @override
  final int typeId = 5;

  @override
  Need_QuickReply read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Need_QuickReply(
      id: fields[0] as int,
      user_mast_id: fields[1] as int,
      user_quick_value: fields[2] as String,
      user_quick_ord: fields[3] as int,
      is_delete: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Need_QuickReply obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user_mast_id)
      ..writeByte(2)
      ..write(obj.user_quick_value)
      ..writeByte(3)
      ..write(obj.user_quick_ord)
      ..writeByte(4)
      ..write(obj.is_delete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeedQuickReplyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

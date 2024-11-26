// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class sqlcontacttranAdapter extends TypeAdapter<sql_contact_tran> {
  @override
  final int typeId = 9;

  @override
  sql_contact_tran read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return sql_contact_tran(
      id: fields[0] as int,
      contact_id: fields[1] as int,
      user_mast_id: fields[2] as int,
      mobile_number: fields[3] as String,
      disp_mobile_number: fields[4] as String,
      disp_name: fields[5] as String,
      user_exist_in_mobile: fields[6] as bool,
      user_is_block: fields[7] as bool,
      user_is_favourite: fields[8] as bool,
      user_last_msg_id: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, sql_contact_tran obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contact_id)
      ..writeByte(2)
      ..write(obj.user_mast_id)
      ..writeByte(3)
      ..write(obj.mobile_number)
      ..writeByte(4)
      ..write(obj.disp_mobile_number)
      ..writeByte(5)
      ..write(obj.disp_name)
      ..writeByte(6)
      ..write(obj.user_exist_in_mobile)
      ..writeByte(7)
      ..write(obj.user_is_block)
      ..writeByte(8)
      ..write(obj.user_is_favourite)
      ..writeByte(9)
      ..write(obj.user_last_msg_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is sqlcontacttranAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

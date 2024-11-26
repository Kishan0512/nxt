// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Local_Contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalContactAdapter extends TypeAdapter<Local_Contact> {
  @override
  final int typeId = 12;

  @override
  Local_Contact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Local_Contact(
      disp_name: fields[0] as String,
      mobile_number: fields[1] as String,
      country_code: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Local_Contact obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.disp_name)
      ..writeByte(1)
      ..write(obj.mobile_number)
      ..writeByte(2)
      ..write(obj.country_code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

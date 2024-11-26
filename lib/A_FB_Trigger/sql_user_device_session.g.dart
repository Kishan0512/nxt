// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_user_device_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeedDeviceSessionAdapter extends TypeAdapter<Need_DeviceSession> {
  @override
  final int typeId = 6;

  @override
  Need_DeviceSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Need_DeviceSession(
      id: fields[0] as int,
      user_mast_id: fields[1] as int,
      nxtapp_version: fields[2] as String,
      mobile_version: fields[3] as String,
      ipaddress: fields[4] as String,
      is_active: fields[5] as int,
      device_location: fields[6] as String,
      mobile_name: fields[7] as String,
      login_date_time: fields[8] as String,
      login_date_time_show: fields[9] as String,
      mac_address: fields[10] as String,
      isAndroid: fields[11] as bool,
      isIOS: fields[12] as bool,
      isMacOS: fields[13] as bool,
      isWindows: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Need_DeviceSession obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user_mast_id)
      ..writeByte(2)
      ..write(obj.nxtapp_version)
      ..writeByte(3)
      ..write(obj.mobile_version)
      ..writeByte(4)
      ..write(obj.ipaddress)
      ..writeByte(5)
      ..write(obj.is_active)
      ..writeByte(6)
      ..write(obj.device_location)
      ..writeByte(7)
      ..write(obj.mobile_name)
      ..writeByte(8)
      ..write(obj.login_date_time)
      ..writeByte(9)
      ..write(obj.login_date_time_show)
      ..writeByte(10)
      ..write(obj.mac_address)
      ..writeByte(11)
      ..write(obj.isAndroid)
      ..writeByte(12)
      ..write(obj.isIOS)
      ..writeByte(13)
      ..write(obj.isMacOS)
      ..writeByte(14)
      ..write(obj.isWindows);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeedDeviceSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

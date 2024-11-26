// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_need_contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeedContactAdapter extends TypeAdapter<Need_Contact> {
  @override
  final int typeId = 2;

  @override
  Need_Contact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Need_Contact(
      id: fields[0] as String,
      name: fields[1] as String,
      is_favourite: fields[2] as bool,
      is_block: fields[3] as bool,
      is_broadcast: fields[4] as bool,
      is_group: fields[5] as bool,
      user_last_is_icon_status: fields[6] as int,
      user_last_msg_timestamp: fields[7] as String,
      user_last_msg_delete: fields[8] as bool,
      user_last_msg: fields[9] as String,
      user_last_login_time: fields[10] as String,
      user_last_is_online: fields[11] as bool,
      user_last_mobile_country_code: fields[12] as String,
      user_last_final_mobile_number: fields[13] as String,
      user_last_profile: fields[14] as String,
      user_last_bio: fields[15] as String,
      user_last_bio_date: fields[16] as String,
      user_last_birthdate: fields[17] as String,
      user_exist_in_mobile: fields[18] as bool,
      user_is_online: fields[19] as bool,
      user_is_favourite: fields[20] as bool,
      user_is_block: fields[21] as bool,
      user_mast_id: fields[22] as int,
      mobile_number: fields[23] as String,
      user_bio: fields[24] as String,
      user_profileimage_path: fields[25] as String,
      user_bio_last_datetime: fields[26] as String,
      user_birthdate: fields[27] as String,
      user_countrywithmobile: fields[28] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Need_Contact obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.is_favourite)
      ..writeByte(3)
      ..write(obj.is_block)
      ..writeByte(4)
      ..write(obj.is_broadcast)
      ..writeByte(5)
      ..write(obj.is_group)
      ..writeByte(6)
      ..write(obj.user_last_is_icon_status)
      ..writeByte(7)
      ..write(obj.user_last_msg_timestamp)
      ..writeByte(8)
      ..write(obj.user_last_msg_delete)
      ..writeByte(9)
      ..write(obj.user_last_msg)
      ..writeByte(10)
      ..write(obj.user_last_login_time)
      ..writeByte(11)
      ..write(obj.user_last_is_online)
      ..writeByte(12)
      ..write(obj.user_last_mobile_country_code)
      ..writeByte(13)
      ..write(obj.user_last_final_mobile_number)
      ..writeByte(14)
      ..write(obj.user_last_profile)
      ..writeByte(15)
      ..write(obj.user_last_bio)
      ..writeByte(16)
      ..write(obj.user_last_bio_date)
      ..writeByte(17)
      ..write(obj.user_last_birthdate)
      ..writeByte(18)
      ..write(obj.user_exist_in_mobile)
      ..writeByte(19)
      ..write(obj.user_is_online)
      ..writeByte(20)
      ..write(obj.user_is_favourite)
      ..writeByte(21)
      ..write(obj.user_is_block)
      ..writeByte(22)
      ..write(obj.user_mast_id)
      ..writeByte(23)
      ..write(obj.mobile_number)
      ..writeByte(24)
      ..write(obj.user_bio)
      ..writeByte(25)
      ..write(obj.user_profileimage_path)
      ..writeByte(26)
      ..write(obj.user_bio_last_datetime)
      ..writeByte(27)
      ..write(obj.user_birthdate)
      ..writeByte(28)
      ..write(obj.user_countrywithmobile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeedContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

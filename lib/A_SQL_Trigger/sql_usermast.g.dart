// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_usermast.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class sqlusermasttranAdapter extends TypeAdapter<sql_usermast_tran> {
  @override
  final int typeId = 1;

  @override
  sql_usermast_tran read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return sql_usermast_tran(
      ID: fields[0] as int,
      country_code: fields[1] as String,
      mobile_number: fields[2] as String,
      disp_mobile_number: fields[3] as String,
      user_login_name: fields[4] as String,
      user_bio: fields[5] as String,
      user_bio_last_datetime: fields[6] as String,
      user_is_login: fields[7] as bool,
      user_is_logout: fields[8] as bool,
      user_is_online: fields[9] as bool,
      user_is_otp: fields[10] as int,
      user_profileimage_path: fields[11] as String,
      user_birthdate: fields[12] as String,
      user_icon_selected: fields[13] as int,
      user_show_profilepicture: fields[14] as int,
      user_show_last_seen: fields[15] as int,
      user_show_mybirthday: fields[16] as int,
      user_wallpaper: fields[17] as String,
      user_chat_bln_quick_reply: fields[18] as bool,
      user_last_login: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, sql_usermast_tran obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.ID)
      ..writeByte(1)
      ..write(obj.country_code)
      ..writeByte(2)
      ..write(obj.mobile_number)
      ..writeByte(3)
      ..write(obj.disp_mobile_number)
      ..writeByte(4)
      ..write(obj.user_login_name)
      ..writeByte(5)
      ..write(obj.user_bio)
      ..writeByte(6)
      ..write(obj.user_bio_last_datetime)
      ..writeByte(7)
      ..write(obj.user_is_login)
      ..writeByte(8)
      ..write(obj.user_is_logout)
      ..writeByte(9)
      ..write(obj.user_is_online)
      ..writeByte(10)
      ..write(obj.user_is_otp)
      ..writeByte(11)
      ..write(obj.user_profileimage_path)
      ..writeByte(12)
      ..write(obj.user_birthdate)
      ..writeByte(13)
      ..write(obj.user_icon_selected)
      ..writeByte(14)
      ..write(obj.user_show_profilepicture)
      ..writeByte(15)
      ..write(obj.user_show_last_seen)
      ..writeByte(16)
      ..write(obj.user_show_mybirthday)
      ..writeByte(17)
      ..write(obj.user_wallpaper)
      ..writeByte(18)
      ..write(obj.user_chat_bln_quick_reply)
      ..writeByte(19)
      ..write(obj.user_last_login);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is sqlusermasttranAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

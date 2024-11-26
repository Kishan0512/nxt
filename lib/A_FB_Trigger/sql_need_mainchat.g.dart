// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_need_mainchat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeedMainChatAdapter extends TypeAdapter<Need_MainChat> {
  @override
  final int typeId = 7;

  @override
  Need_MainChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Need_MainChat(
      id: fields[0] as int,
      msg_from_user_mast_id: fields[1] as int,
      msg_to_user_mast_id: fields[2] as int,
      msg_content: fields[3] as String,
      msg_read: fields[4] as String,
      msg_read_timestamp_show: fields[5] as String,
      msg_delivered: fields[6] as bool,
      msg_delivered_timestamp_show: fields[7] as String,
      msg_type: fields[8] as int,
      msg_document_url: fields[9] as String,
      is_selected: fields[10] as int,
      disp_name: fields[11] as String,
      inserted_time_show: fields[12] as String,
      user_profileimage_path: fields[13] as String,
      uc_contact_id: fields[14] as int,
      inserted_time: fields[31] as dynamic,
      user_mast_id: fields[15] as int,
      user_is_favourite: fields[16] as bool,
      user_is_block: fields[17] as bool,
      user_last_msg: fields[18] as String,
      user_last_login_time: fields[19] as String,
      user_is_online: fields[20] as bool,
      mobile_number: fields[21] as String,
      user_bio: fields[22] as String,
      user_bio_last_datetime: fields[23] as String,
      user_birthdate: fields[24] as String,
      user_countrywithmobile: fields[25] as String,
      msg_unread_count: fields[26] as int,
      msg_last_id: fields[27] as int,
      msg_unread_count_total: fields[28] as int,
      msg_id: fields[29] as int,
      msg_is_delete_by_from_user: fields[32] as dynamic,
      server_key: fields[30] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Need_MainChat obj) {
    writer
      ..writeByte(33)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.msg_from_user_mast_id)
      ..writeByte(2)
      ..write(obj.msg_to_user_mast_id)
      ..writeByte(3)
      ..write(obj.msg_content)
      ..writeByte(4)
      ..write(obj.msg_read)
      ..writeByte(5)
      ..write(obj.msg_read_timestamp_show)
      ..writeByte(6)
      ..write(obj.msg_delivered)
      ..writeByte(7)
      ..write(obj.msg_delivered_timestamp_show)
      ..writeByte(8)
      ..write(obj.msg_type)
      ..writeByte(9)
      ..write(obj.msg_document_url)
      ..writeByte(10)
      ..write(obj.is_selected)
      ..writeByte(11)
      ..write(obj.disp_name)
      ..writeByte(12)
      ..write(obj.inserted_time_show)
      ..writeByte(13)
      ..write(obj.user_profileimage_path)
      ..writeByte(14)
      ..write(obj.uc_contact_id)
      ..writeByte(15)
      ..write(obj.user_mast_id)
      ..writeByte(16)
      ..write(obj.user_is_favourite)
      ..writeByte(17)
      ..write(obj.user_is_block)
      ..writeByte(18)
      ..write(obj.user_last_msg)
      ..writeByte(19)
      ..write(obj.user_last_login_time)
      ..writeByte(20)
      ..write(obj.user_is_online)
      ..writeByte(21)
      ..write(obj.mobile_number)
      ..writeByte(22)
      ..write(obj.user_bio)
      ..writeByte(23)
      ..write(obj.user_bio_last_datetime)
      ..writeByte(24)
      ..write(obj.user_birthdate)
      ..writeByte(25)
      ..write(obj.user_countrywithmobile)
      ..writeByte(26)
      ..write(obj.msg_unread_count)
      ..writeByte(27)
      ..write(obj.msg_last_id)
      ..writeByte(28)
      ..write(obj.msg_unread_count_total)
      ..writeByte(29)
      ..write(obj.msg_id)
      ..writeByte(30)
      ..write(obj.server_key)
      ..writeByte(31)
      ..write(obj.inserted_time)
      ..writeByte(32)
      ..write(obj.msg_is_delete_by_from_user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeedMainChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

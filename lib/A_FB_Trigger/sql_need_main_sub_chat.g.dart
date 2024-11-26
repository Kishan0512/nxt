// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_need_main_sub_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeedMainSubChatAdapter extends TypeAdapter<Need_Main_Sub_Chat> {
  @override
  final int typeId = 8;

  @override
  Need_Main_Sub_Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Need_Main_Sub_Chat(
      id: fields[0] as String,
      document_url: fields[14] as String,
      msg_audio_name: fields[2] as String,
      msg_media_size: fields[3] as String,
      msg_content: fields[4] as String,
      is_right: fields[5] as String,
      is_read: fields[6] as String,
      read_time: fields[7] as String,
      delivered_time: fields[8] as String,
      msg_timestamp: fields[1] as String,
      date: fields[9] as String,
      is_delivered: fields[15] as String,
      broadcast_bulk_id: fields[18] as String,
      broadcast_id: fields[17] as String,
      center_date: fields[10] as String,
      msg_type: fields[11] as String,
      msg_blurhash: fields[16] as String,
      msg_from_user_mast_id: fields[13] as String,
      msg_to_user_mast_id: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Need_Main_Sub_Chat obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.msg_timestamp)
      ..writeByte(2)
      ..write(obj.msg_audio_name)
      ..writeByte(3)
      ..write(obj.msg_media_size)
      ..writeByte(4)
      ..write(obj.msg_content)
      ..writeByte(5)
      ..write(obj.is_right)
      ..writeByte(6)
      ..write(obj.is_read)
      ..writeByte(7)
      ..write(obj.read_time)
      ..writeByte(8)
      ..write(obj.delivered_time)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.center_date)
      ..writeByte(11)
      ..write(obj.msg_type)
      ..writeByte(12)
      ..write(obj.msg_to_user_mast_id)
      ..writeByte(13)
      ..write(obj.msg_from_user_mast_id)
      ..writeByte(14)
      ..write(obj.document_url)
      ..writeByte(15)
      ..write(obj.is_delivered)
      ..writeByte(16)
      ..write(obj.msg_blurhash)
      ..writeByte(17)
      ..write(obj.broadcast_id)
      ..writeByte(18)
      ..write(obj.broadcast_bulk_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeedMainSubChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

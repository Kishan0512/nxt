// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sql_need_broadcast_sub_msg.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeedBroadcastSubMsgAdapter extends TypeAdapter<Need_Broadcast_Sub_Msg> {
  @override
  final int typeId = 4;

  @override
  Need_Broadcast_Sub_Msg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Need_Broadcast_Sub_Msg(
      id: fields[0] as String,
      document_url: fields[1] as String,
      msg_type: fields[2] as String,
      msg_content: fields[3] as String,
      msg_audio_name: fields[4] as String,
      msg_media_size: fields[5] as String,
      is_right: fields[6] as String,
      is_read: fields[7] as String,
      read_time: fields[8] as String,
      delivered_time: fields[9] as String,
      is_delivered: fields[14] as String,
      msg_timestamp: fields[13] as dynamic,
      date: fields[10] as String,
      center_date: fields[11] as String,
      broadcast_bulk_id: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Need_Broadcast_Sub_Msg obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.document_url)
      ..writeByte(2)
      ..write(obj.msg_type)
      ..writeByte(3)
      ..write(obj.msg_content)
      ..writeByte(4)
      ..write(obj.msg_audio_name)
      ..writeByte(5)
      ..write(obj.msg_media_size)
      ..writeByte(6)
      ..write(obj.is_right)
      ..writeByte(7)
      ..write(obj.is_read)
      ..writeByte(8)
      ..write(obj.read_time)
      ..writeByte(9)
      ..write(obj.delivered_time)
      ..writeByte(10)
      ..write(obj.date)
      ..writeByte(11)
      ..write(obj.center_date)
      ..writeByte(12)
      ..write(obj.broadcast_bulk_id)
      ..writeByte(13)
      ..write(obj.msg_timestamp)
      ..writeByte(14)
      ..write(obj.is_delivered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeedBroadcastSubMsgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

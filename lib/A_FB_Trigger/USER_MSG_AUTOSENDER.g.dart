// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'USER_MSG_AUTOSENDER.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class USERMSGAUTOSENDERAdapter extends TypeAdapter<USER_MSG_AUTOSENDER> {
  @override
  final int typeId = 10;

  @override
  USER_MSG_AUTOSENDER read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return USER_MSG_AUTOSENDER(
      msgContent: fields[0] as String,
      id: fields[1] as int?,
      msgFromUserMastId: fields[2] as int,
      msgToUserMastIds: fields[3] as String,
      msgTimestamp: fields[4] as String?,
      msgTypeDateUtc: fields[5] as String,
      msgTypeDateTimeUtc: fields[6] as String,
      msgTypeBtn: fields[7] as String,
      msgTypeDateTime: fields[8] as String,
      mediaList: (fields[9] as List).cast<MediaListClass>(),
    );
  }

  @override
  void write(BinaryWriter writer, USER_MSG_AUTOSENDER obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.msgContent)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.msgFromUserMastId)
      ..writeByte(3)
      ..write(obj.msgToUserMastIds)
      ..writeByte(4)
      ..write(obj.msgTimestamp)
      ..writeByte(5)
      ..write(obj.msgTypeDateUtc)
      ..writeByte(6)
      ..write(obj.msgTypeDateTimeUtc)
      ..writeByte(7)
      ..write(obj.msgTypeBtn)
      ..writeByte(8)
      ..write(obj.msgTypeDateTime)
      ..writeByte(9)
      ..write(obj.mediaList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is USERMSGAUTOSENDERAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaListClassAdapter extends TypeAdapter<MediaListClass> {
  @override
  final int typeId = 11;

  @override
  MediaListClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaListClass(
      id: fields[0] as int?,
      refId: fields[1] as int?,
      msgDocumentUrl: fields[2] as String,
      msgAudioName: fields[3] as String,
      msgMediaSize: fields[4] as String,
      msgType: fields[5] as String,
      msgTimeStamp: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MediaListClass obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.refId)
      ..writeByte(2)
      ..write(obj.msgDocumentUrl)
      ..writeByte(3)
      ..write(obj.msgAudioName)
      ..writeByte(4)
      ..write(obj.msgMediaSize)
      ..writeByte(5)
      ..write(obj.msgType)
      ..writeByte(6)
      ..write(obj.msgTimeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaListClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

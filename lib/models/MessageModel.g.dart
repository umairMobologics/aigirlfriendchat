// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveMessagesModelAdapter extends TypeAdapter<SaveMessagesModel> {
  @override
  final int typeId = 0;

  @override
  SaveMessagesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveMessagesModel(
      sender: fields[0] as String?,
      message: fields[1] as String?,
      isSender: fields[2] as bool?,
      time: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SaveMessagesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sender)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.isSender)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveMessagesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

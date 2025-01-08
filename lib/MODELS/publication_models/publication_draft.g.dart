// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication_draft.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PublicationDraftAdapter extends TypeAdapter<PublicationDraft> {
  @override
  final int typeId = 1;

  @override
  PublicationDraft read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PublicationDraft(
      type: fields[0] as String,
      currency: fields[1] as String,
      title: fields[2] as String,
      abstractText: fields[3] as String,
      numOfRef: fields[4] as int,
      price: fields[5] as double,
      tags: (fields[6] as List).cast<dynamic>(),
      owners: (fields[7] as List).cast<dynamic>(),
      attachmentFile: fields[8] as String,
      doYouHaveCoWorkers: fields[9] as String,
    )..id = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, PublicationDraft obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.abstractText)
      ..writeByte(4)
      ..write(obj.numOfRef)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.owners)
      ..writeByte(8)
      ..write(obj.attachmentFile)
      ..writeByte(9)
      ..write(obj.doYouHaveCoWorkers)
      ..writeByte(10)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublicationDraftAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

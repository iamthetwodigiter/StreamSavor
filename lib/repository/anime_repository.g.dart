// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_repository.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimeCardsAdapter extends TypeAdapter<AnimeCards> {
  @override
  final int typeId = 1;

  @override
  AnimeCards read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnimeCards(
      id: fields[0] as String,
      name: fields[1] as String,
      poster: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnimeCards obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.poster);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeCardsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

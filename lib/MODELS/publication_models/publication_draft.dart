import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'publication_draft.g.dart';

@HiveType(typeId: 1)
class PublicationDraft extends HiveObject {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String currency;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String abstractText;
  @HiveField(4)
  final int numOfRef;
  @HiveField(5)
  final double price;
  @HiveField(6)
  final List tags;
  @HiveField(7)
  final List owners;
  @HiveField(8)
  final String attachmentFile;
  @HiveField(9)
  final String doYouHaveCoWorkers;
  @HiveField(10)
  String? id;

  PublicationDraft({
    required this.type,
    required this.currency,
    required this.title,
    required this.abstractText,
    required this.numOfRef,
    required this.price,
    required this.tags,
    required this.owners,
    required this.attachmentFile,
    required this.doYouHaveCoWorkers,
    this.id,
  });
}

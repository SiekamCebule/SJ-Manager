import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/repositories/database_items/database_items_local_storage_repository.dart';

class MaleJumpersDatabaseRepo extends DatabaseItemsLocalStorageRepository<Jumper> {
  MaleJumpersDatabaseRepo({required super.fromJson, required super.storageFile});
}

class FemaleJumpersDatabaseRepo extends DatabaseItemsLocalStorageRepository<Jumper> {
  FemaleJumpersDatabaseRepo({required super.fromJson, required super.storageFile});
}

import 'package:petcare/models/pet_model.dart';

abstract class PetEvent {}

/// Add Pet
class PetEventAdd extends PetEvent {
  final PetModel model;

  PetEventAdd({required this.model});
}

/// Update Pet
class PetEventUpdate extends PetEvent {
  final PetModel model;

  PetEventUpdate({required this.model});
}

/// Fetch All
class PetEventFetchAll extends PetEvent {}

/// Delete Pet
class PetEventDeleted extends PetEvent {
  final String uuid;

  PetEventDeleted({required this.uuid});
}

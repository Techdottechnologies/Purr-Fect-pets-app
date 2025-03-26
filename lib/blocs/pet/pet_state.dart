import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/models/pet_model.dart';

abstract class PetState {
  final bool isLoading;

  PetState({this.isLoading = false});
}

/// Initial State
class PetStateInitial extends PetState {}

// ===========================Add Pet State================================
class PetStateAdding extends PetState {
  PetStateAdding({super.isLoading = true});
}

class PetStateAddFailure extends PetState {
  final AppException exception;

  PetStateAddFailure({required this.exception});
}

class PetStateAdded extends PetState {}

// ===========================Update Pet State================================
class PetStateUpdating extends PetState {
  PetStateUpdating({super.isLoading = true});
}

class PetStateUpdateFailure extends PetState {
  final AppException exception;

  PetStateUpdateFailure({required this.exception});
}

class PetStateUpdated extends PetState {
  final PetModel pet;

  PetStateUpdated({required this.pet});
}

// ===========================Fetch All Pets State================================
class PetStateFetchingAll extends PetState {
  PetStateFetchingAll({super.isLoading = true});
}

class PetStateFetchAllFailure extends PetState {
  final AppException exception;

  PetStateFetchAllFailure({required this.exception});
}

class PetStateFetchedAll extends PetState {}

// ===========================Deleted Pet State================================

class PetStateDeleted extends PetState {}

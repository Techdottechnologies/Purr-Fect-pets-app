import 'package:petcare/blocs/pet/pet_event.dart';
import 'package:petcare/blocs/pet/pet_state.dart';
import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/models/pet_model.dart';
import 'package:petcare/repos/pet/pet_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  PetBloc() : super(PetStateInitial()) {
    /// Add Pet Event Trigger
    on<PetEventAdd>(
      (event, emit) async {
        try {
          emit(PetStateAdding());
          await PetRepo.add(model: event.model);
          emit(PetStateAdded());
        } on AppException catch (e) {
          emit(PetStateAddFailure(exception: e));
        }
      },
    );

    /// Update Pet Event Trigger
    on<PetEventUpdate>(
      (event, emit) async {
        try {
          emit(PetStateUpdating());
          final PetModel pet = await PetRepo.update(model: event.model);
          emit(PetStateUpdated(pet: pet));
        } on AppException catch (e) {
          emit(PetStateUpdateFailure(exception: e));
        }
      },
    );

    /// Fetch All Pets Event Trigger
    on<PetEventFetchAll>(
      (event, emit) async {
        try {
          emit(PetStateFetchingAll());
          await PetRepo.fetch();
          emit(PetStateFetchedAll());
        } on AppException catch (e) {
          emit(PetStateFetchAllFailure(exception: e));
        }
      },
    );

    /// Delete Pet Event Trigger
    on<PetEventDeleted>(
      (event, emit) async {
        // PetRepo.delete(uuid: event.uuid);
        emit(PetStateDeleted());
      },
    );
  }
}

// Project: 	   muutsch
// File:    	   privacy_bloc
// Path:    	   lib/blocs/privacy/privacy_bloc.dart
// Author:       Ali Akbar
// Date:        18-07-24 18:22:27 -- Thursday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import '/exceptions/app_exceptions.dart';
import '/repos/privacy/privacy_repo_impl.dart';
import 'privacy_event.dart';
import 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  PrivacyBloc() : super(PrivacyStateInitial()) {
    on<PrivacyEventFetch>(
      (event, emit) async {
        try {
          emit(PrivacyStateFetching());
          final privacies = await PrivacyRepo().fetch();
          emit(PrivacyStateFetched(privacies: privacies));
        } on AppException catch (e) {
          emit(PrivacyStateFetchFailure(exception: e));
        }
      },
    );
  }
}

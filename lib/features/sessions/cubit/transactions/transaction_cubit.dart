import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/card_form.dart';
import '../../domain/repositories/sessions_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final SessionsRepository _sessionsRepository;

  TransactionCubit(
      this._sessionsRepository, int sessionId, Iterable<int> seatIds)
      : super(TransactionState(sessionId: sessionId, seatIds: seatIds));

  void buySeats(CardForm cardForm) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    
    if (cardForm.isEmpty()) {
      emit(state.copyWith(status: TransactionStatus.failed));
      return;
    }

    await _sessionsRepository.buySeats(
        state.seatIds, state.sessionId, cardForm);

    emit(state.copyWith(status: TransactionStatus.success));
  }
}

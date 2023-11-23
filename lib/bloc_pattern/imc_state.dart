// ignore_for_file: public_member_api_docs, sort_constructors_first
/// classe que representa o estado
class ImcState {
  final double? imc;
  ImcState({
    this.imc,
  });
}

/// ESTADOS

class ImcStateLoading extends ImcState {}

class ImcStateError extends ImcState {
  String message;
  ImcStateError({
    required this.message,
  });
}

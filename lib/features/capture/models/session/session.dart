import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String username,

    /// Stored only to enable offline re-entry after a successful login.
    /// This is persisted in the encrypted Hive box.
    required String password,
    required int userId,
    required String token,
    required List<String> orderIds,
    required DateTime loggedInAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}

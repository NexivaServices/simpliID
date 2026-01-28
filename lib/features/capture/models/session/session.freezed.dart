// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {

 String get username;/// Stored only to enable offline re-entry after a successful login.
/// This is persisted in the encrypted Hive box.
 String get password; int get userId; String get token; List<String> get orderIds; DateTime get loggedInAt;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other.orderIds, orderIds)&&(identical(other.loggedInAt, loggedInAt) || other.loggedInAt == loggedInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,userId,token,const DeepCollectionEquality().hash(orderIds),loggedInAt);

@override
String toString() {
  return 'Session(username: $username, password: $password, userId: $userId, token: $token, orderIds: $orderIds, loggedInAt: $loggedInAt)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String username, String password, int userId, String token, List<String> orderIds, DateTime loggedInAt
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,Object? userId = null,Object? token = null,Object? orderIds = null,Object? loggedInAt = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,orderIds: null == orderIds ? _self.orderIds : orderIds // ignore: cast_nullable_to_non_nullable
as List<String>,loggedInAt: null == loggedInAt ? _self.loggedInAt : loggedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password,  int userId,  String token,  List<String> orderIds,  DateTime loggedInAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.username,_that.password,_that.userId,_that.token,_that.orderIds,_that.loggedInAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password,  int userId,  String token,  List<String> orderIds,  DateTime loggedInAt)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.username,_that.password,_that.userId,_that.token,_that.orderIds,_that.loggedInAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password,  int userId,  String token,  List<String> orderIds,  DateTime loggedInAt)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.username,_that.password,_that.userId,_that.token,_that.orderIds,_that.loggedInAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({required this.username, required this.password, required this.userId, required this.token, required final  List<String> orderIds, required this.loggedInAt}): _orderIds = orderIds;
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String username;
/// Stored only to enable offline re-entry after a successful login.
/// This is persisted in the encrypted Hive box.
@override final  String password;
@override final  int userId;
@override final  String token;
 final  List<String> _orderIds;
@override List<String> get orderIds {
  if (_orderIds is EqualUnmodifiableListView) return _orderIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orderIds);
}

@override final  DateTime loggedInAt;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other._orderIds, _orderIds)&&(identical(other.loggedInAt, loggedInAt) || other.loggedInAt == loggedInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,userId,token,const DeepCollectionEquality().hash(_orderIds),loggedInAt);

@override
String toString() {
  return 'Session(username: $username, password: $password, userId: $userId, token: $token, orderIds: $orderIds, loggedInAt: $loggedInAt)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String username, String password, int userId, String token, List<String> orderIds, DateTime loggedInAt
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,Object? userId = null,Object? token = null,Object? orderIds = null,Object? loggedInAt = null,}) {
  return _then(_Session(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,orderIds: null == orderIds ? _self._orderIds : orderIds // ignore: cast_nullable_to_non_nullable
as List<String>,loggedInAt: null == loggedInAt ? _self.loggedInAt : loggedInAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

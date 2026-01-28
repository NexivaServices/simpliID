// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fetch_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FetchStudentsRequest {

 String get orderId; DateTime? get lastSyncTimestamp; int? get page; int? get pageSize;
/// Create a copy of FetchStudentsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchStudentsRequestCopyWith<FetchStudentsRequest> get copyWith => _$FetchStudentsRequestCopyWithImpl<FetchStudentsRequest>(this as FetchStudentsRequest, _$identity);

  /// Serializes this FetchStudentsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchStudentsRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,lastSyncTimestamp,page,pageSize);

@override
String toString() {
  return 'FetchStudentsRequest(orderId: $orderId, lastSyncTimestamp: $lastSyncTimestamp, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $FetchStudentsRequestCopyWith<$Res>  {
  factory $FetchStudentsRequestCopyWith(FetchStudentsRequest value, $Res Function(FetchStudentsRequest) _then) = _$FetchStudentsRequestCopyWithImpl;
@useResult
$Res call({
 String orderId, DateTime? lastSyncTimestamp, int? page, int? pageSize
});




}
/// @nodoc
class _$FetchStudentsRequestCopyWithImpl<$Res>
    implements $FetchStudentsRequestCopyWith<$Res> {
  _$FetchStudentsRequestCopyWithImpl(this._self, this._then);

  final FetchStudentsRequest _self;
  final $Res Function(FetchStudentsRequest) _then;

/// Create a copy of FetchStudentsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? lastSyncTimestamp = freezed,Object? page = freezed,Object? pageSize = freezed,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,lastSyncTimestamp: freezed == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,pageSize: freezed == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FetchStudentsRequest].
extension FetchStudentsRequestPatterns on FetchStudentsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FetchStudentsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FetchStudentsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FetchStudentsRequest value)  $default,){
final _that = this;
switch (_that) {
case _FetchStudentsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FetchStudentsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FetchStudentsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  DateTime? lastSyncTimestamp,  int? page,  int? pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FetchStudentsRequest() when $default != null:
return $default(_that.orderId,_that.lastSyncTimestamp,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  DateTime? lastSyncTimestamp,  int? page,  int? pageSize)  $default,) {final _that = this;
switch (_that) {
case _FetchStudentsRequest():
return $default(_that.orderId,_that.lastSyncTimestamp,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  DateTime? lastSyncTimestamp,  int? page,  int? pageSize)?  $default,) {final _that = this;
switch (_that) {
case _FetchStudentsRequest() when $default != null:
return $default(_that.orderId,_that.lastSyncTimestamp,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FetchStudentsRequest implements FetchStudentsRequest {
  const _FetchStudentsRequest({required this.orderId, this.lastSyncTimestamp, this.page, this.pageSize});
  factory _FetchStudentsRequest.fromJson(Map<String, dynamic> json) => _$FetchStudentsRequestFromJson(json);

@override final  String orderId;
@override final  DateTime? lastSyncTimestamp;
@override final  int? page;
@override final  int? pageSize;

/// Create a copy of FetchStudentsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FetchStudentsRequestCopyWith<_FetchStudentsRequest> get copyWith => __$FetchStudentsRequestCopyWithImpl<_FetchStudentsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FetchStudentsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchStudentsRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,lastSyncTimestamp,page,pageSize);

@override
String toString() {
  return 'FetchStudentsRequest(orderId: $orderId, lastSyncTimestamp: $lastSyncTimestamp, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$FetchStudentsRequestCopyWith<$Res> implements $FetchStudentsRequestCopyWith<$Res> {
  factory _$FetchStudentsRequestCopyWith(_FetchStudentsRequest value, $Res Function(_FetchStudentsRequest) _then) = __$FetchStudentsRequestCopyWithImpl;
@override @useResult
$Res call({
 String orderId, DateTime? lastSyncTimestamp, int? page, int? pageSize
});




}
/// @nodoc
class __$FetchStudentsRequestCopyWithImpl<$Res>
    implements _$FetchStudentsRequestCopyWith<$Res> {
  __$FetchStudentsRequestCopyWithImpl(this._self, this._then);

  final _FetchStudentsRequest _self;
  final $Res Function(_FetchStudentsRequest) _then;

/// Create a copy of FetchStudentsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? lastSyncTimestamp = freezed,Object? page = freezed,Object? pageSize = freezed,}) {
  return _then(_FetchStudentsRequest(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,lastSyncTimestamp: freezed == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,pageSize: freezed == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FetchStudentsResponse {

 String get status; String get orderId; DateTime get serverSyncTimestamp; List<CaptureStudent> get students;// Pagination (extension beyond the PDF spec, required by app infinite-scroll).
 int get page; int get pageSize; int get totalStudents;// Extra order/school details requested.
 Map<String, dynamic> get details;
/// Create a copy of FetchStudentsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchStudentsResponseCopyWith<FetchStudentsResponse> get copyWith => _$FetchStudentsResponseCopyWithImpl<FetchStudentsResponse>(this as FetchStudentsResponse, _$identity);

  /// Serializes this FetchStudentsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchStudentsResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.serverSyncTimestamp, serverSyncTimestamp) || other.serverSyncTimestamp == serverSyncTimestamp)&&const DeepCollectionEquality().equals(other.students, students)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,orderId,serverSyncTimestamp,const DeepCollectionEquality().hash(students),page,pageSize,totalStudents,const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'FetchStudentsResponse(status: $status, orderId: $orderId, serverSyncTimestamp: $serverSyncTimestamp, students: $students, page: $page, pageSize: $pageSize, totalStudents: $totalStudents, details: $details)';
}


}

/// @nodoc
abstract mixin class $FetchStudentsResponseCopyWith<$Res>  {
  factory $FetchStudentsResponseCopyWith(FetchStudentsResponse value, $Res Function(FetchStudentsResponse) _then) = _$FetchStudentsResponseCopyWithImpl;
@useResult
$Res call({
 String status, String orderId, DateTime serverSyncTimestamp, List<CaptureStudent> students, int page, int pageSize, int totalStudents, Map<String, dynamic> details
});




}
/// @nodoc
class _$FetchStudentsResponseCopyWithImpl<$Res>
    implements $FetchStudentsResponseCopyWith<$Res> {
  _$FetchStudentsResponseCopyWithImpl(this._self, this._then);

  final FetchStudentsResponse _self;
  final $Res Function(FetchStudentsResponse) _then;

/// Create a copy of FetchStudentsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? orderId = null,Object? serverSyncTimestamp = null,Object? students = null,Object? page = null,Object? pageSize = null,Object? totalStudents = null,Object? details = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,serverSyncTimestamp: null == serverSyncTimestamp ? _self.serverSyncTimestamp : serverSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,students: null == students ? _self.students : students // ignore: cast_nullable_to_non_nullable
as List<CaptureStudent>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [FetchStudentsResponse].
extension FetchStudentsResponsePatterns on FetchStudentsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FetchStudentsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FetchStudentsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FetchStudentsResponse value)  $default,){
final _that = this;
switch (_that) {
case _FetchStudentsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FetchStudentsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FetchStudentsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String orderId,  DateTime serverSyncTimestamp,  List<CaptureStudent> students,  int page,  int pageSize,  int totalStudents,  Map<String, dynamic> details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FetchStudentsResponse() when $default != null:
return $default(_that.status,_that.orderId,_that.serverSyncTimestamp,_that.students,_that.page,_that.pageSize,_that.totalStudents,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String orderId,  DateTime serverSyncTimestamp,  List<CaptureStudent> students,  int page,  int pageSize,  int totalStudents,  Map<String, dynamic> details)  $default,) {final _that = this;
switch (_that) {
case _FetchStudentsResponse():
return $default(_that.status,_that.orderId,_that.serverSyncTimestamp,_that.students,_that.page,_that.pageSize,_that.totalStudents,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String orderId,  DateTime serverSyncTimestamp,  List<CaptureStudent> students,  int page,  int pageSize,  int totalStudents,  Map<String, dynamic> details)?  $default,) {final _that = this;
switch (_that) {
case _FetchStudentsResponse() when $default != null:
return $default(_that.status,_that.orderId,_that.serverSyncTimestamp,_that.students,_that.page,_that.pageSize,_that.totalStudents,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FetchStudentsResponse implements FetchStudentsResponse {
  const _FetchStudentsResponse({required this.status, required this.orderId, required this.serverSyncTimestamp, required final  List<CaptureStudent> students, required this.page, required this.pageSize, required this.totalStudents, final  Map<String, dynamic> details = const {}}): _students = students,_details = details;
  factory _FetchStudentsResponse.fromJson(Map<String, dynamic> json) => _$FetchStudentsResponseFromJson(json);

@override final  String status;
@override final  String orderId;
@override final  DateTime serverSyncTimestamp;
 final  List<CaptureStudent> _students;
@override List<CaptureStudent> get students {
  if (_students is EqualUnmodifiableListView) return _students;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_students);
}

// Pagination (extension beyond the PDF spec, required by app infinite-scroll).
@override final  int page;
@override final  int pageSize;
@override final  int totalStudents;
// Extra order/school details requested.
 final  Map<String, dynamic> _details;
// Extra order/school details requested.
@override@JsonKey() Map<String, dynamic> get details {
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_details);
}


/// Create a copy of FetchStudentsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FetchStudentsResponseCopyWith<_FetchStudentsResponse> get copyWith => __$FetchStudentsResponseCopyWithImpl<_FetchStudentsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FetchStudentsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchStudentsResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.serverSyncTimestamp, serverSyncTimestamp) || other.serverSyncTimestamp == serverSyncTimestamp)&&const DeepCollectionEquality().equals(other._students, _students)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&const DeepCollectionEquality().equals(other._details, _details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,orderId,serverSyncTimestamp,const DeepCollectionEquality().hash(_students),page,pageSize,totalStudents,const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'FetchStudentsResponse(status: $status, orderId: $orderId, serverSyncTimestamp: $serverSyncTimestamp, students: $students, page: $page, pageSize: $pageSize, totalStudents: $totalStudents, details: $details)';
}


}

/// @nodoc
abstract mixin class _$FetchStudentsResponseCopyWith<$Res> implements $FetchStudentsResponseCopyWith<$Res> {
  factory _$FetchStudentsResponseCopyWith(_FetchStudentsResponse value, $Res Function(_FetchStudentsResponse) _then) = __$FetchStudentsResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String orderId, DateTime serverSyncTimestamp, List<CaptureStudent> students, int page, int pageSize, int totalStudents, Map<String, dynamic> details
});




}
/// @nodoc
class __$FetchStudentsResponseCopyWithImpl<$Res>
    implements _$FetchStudentsResponseCopyWith<$Res> {
  __$FetchStudentsResponseCopyWithImpl(this._self, this._then);

  final _FetchStudentsResponse _self;
  final $Res Function(_FetchStudentsResponse) _then;

/// Create a copy of FetchStudentsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? orderId = null,Object? serverSyncTimestamp = null,Object? students = null,Object? page = null,Object? pageSize = null,Object? totalStudents = null,Object? details = null,}) {
  return _then(_FetchStudentsResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,serverSyncTimestamp: null == serverSyncTimestamp ? _self.serverSyncTimestamp : serverSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,students: null == students ? _self._students : students // ignore: cast_nullable_to_non_nullable
as List<CaptureStudent>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on

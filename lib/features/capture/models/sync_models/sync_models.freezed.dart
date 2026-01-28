// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncStudentMetadata {

 String get studentId; DateTime get captureTimestamp; int get editedBy; int get status; String get thumbnailBase64; bool get hasHighResUpdate;
/// Create a copy of SyncStudentMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStudentMetadataCopyWith<SyncStudentMetadata> get copyWith => _$SyncStudentMetadataCopyWithImpl<SyncStudentMetadata>(this as SyncStudentMetadata, _$identity);

  /// Serializes this SyncStudentMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStudentMetadata&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.captureTimestamp, captureTimestamp) || other.captureTimestamp == captureTimestamp)&&(identical(other.editedBy, editedBy) || other.editedBy == editedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.thumbnailBase64, thumbnailBase64) || other.thumbnailBase64 == thumbnailBase64)&&(identical(other.hasHighResUpdate, hasHighResUpdate) || other.hasHighResUpdate == hasHighResUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,captureTimestamp,editedBy,status,thumbnailBase64,hasHighResUpdate);

@override
String toString() {
  return 'SyncStudentMetadata(studentId: $studentId, captureTimestamp: $captureTimestamp, editedBy: $editedBy, status: $status, thumbnailBase64: $thumbnailBase64, hasHighResUpdate: $hasHighResUpdate)';
}


}

/// @nodoc
abstract mixin class $SyncStudentMetadataCopyWith<$Res>  {
  factory $SyncStudentMetadataCopyWith(SyncStudentMetadata value, $Res Function(SyncStudentMetadata) _then) = _$SyncStudentMetadataCopyWithImpl;
@useResult
$Res call({
 String studentId, DateTime captureTimestamp, int editedBy, int status, String thumbnailBase64, bool hasHighResUpdate
});




}
/// @nodoc
class _$SyncStudentMetadataCopyWithImpl<$Res>
    implements $SyncStudentMetadataCopyWith<$Res> {
  _$SyncStudentMetadataCopyWithImpl(this._self, this._then);

  final SyncStudentMetadata _self;
  final $Res Function(SyncStudentMetadata) _then;

/// Create a copy of SyncStudentMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? captureTimestamp = null,Object? editedBy = null,Object? status = null,Object? thumbnailBase64 = null,Object? hasHighResUpdate = null,}) {
  return _then(_self.copyWith(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,captureTimestamp: null == captureTimestamp ? _self.captureTimestamp : captureTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,editedBy: null == editedBy ? _self.editedBy : editedBy // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,thumbnailBase64: null == thumbnailBase64 ? _self.thumbnailBase64 : thumbnailBase64 // ignore: cast_nullable_to_non_nullable
as String,hasHighResUpdate: null == hasHighResUpdate ? _self.hasHighResUpdate : hasHighResUpdate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncStudentMetadata].
extension SyncStudentMetadataPatterns on SyncStudentMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncStudentMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncStudentMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncStudentMetadata value)  $default,){
final _that = this;
switch (_that) {
case _SyncStudentMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncStudentMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _SyncStudentMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  DateTime captureTimestamp,  int editedBy,  int status,  String thumbnailBase64,  bool hasHighResUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncStudentMetadata() when $default != null:
return $default(_that.studentId,_that.captureTimestamp,_that.editedBy,_that.status,_that.thumbnailBase64,_that.hasHighResUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  DateTime captureTimestamp,  int editedBy,  int status,  String thumbnailBase64,  bool hasHighResUpdate)  $default,) {final _that = this;
switch (_that) {
case _SyncStudentMetadata():
return $default(_that.studentId,_that.captureTimestamp,_that.editedBy,_that.status,_that.thumbnailBase64,_that.hasHighResUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  DateTime captureTimestamp,  int editedBy,  int status,  String thumbnailBase64,  bool hasHighResUpdate)?  $default,) {final _that = this;
switch (_that) {
case _SyncStudentMetadata() when $default != null:
return $default(_that.studentId,_that.captureTimestamp,_that.editedBy,_that.status,_that.thumbnailBase64,_that.hasHighResUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncStudentMetadata implements SyncStudentMetadata {
  const _SyncStudentMetadata({required this.studentId, required this.captureTimestamp, required this.editedBy, required this.status, required this.thumbnailBase64, required this.hasHighResUpdate});
  factory _SyncStudentMetadata.fromJson(Map<String, dynamic> json) => _$SyncStudentMetadataFromJson(json);

@override final  String studentId;
@override final  DateTime captureTimestamp;
@override final  int editedBy;
@override final  int status;
@override final  String thumbnailBase64;
@override final  bool hasHighResUpdate;

/// Create a copy of SyncStudentMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStudentMetadataCopyWith<_SyncStudentMetadata> get copyWith => __$SyncStudentMetadataCopyWithImpl<_SyncStudentMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncStudentMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncStudentMetadata&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.captureTimestamp, captureTimestamp) || other.captureTimestamp == captureTimestamp)&&(identical(other.editedBy, editedBy) || other.editedBy == editedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.thumbnailBase64, thumbnailBase64) || other.thumbnailBase64 == thumbnailBase64)&&(identical(other.hasHighResUpdate, hasHighResUpdate) || other.hasHighResUpdate == hasHighResUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,captureTimestamp,editedBy,status,thumbnailBase64,hasHighResUpdate);

@override
String toString() {
  return 'SyncStudentMetadata(studentId: $studentId, captureTimestamp: $captureTimestamp, editedBy: $editedBy, status: $status, thumbnailBase64: $thumbnailBase64, hasHighResUpdate: $hasHighResUpdate)';
}


}

/// @nodoc
abstract mixin class _$SyncStudentMetadataCopyWith<$Res> implements $SyncStudentMetadataCopyWith<$Res> {
  factory _$SyncStudentMetadataCopyWith(_SyncStudentMetadata value, $Res Function(_SyncStudentMetadata) _then) = __$SyncStudentMetadataCopyWithImpl;
@override @useResult
$Res call({
 String studentId, DateTime captureTimestamp, int editedBy, int status, String thumbnailBase64, bool hasHighResUpdate
});




}
/// @nodoc
class __$SyncStudentMetadataCopyWithImpl<$Res>
    implements _$SyncStudentMetadataCopyWith<$Res> {
  __$SyncStudentMetadataCopyWithImpl(this._self, this._then);

  final _SyncStudentMetadata _self;
  final $Res Function(_SyncStudentMetadata) _then;

/// Create a copy of SyncStudentMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? captureTimestamp = null,Object? editedBy = null,Object? status = null,Object? thumbnailBase64 = null,Object? hasHighResUpdate = null,}) {
  return _then(_SyncStudentMetadata(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,captureTimestamp: null == captureTimestamp ? _self.captureTimestamp : captureTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,editedBy: null == editedBy ? _self.editedBy : editedBy // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,thumbnailBase64: null == thumbnailBase64 ? _self.thumbnailBase64 : thumbnailBase64 // ignore: cast_nullable_to_non_nullable
as String,hasHighResUpdate: null == hasHighResUpdate ? _self.hasHighResUpdate : hasHighResUpdate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SyncFailedId {

 String get studentId; String get error;
/// Create a copy of SyncFailedId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncFailedIdCopyWith<SyncFailedId> get copyWith => _$SyncFailedIdCopyWithImpl<SyncFailedId>(this as SyncFailedId, _$identity);

  /// Serializes this SyncFailedId to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncFailedId&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,error);

@override
String toString() {
  return 'SyncFailedId(studentId: $studentId, error: $error)';
}


}

/// @nodoc
abstract mixin class $SyncFailedIdCopyWith<$Res>  {
  factory $SyncFailedIdCopyWith(SyncFailedId value, $Res Function(SyncFailedId) _then) = _$SyncFailedIdCopyWithImpl;
@useResult
$Res call({
 String studentId, String error
});




}
/// @nodoc
class _$SyncFailedIdCopyWithImpl<$Res>
    implements $SyncFailedIdCopyWith<$Res> {
  _$SyncFailedIdCopyWithImpl(this._self, this._then);

  final SyncFailedId _self;
  final $Res Function(SyncFailedId) _then;

/// Create a copy of SyncFailedId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? error = null,}) {
  return _then(_self.copyWith(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncFailedId].
extension SyncFailedIdPatterns on SyncFailedId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncFailedId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncFailedId() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncFailedId value)  $default,){
final _that = this;
switch (_that) {
case _SyncFailedId():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncFailedId value)?  $default,){
final _that = this;
switch (_that) {
case _SyncFailedId() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncFailedId() when $default != null:
return $default(_that.studentId,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String error)  $default,) {final _that = this;
switch (_that) {
case _SyncFailedId():
return $default(_that.studentId,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String error)?  $default,) {final _that = this;
switch (_that) {
case _SyncFailedId() when $default != null:
return $default(_that.studentId,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncFailedId implements SyncFailedId {
  const _SyncFailedId({required this.studentId, required this.error});
  factory _SyncFailedId.fromJson(Map<String, dynamic> json) => _$SyncFailedIdFromJson(json);

@override final  String studentId;
@override final  String error;

/// Create a copy of SyncFailedId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncFailedIdCopyWith<_SyncFailedId> get copyWith => __$SyncFailedIdCopyWithImpl<_SyncFailedId>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncFailedIdToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncFailedId&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,error);

@override
String toString() {
  return 'SyncFailedId(studentId: $studentId, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SyncFailedIdCopyWith<$Res> implements $SyncFailedIdCopyWith<$Res> {
  factory _$SyncFailedIdCopyWith(_SyncFailedId value, $Res Function(_SyncFailedId) _then) = __$SyncFailedIdCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String error
});




}
/// @nodoc
class __$SyncFailedIdCopyWithImpl<$Res>
    implements _$SyncFailedIdCopyWith<$Res> {
  __$SyncFailedIdCopyWithImpl(this._self, this._then);

  final _SyncFailedId _self;
  final $Res Function(_SyncFailedId) _then;

/// Create a copy of SyncFailedId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? error = null,}) {
  return _then(_SyncFailedId(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SyncBatchResponse {

 String get status; List<SyncFailedId> get failedIds;
/// Create a copy of SyncBatchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncBatchResponseCopyWith<SyncBatchResponse> get copyWith => _$SyncBatchResponseCopyWithImpl<SyncBatchResponse>(this as SyncBatchResponse, _$identity);

  /// Serializes this SyncBatchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncBatchResponse&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.failedIds, failedIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(failedIds));

@override
String toString() {
  return 'SyncBatchResponse(status: $status, failedIds: $failedIds)';
}


}

/// @nodoc
abstract mixin class $SyncBatchResponseCopyWith<$Res>  {
  factory $SyncBatchResponseCopyWith(SyncBatchResponse value, $Res Function(SyncBatchResponse) _then) = _$SyncBatchResponseCopyWithImpl;
@useResult
$Res call({
 String status, List<SyncFailedId> failedIds
});




}
/// @nodoc
class _$SyncBatchResponseCopyWithImpl<$Res>
    implements $SyncBatchResponseCopyWith<$Res> {
  _$SyncBatchResponseCopyWithImpl(this._self, this._then);

  final SyncBatchResponse _self;
  final $Res Function(SyncBatchResponse) _then;

/// Create a copy of SyncBatchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failedIds = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failedIds: null == failedIds ? _self.failedIds : failedIds // ignore: cast_nullable_to_non_nullable
as List<SyncFailedId>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncBatchResponse].
extension SyncBatchResponsePatterns on SyncBatchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncBatchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncBatchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncBatchResponse value)  $default,){
final _that = this;
switch (_that) {
case _SyncBatchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncBatchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SyncBatchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  List<SyncFailedId> failedIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncBatchResponse() when $default != null:
return $default(_that.status,_that.failedIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  List<SyncFailedId> failedIds)  $default,) {final _that = this;
switch (_that) {
case _SyncBatchResponse():
return $default(_that.status,_that.failedIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  List<SyncFailedId> failedIds)?  $default,) {final _that = this;
switch (_that) {
case _SyncBatchResponse() when $default != null:
return $default(_that.status,_that.failedIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncBatchResponse implements SyncBatchResponse {
  const _SyncBatchResponse({required this.status, final  List<SyncFailedId> failedIds = const []}): _failedIds = failedIds;
  factory _SyncBatchResponse.fromJson(Map<String, dynamic> json) => _$SyncBatchResponseFromJson(json);

@override final  String status;
 final  List<SyncFailedId> _failedIds;
@override@JsonKey() List<SyncFailedId> get failedIds {
  if (_failedIds is EqualUnmodifiableListView) return _failedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedIds);
}


/// Create a copy of SyncBatchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncBatchResponseCopyWith<_SyncBatchResponse> get copyWith => __$SyncBatchResponseCopyWithImpl<_SyncBatchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncBatchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncBatchResponse&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._failedIds, _failedIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_failedIds));

@override
String toString() {
  return 'SyncBatchResponse(status: $status, failedIds: $failedIds)';
}


}

/// @nodoc
abstract mixin class _$SyncBatchResponseCopyWith<$Res> implements $SyncBatchResponseCopyWith<$Res> {
  factory _$SyncBatchResponseCopyWith(_SyncBatchResponse value, $Res Function(_SyncBatchResponse) _then) = __$SyncBatchResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, List<SyncFailedId> failedIds
});




}
/// @nodoc
class __$SyncBatchResponseCopyWithImpl<$Res>
    implements _$SyncBatchResponseCopyWith<$Res> {
  __$SyncBatchResponseCopyWithImpl(this._self, this._then);

  final _SyncBatchResponse _self;
  final $Res Function(_SyncBatchResponse) _then;

/// Create a copy of SyncBatchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failedIds = null,}) {
  return _then(_SyncBatchResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failedIds: null == failedIds ? _self._failedIds : failedIds // ignore: cast_nullable_to_non_nullable
as List<SyncFailedId>,
  ));
}


}

// dart format on

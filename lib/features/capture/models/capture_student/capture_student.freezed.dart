// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CaptureStudent {

 String get orderId; String get studentId; String get admNo; String get name; int get status; DateTime get updatedAt; Map<String, dynamic> get details; String? get photoUrl; String? get thumbnailUrl; DateTime? get captureTimestamp; int? get editedBy; String? get localHighResPath; String? get localThumbnailPath; SyncStatus get syncStatus; bool get isLocalNew;
/// Create a copy of CaptureStudent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaptureStudentCopyWith<CaptureStudent> get copyWith => _$CaptureStudentCopyWithImpl<CaptureStudent>(this as CaptureStudent, _$identity);

  /// Serializes this CaptureStudent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaptureStudent&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.admNo, admNo) || other.admNo == admNo)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.captureTimestamp, captureTimestamp) || other.captureTimestamp == captureTimestamp)&&(identical(other.editedBy, editedBy) || other.editedBy == editedBy)&&(identical(other.localHighResPath, localHighResPath) || other.localHighResPath == localHighResPath)&&(identical(other.localThumbnailPath, localThumbnailPath) || other.localThumbnailPath == localThumbnailPath)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.isLocalNew, isLocalNew) || other.isLocalNew == isLocalNew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,studentId,admNo,name,status,updatedAt,const DeepCollectionEquality().hash(details),photoUrl,thumbnailUrl,captureTimestamp,editedBy,localHighResPath,localThumbnailPath,syncStatus,isLocalNew);

@override
String toString() {
  return 'CaptureStudent(orderId: $orderId, studentId: $studentId, admNo: $admNo, name: $name, status: $status, updatedAt: $updatedAt, details: $details, photoUrl: $photoUrl, thumbnailUrl: $thumbnailUrl, captureTimestamp: $captureTimestamp, editedBy: $editedBy, localHighResPath: $localHighResPath, localThumbnailPath: $localThumbnailPath, syncStatus: $syncStatus, isLocalNew: $isLocalNew)';
}


}

/// @nodoc
abstract mixin class $CaptureStudentCopyWith<$Res>  {
  factory $CaptureStudentCopyWith(CaptureStudent value, $Res Function(CaptureStudent) _then) = _$CaptureStudentCopyWithImpl;
@useResult
$Res call({
 String orderId, String studentId, String admNo, String name, int status, DateTime updatedAt, Map<String, dynamic> details, String? photoUrl, String? thumbnailUrl, DateTime? captureTimestamp, int? editedBy, String? localHighResPath, String? localThumbnailPath, SyncStatus syncStatus, bool isLocalNew
});




}
/// @nodoc
class _$CaptureStudentCopyWithImpl<$Res>
    implements $CaptureStudentCopyWith<$Res> {
  _$CaptureStudentCopyWithImpl(this._self, this._then);

  final CaptureStudent _self;
  final $Res Function(CaptureStudent) _then;

/// Create a copy of CaptureStudent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? studentId = null,Object? admNo = null,Object? name = null,Object? status = null,Object? updatedAt = null,Object? details = null,Object? photoUrl = freezed,Object? thumbnailUrl = freezed,Object? captureTimestamp = freezed,Object? editedBy = freezed,Object? localHighResPath = freezed,Object? localThumbnailPath = freezed,Object? syncStatus = null,Object? isLocalNew = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,admNo: null == admNo ? _self.admNo : admNo // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,captureTimestamp: freezed == captureTimestamp ? _self.captureTimestamp : captureTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,editedBy: freezed == editedBy ? _self.editedBy : editedBy // ignore: cast_nullable_to_non_nullable
as int?,localHighResPath: freezed == localHighResPath ? _self.localHighResPath : localHighResPath // ignore: cast_nullable_to_non_nullable
as String?,localThumbnailPath: freezed == localThumbnailPath ? _self.localThumbnailPath : localThumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,isLocalNew: null == isLocalNew ? _self.isLocalNew : isLocalNew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CaptureStudent].
extension CaptureStudentPatterns on CaptureStudent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaptureStudent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaptureStudent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaptureStudent value)  $default,){
final _that = this;
switch (_that) {
case _CaptureStudent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaptureStudent value)?  $default,){
final _that = this;
switch (_that) {
case _CaptureStudent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String studentId,  String admNo,  String name,  int status,  DateTime updatedAt,  Map<String, dynamic> details,  String? photoUrl,  String? thumbnailUrl,  DateTime? captureTimestamp,  int? editedBy,  String? localHighResPath,  String? localThumbnailPath,  SyncStatus syncStatus,  bool isLocalNew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaptureStudent() when $default != null:
return $default(_that.orderId,_that.studentId,_that.admNo,_that.name,_that.status,_that.updatedAt,_that.details,_that.photoUrl,_that.thumbnailUrl,_that.captureTimestamp,_that.editedBy,_that.localHighResPath,_that.localThumbnailPath,_that.syncStatus,_that.isLocalNew);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String studentId,  String admNo,  String name,  int status,  DateTime updatedAt,  Map<String, dynamic> details,  String? photoUrl,  String? thumbnailUrl,  DateTime? captureTimestamp,  int? editedBy,  String? localHighResPath,  String? localThumbnailPath,  SyncStatus syncStatus,  bool isLocalNew)  $default,) {final _that = this;
switch (_that) {
case _CaptureStudent():
return $default(_that.orderId,_that.studentId,_that.admNo,_that.name,_that.status,_that.updatedAt,_that.details,_that.photoUrl,_that.thumbnailUrl,_that.captureTimestamp,_that.editedBy,_that.localHighResPath,_that.localThumbnailPath,_that.syncStatus,_that.isLocalNew);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String studentId,  String admNo,  String name,  int status,  DateTime updatedAt,  Map<String, dynamic> details,  String? photoUrl,  String? thumbnailUrl,  DateTime? captureTimestamp,  int? editedBy,  String? localHighResPath,  String? localThumbnailPath,  SyncStatus syncStatus,  bool isLocalNew)?  $default,) {final _that = this;
switch (_that) {
case _CaptureStudent() when $default != null:
return $default(_that.orderId,_that.studentId,_that.admNo,_that.name,_that.status,_that.updatedAt,_that.details,_that.photoUrl,_that.thumbnailUrl,_that.captureTimestamp,_that.editedBy,_that.localHighResPath,_that.localThumbnailPath,_that.syncStatus,_that.isLocalNew);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaptureStudent implements CaptureStudent {
  const _CaptureStudent({required this.orderId, required this.studentId, required this.admNo, required this.name, required this.status, required this.updatedAt, required final  Map<String, dynamic> details, this.photoUrl, this.thumbnailUrl, this.captureTimestamp, this.editedBy, this.localHighResPath, this.localThumbnailPath, this.syncStatus = SyncStatus.synced, this.isLocalNew = false}): _details = details;
  factory _CaptureStudent.fromJson(Map<String, dynamic> json) => _$CaptureStudentFromJson(json);

@override final  String orderId;
@override final  String studentId;
@override final  String admNo;
@override final  String name;
@override final  int status;
@override final  DateTime updatedAt;
 final  Map<String, dynamic> _details;
@override Map<String, dynamic> get details {
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_details);
}

@override final  String? photoUrl;
@override final  String? thumbnailUrl;
@override final  DateTime? captureTimestamp;
@override final  int? editedBy;
@override final  String? localHighResPath;
@override final  String? localThumbnailPath;
@override@JsonKey() final  SyncStatus syncStatus;
@override@JsonKey() final  bool isLocalNew;

/// Create a copy of CaptureStudent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaptureStudentCopyWith<_CaptureStudent> get copyWith => __$CaptureStudentCopyWithImpl<_CaptureStudent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaptureStudentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureStudent&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.admNo, admNo) || other.admNo == admNo)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._details, _details)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.captureTimestamp, captureTimestamp) || other.captureTimestamp == captureTimestamp)&&(identical(other.editedBy, editedBy) || other.editedBy == editedBy)&&(identical(other.localHighResPath, localHighResPath) || other.localHighResPath == localHighResPath)&&(identical(other.localThumbnailPath, localThumbnailPath) || other.localThumbnailPath == localThumbnailPath)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.isLocalNew, isLocalNew) || other.isLocalNew == isLocalNew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,studentId,admNo,name,status,updatedAt,const DeepCollectionEquality().hash(_details),photoUrl,thumbnailUrl,captureTimestamp,editedBy,localHighResPath,localThumbnailPath,syncStatus,isLocalNew);

@override
String toString() {
  return 'CaptureStudent(orderId: $orderId, studentId: $studentId, admNo: $admNo, name: $name, status: $status, updatedAt: $updatedAt, details: $details, photoUrl: $photoUrl, thumbnailUrl: $thumbnailUrl, captureTimestamp: $captureTimestamp, editedBy: $editedBy, localHighResPath: $localHighResPath, localThumbnailPath: $localThumbnailPath, syncStatus: $syncStatus, isLocalNew: $isLocalNew)';
}


}

/// @nodoc
abstract mixin class _$CaptureStudentCopyWith<$Res> implements $CaptureStudentCopyWith<$Res> {
  factory _$CaptureStudentCopyWith(_CaptureStudent value, $Res Function(_CaptureStudent) _then) = __$CaptureStudentCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String studentId, String admNo, String name, int status, DateTime updatedAt, Map<String, dynamic> details, String? photoUrl, String? thumbnailUrl, DateTime? captureTimestamp, int? editedBy, String? localHighResPath, String? localThumbnailPath, SyncStatus syncStatus, bool isLocalNew
});




}
/// @nodoc
class __$CaptureStudentCopyWithImpl<$Res>
    implements _$CaptureStudentCopyWith<$Res> {
  __$CaptureStudentCopyWithImpl(this._self, this._then);

  final _CaptureStudent _self;
  final $Res Function(_CaptureStudent) _then;

/// Create a copy of CaptureStudent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? studentId = null,Object? admNo = null,Object? name = null,Object? status = null,Object? updatedAt = null,Object? details = null,Object? photoUrl = freezed,Object? thumbnailUrl = freezed,Object? captureTimestamp = freezed,Object? editedBy = freezed,Object? localHighResPath = freezed,Object? localThumbnailPath = freezed,Object? syncStatus = null,Object? isLocalNew = null,}) {
  return _then(_CaptureStudent(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,admNo: null == admNo ? _self.admNo : admNo // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,captureTimestamp: freezed == captureTimestamp ? _self.captureTimestamp : captureTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,editedBy: freezed == editedBy ? _self.editedBy : editedBy // ignore: cast_nullable_to_non_nullable
as int?,localHighResPath: freezed == localHighResPath ? _self.localHighResPath : localHighResPath // ignore: cast_nullable_to_non_nullable
as String?,localThumbnailPath: freezed == localThumbnailPath ? _self.localThumbnailPath : localThumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,isLocalNew: null == isLocalNew ? _self.isLocalNew : isLocalNew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

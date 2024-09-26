import 'dart:async';

typedef Json = Map<String, dynamic>;
typedef FromJson<T> = FutureOr<T> Function(Json json);
typedef ToJson<T> = FutureOr<Json> Function(T object);

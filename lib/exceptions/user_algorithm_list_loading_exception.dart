import 'dart:io';

class UserAlgorithmListLoadingException {
  const UserAlgorithmListLoadingException({
    required this.error,
    required this.failureFile,
  });

  final Object error;
  final File failureFile;

  @override
  String toString() {
    return 'A failure happened in when loading a user algorithm from ${failureFile.absolute.path} file.\nLow level error: $error';
  }
}

// ignore_for_file: constant_identifier_names

enum ResponseState { LOADING, DATA, ERROR }

class ResponseStatus {
  String? message;
  ResponseState? responseState;
  dynamic data;

  ResponseStatus({this.message, this.responseState, this.data});
}

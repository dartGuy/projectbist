
class ApiResponse {
  final String message;
  bool? status;
  dynamic data;

  ApiResponse({required this.message, this.status = false, this.data});

  factory ApiResponse.fromJson({required Map<String, dynamic> json}) {
    return ApiResponse(
        message: json["message"], status: json["status"], data: json["data"]);
  }
}

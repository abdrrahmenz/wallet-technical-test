class MetaError {
  final int code;
  final String error;
  final String message;

  MetaError({required this.code, required this.error, required this.message});

  factory MetaError.fromJson(Map<String, dynamic> json) {
    // Handle message field that can be either String or List<String>
    String parseMessage(dynamic messageData) {
      if (messageData == null) {
        return 'An error occurred';
      } else if (messageData is String) {
        return messageData;
      } else if (messageData is List) {
        // Join array messages with a separator
        return messageData.map((e) => e.toString()).join(', ');
      } else {
        return messageData.toString();
      }
    }

    return MetaError(
      code: json['statusCode'] ?? json['status'] ?? json['code'] ?? 0,
      error: json['error'] ?? json['type'] ?? 'Unknown Error',
      message: parseMessage(json['message'] ?? json['msg']),
    );
  }
}

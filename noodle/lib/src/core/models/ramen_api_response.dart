class RamenApiResponse {
  final String path;
  final String message;

  RamenApiResponse(this.path, this.message);

  RamenApiResponse.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
        'path': path,
        'message': message,
      };
}
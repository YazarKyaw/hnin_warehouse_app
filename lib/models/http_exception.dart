class HttpException with Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

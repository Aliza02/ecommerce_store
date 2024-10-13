class NetworkEventResponse<T> {
  final T? data;
  final String? message;
  final bool? status;
  final T? response;

  const NetworkEventResponse.failure(
      {this.response, this.data, this.message, this.status});
  const NetworkEventResponse.success(
      {this.response, this.data, this.message, this.status});
}

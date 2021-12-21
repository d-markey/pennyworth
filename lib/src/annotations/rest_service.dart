class RestService {
  const RestService(String uri, {this.title, this.tags, this.middleware})
      // ignore: prefer_initializing_formals
      : uri = uri;

  const RestService.middleware(this.middleware)
      : uri = null,
        title = null,
        tags = null;

  final String? uri;
  final String? title;
  final List<String>? tags;
  final List<List>? middleware;
}

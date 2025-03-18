class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogUploadSuccess extends BlogState {
  BlogUploadSuccess();
}

class BlogFailure extends BlogState {
  final String error;
  BlogFailure(this.error);
}

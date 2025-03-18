import 'package:bloc/bloc.dart';

import 'blog_event.dart';
import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc() : super(BlogInitial()) {
    //  on<InitEvent>(_init);
  }

  // void _init(InitEvent event, Emitter<BlogState> emit) async {
  //   emit(state.clone());
  // }
}

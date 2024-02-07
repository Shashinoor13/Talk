import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/bloc/post/post_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController postScrollController = ScrollController();
    postScrollController.addListener(() {
      //if at the end of list
      if (postScrollController.position.pixels ==
          postScrollController.position.maxScrollExtent) {
        context.read<PostBloc>().add(const LoadMorePosts());
      }
    });
    // context.read<PostBloc>().add(const GetInitialPosts());
    return Scaffold(
      body: BlocConsumer<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const CircularProgressIndicator();
          }
          if (state is PostsLoaded) {
            return ListView.builder(
              controller: postScrollController,
              cacheExtent: 10,
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: ListTile(
                    title: Text(state.posts[index].title),
                    subtitle: Text('Subtitle'),
                  ),
                );
              },
            );
          }
          return Container();
        },
        listener: (BuildContext context, PostState state) {
          if (state is PostLoadingFailure) {
            print(state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
          if (state is PostsLoaded) {
            print('PostsLoaded');
            // print(state.posts.data.length);
          }
          if (state is LoadMorePosts) {
            print("Need to laod more posts");
          }
        },
      ),
    );
  }
}

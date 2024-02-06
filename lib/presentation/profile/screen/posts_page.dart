import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';

import 'package:talk/bloc/post/post_bloc.dart';
import 'package:talk/presentation/profile/screen/add_new_post.dart';
import 'package:talk/presentation/profile/screen/cubit/addPost/add_post_cubit.dart';

class MyPostsPage extends StatelessWidget {
  final String userId;
  const MyPostsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    SlidingUpPanelController panelController = SlidingUpPanelController();
    context.read<PostBloc>().add(GetUserPosts(userId: userId));
    return Scaffold(
      floatingActionButton: BlocBuilder<AddPostCubit, AddPostState>(
        builder: (context, state) {
          if (state is AddPostOpened) return Container();
          return FloatingActionButton(
            onPressed: () {
              if (state is AddPostClosed) {
                context.read<AddPostCubit>().openPanel();
              }
              if (state is AddPostOpened) {
                context.read<AddPostCubit>().closePanel();
              }
            },
            child: const Icon(Icons.add),
          );
        },
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is PostsLoaded) {
                    return ListView.builder(
                      itemCount: state.posts.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.posts.data[index]['title']),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
            BlocConsumer<AddPostCubit, AddPostState>(
              listener: (context, state) {
                if (state is AddPostOpened) {
                  panelController.expand();
                }
                if (state is AddPostClosed) {
                  panelController.collapse();
                }
              },
              builder: (context, state) {
                return SlidingUpPanelWidget(
                  controlHeight: 0,
                  anchor: 1,
                  panelController: state is AddPostOpened
                      ? context.read<AddPostCubit>().panelController
                      : panelController,
                  enableOnTap: false,
                  onStatusChanged: (status) {
                    if (status == SlidingUpPanelStatus.expanded) {
                      context.read<AddPostCubit>().openPanel();
                    }
                    if (status == SlidingUpPanelStatus.collapsed) {
                      context.read<AddPostCubit>().closePanel();
                    }
                  },
                  child: AddNewPostPage(
                    panelController: panelController,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

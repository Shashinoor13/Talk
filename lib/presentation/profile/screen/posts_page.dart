import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:go_router/go_router.dart';

import 'package:talk/bloc/post/post_bloc.dart';
import 'package:talk/presentation/profile/screen/add_new_post.dart';
import 'package:talk/presentation/profile/screen/cubit/addPost/add_post_cubit.dart';
import 'package:talk/presentation/profile/screen/cubit/imageSelect/image_select_cubit.dart';
import 'package:talk/routes/constants.dart';

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
              child: BlocConsumer<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is PostsLoaded) {
                    // if (state.posts.data.isEmpty) {
                    //   return Center(
                    //     child: Text("No Posts"),
                    //   );
                    // }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<PostBloc>()
                            .add(GetUserPosts(userId: userId));
                      },
                      child: ListView.builder(
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.posts[index].title),
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                },
                listener: (BuildContext context, PostState state) {
                  if (state is PostSuccess) {
                    GoRouter.of(context).goNamed(
                        AppRouteConstantsPrivate.myPost,
                        queryParameters: {
                          'id': FirebaseAuth.instance.currentUser!.uid,
                        });
                  }
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
                if (state is AddingPost) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Adding Post"),
                    ),
                  );
                }
                if (state is PostAdded) {
                  context.read<ImageSelectCubit>().clearImages();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.responseModel.message),
                    ),
                  );
                }
                if (state is PostAddingFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
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
                  child: AddNewPostPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

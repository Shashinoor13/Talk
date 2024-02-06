import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/bloc/auth/auth_bloc.dart';
import 'package:talk/bloc/post/post_bloc.dart';
import 'package:talk/data/model/post_model.dart';
import 'package:talk/data/model/user_model.dart';
import 'package:talk/routes/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text('Profile Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                  },
                  child: const Text('SignOut'),
                ),
                TextButton(
                    onPressed: generateNewPost, child: Text("Generate a Post")),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is AuthSignedIn) {
                      return Text(state.user.email.toString());
                    }
                    return Container();
                  },
                ),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading) {
                      return const CircularProgressIndicator();
                    }
                    return Container(
                      child: TextButton(
                        onPressed: () {
                          final post = generateNewPost();
                          context
                              .read<PostBloc>()
                              .add(PostCreate(postModel: post));
                        },
                        child: Text("Add Post"),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(
                        AppRouteConstantsPrivate.myPost,
                        pathParameters: {
                          "id": FirebaseAuth.instance.currentUser!.uid,
                        });
                  },
                  child: Text("View Posts"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PostModel generateNewPost() {
    final UserModel _user = UserModel.generateUserModelFromFirebaseUser(
        user: FirebaseAuth.instance.currentUser!);
    final post = PostModel(
      title: 'New Post',
      body: 'This is a new post',
      caption: 'New Post',
      imageUrl: 'https://www.google.com',
      location: 'New York',
      user: _user,
    );
    return post;
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/presentation/profile/screen/cubit/addPost/add_post_cubit.dart';
import 'package:talk/presentation/profile/screen/cubit/imageSelect/image_select_cubit.dart';

class AddNewPostPage extends StatelessWidget {
  AddNewPostPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<AddPostCubit, AddPostState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                context.read<AddPostCubit>().closePanel();
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Create New Post",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: BlocBuilder<ImageSelectCubit, ImageSelectState>(
              builder: (context, state) {
                List<File> images = [];
                if (state is ImageSelectLoaded) {
                  images = state.images.map((e) => File(e.path)).toList();
                }
                return TextButton(
                  onPressed: () {
                    //post the new post
                    context.read<AddPostCubit>().addPost(
                          text: _postTextController.text,
                          images: images,
                        );
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<AddPostCubit, AddPostState>(
        builder: (context, state) {
          if (state is AddingPost) {
            return const Center(
              //TODO : Replace with a Good Animation
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          "https://images.inc.com/uploaded_files/image/1920x1080/getty_481292845_77896.jpg",
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Shashinoor Ghimire",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _postTextController,
                          decoration: const InputDecoration(
                            hintText: "Start writing your post...,",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            focusedBorder: InputBorder.none,
                          ),
                          cursorColor: Colors.grey,
                          maxLines: 4,
                          onTapOutside: (controller) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        BlocConsumer<ImageSelectCubit, ImageSelectState>(
                          builder: (context, state) {
                            if (state is ImageSelectInitial) {
                              return const Row(
                                children: [
                                  AddImageButton(),
                                ],
                              );
                            }
                            if (state is ImageSelectLoading) {
                              return const CircularProgressIndicator();
                            }
                            if (state is ImageSelectLoaded) {
                              return Wrap(
                                children: [
                                  ...state.images.map((image) {
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                File(image.path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: IconButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            color: Colors.white,
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<ImageSelectCubit>()
                                                  .removeImage(state.images
                                                      .indexOf(
                                                          state.images[0]));
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                  if (state.images.length < 4)
                                    const AddImageButton(),
                                ],
                              );
                            }
                            return Container();
                          },
                          listener: (context, state) {
                            if (state is ImageSelectLoaded) {}
                            return;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ImageSelectCubit>().pickImage();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 150,
            width: 150,
            color: Colors.grey[200],
            child: const Icon(
              Icons.image,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

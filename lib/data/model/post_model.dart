import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talk/data/model/metadata.dart';
import 'package:talk/data/model/user_model.dart';
import 'package:uuid/uuid.dart';

class PostModel {
  final String title;
  final String body;
  final String caption;
  final List<dynamic> imageUrl;
  final String location;
  final UserModel user;
  String? postId;
  String? date;
  AppMetadata? metadata;

  PostModel({
    required this.title,
    required this.body,
    required this.caption,
    required this.imageUrl,
    required this.location,
    required this.user,
    AppMetadata? metadata,
  }) {
    date = DateTime.now().toString();
    postId = const Uuid().v4();
    this.metadata = generateMetadata();
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'title': title,
      'body': body,
      'caption': caption,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'user': user.toMap(),
      'metadata': metadata!.toMap(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      title: map['title'],
      body: map['body'],
      caption: map['caption'],
      imageUrl: map['imageUrl'],
      location: map['location'],
      user: UserModel.fromMap(map['user']),
      metadata: AppMetadata.fromMap(map['metadata']),
    );
  }

  factory PostModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PostModel(
      title: data['title'],
      body: data['body'],
      caption: data['caption'],
      imageUrl: data['imageUrl'],
      location: data['location'],
      user: UserModel.fromMap(data['user']),
      metadata: AppMetadata.fromMap(data['metadata']),
    );
  }

  AppMetadata generateMetadata() {
    return AppMetadata(
      name: title,
      value: postId.toString(),
      type: 'post',
      description: '${user.name} posted a new post',
      keywords: title.split(' '),
    );
  }

  //copywith
  PostModel copyWith({
    String? title,
    String? body,
    String? caption,
    List<String?>? imageUrl,
    String? location,
    UserModel? user,
    String? postId,
    String? date,
    AppMetadata? metadata,
  }) {
    return PostModel(
      title: title ?? this.title,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      imageUrl: imageUrl != null
          ? imageUrl.where((item) => item != null).toList().cast<String>()
          : this.imageUrl,
      location: location ?? this.location,
      user: user ?? this.user,
      metadata: metadata ?? this.metadata,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

class BlogPostModel {
  final String? _id;
  final String? postedBy;
  final String? title;
  final String? body;
  final List<CoverMediaItem>? coverMedia;
  final int? likes;
  final int? shares;
  final List<Comment>? comments;

  BlogPostModel(
    this._id, {
    this.title,
    this.postedBy,
    this.body,
    this.comments,
    this.coverMedia,
    this.likes,
    this.shares,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': _id,
      'postedBy': postedBy,
      'title': title,
      'body': body,
      'coverMedia': coverMedia,
      'likes': likes,
      'shares': shares,
      'comments': comments,
    };
  }

  factory BlogPostModel.fromJson(Map<String, dynamic> map) {
    List<CoverMediaItem>? newCoverMedia = [];
    List<Comment>? newComments = [];
    for (var item in map['coverMedia']) {
      newCoverMedia.add(CoverMediaItem.fromJson(item));
    }
    for (var comment in map['comments']) {
      newComments.add(comment);
    }
    return BlogPostModel(
      map['_id'] != null ? map['_id'] as String : null,
      postedBy: map['postedBy'] != null ? map['postedBy'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      coverMedia: newCoverMedia,
      likes: map['likes'] != null ? map['likes'] as int : null,
      shares: map['shares'] != null ? map['shares'] as int : null,
      comments: newComments,
    );
  }
}

class Comment {
  String? _id;

  Comment(this._id);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': _id,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
      map['_id'] != null ? map['_id'] as String : null,
    );
  }
}

class CoverMediaItem {
  String? _id;
  String? type;
  String? secureUrl;
  String? publicId;

  CoverMediaItem(
    this._id, {
    this.publicId,
    this.type,
    this.secureUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': _id,
      'type': type,
      'url': secureUrl,
      'publicId': publicId,
    };
  }

  factory CoverMediaItem.fromJson(Map<String, dynamic> map) {
    return CoverMediaItem(
      map['_id'] != null ? map['_id'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      secureUrl: map['secureUrl'] != null ? map['secureUrl'] as String : null,
      publicId: map['publicId'] != null ? map['publicId'] as String : null,
    );
  }
}

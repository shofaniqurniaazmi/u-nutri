class News {
  String? status;
  int? totalResults;
  List<Results>? results;
  String? nextPage;

  News({this.status, this.totalResults, this.results, this.nextPage});

  News.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['nextPage'] = nextPage;
    return data;
  }
}

class Results {
  String? articleId;
  String? title;
  String? link;
  List<String>? keywords;
  Null creator;
  Null videoUrl;
  String? description;
  String? content;
  String? pubDate;
  String? imageUrl;
  String? sourceId;
  int? sourcePriority;
  String? sourceName;
  String? sourceUrl;
  String? sourceIcon;
  String? language;
  List<String>? country;
  List<String>? category;
  String? aiTag;
  String? sentiment;
  String? sentimentStats;
  String? aiRegion;
  String? aiOrg;
  bool? duplicate;

  Results(
      {this.articleId,
      this.title,
      this.link,
      this.keywords,
      this.creator,
      this.videoUrl,
      this.description,
      this.content,
      this.pubDate,
      this.imageUrl,
      this.sourceId,
      this.sourcePriority,
      this.sourceName,
      this.sourceUrl,
      this.sourceIcon,
      this.language,
      this.country,
      this.category,
      this.aiTag,
      this.sentiment,
      this.sentimentStats,
      this.aiRegion,
      this.aiOrg,
      this.duplicate});

  Results.fromJson(Map<String, dynamic> json) {
    articleId = json['article_id'];
    title = json['title'];
    link = json['link'];
    keywords = json['keywords'].cast<String>();
    creator = json['creator'];
    videoUrl = json['video_url'];
    description = json['description'];
    content = json['content'];
    pubDate = json['pubDate'];
    imageUrl = json['image_url'];
    sourceId = json['source_id'];
    sourcePriority = json['source_priority'];
    sourceName = json['source_name'];
    sourceUrl = json['source_url'];
    sourceIcon = json['source_icon'];
    language = json['language'];
    country = json['country'].cast<String>();
    category = json['category'].cast<String>();
    aiTag = json['ai_tag'];
    sentiment = json['sentiment'];
    sentimentStats = json['sentiment_stats'];
    aiRegion = json['ai_region'];
    aiOrg = json['ai_org'];
    duplicate = json['duplicate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['article_id'] = articleId;
    data['title'] = title;
    data['link'] = link;
    data['keywords'] = keywords;
    data['creator'] = creator;
    data['video_url'] = videoUrl;
    data['description'] = description;
    data['content'] = content;
    data['pubDate'] = pubDate;
    data['image_url'] = imageUrl;
    data['source_id'] = sourceId;
    data['source_priority'] = sourcePriority;
    data['source_name'] = sourceName;
    data['source_url'] = sourceUrl;
    data['source_icon'] = sourceIcon;
    data['language'] = language;
    data['country'] = country;
    data['category'] = category;
    data['ai_tag'] = aiTag;
    data['sentiment'] = sentiment;
    data['sentiment_stats'] = sentimentStats;
    data['ai_region'] = aiRegion;
    data['ai_org'] = aiOrg;
    data['duplicate'] = duplicate;
    return data;
  }
}

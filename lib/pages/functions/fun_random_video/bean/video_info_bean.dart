class VideoFatherInfoBean {
  VideoFatherInfoBean({
    this.itemList,
    this.count,
    this.total,
    this.nextPageUrl,
    this.adExist,
  });

  VideoFatherInfoBean.fromJson(Map<String, dynamic> json) {
    if (json['itemList'] != null) {
      itemList = <VideoInfoBean>[];
      json['itemList'].forEach((v) {
        itemList!.add(VideoInfoBean.fromJson(v));
      });
    }
    count = json['count'];
    total = json['total'];
    nextPageUrl = json['nextPageUrl'];
    adExist = json['adExist'];
  }
  List<VideoInfoBean>? itemList;
  int? count;
  int? total;
  String? nextPageUrl;
  bool? adExist;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (itemList != null) {
      data['itemList'] = itemList!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['total'] = total;
    data['nextPageUrl'] = nextPageUrl;
    data['adExist'] = adExist;
    return data;
  }
}

class VideoInfoBean {
  VideoInfoBean({
    this.type,
    this.data,
  });

  VideoInfoBean.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? type;
  Data? data;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Data({
    this.id,
    this.title,
    this.description,
    this.playUrl,
    this.duration,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];

    playUrl = json['playUrl'];

    duration = json['duration'];
  }
  int? id;
  String? title;
  String? description;
  String? playUrl;
  int? duration;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['description'] = description;

    data['playUrl'] = playUrl;

    data['duration'] = duration;

    return data;
  }
}

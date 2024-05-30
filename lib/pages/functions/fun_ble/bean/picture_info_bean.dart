class FunctionPictureViewBean {
  String? lastUpdate;
  int? total;
  String? language;
  String? message;
  bool? status;
  bool? success;
  String? info;
  List<Data>? data;

  FunctionPictureViewBean(
      {this.lastUpdate,
      this.total,
      this.language,
      this.message,
      this.status,
      this.success,
      this.info,
      this.data});

  FunctionPictureViewBean.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['LastUpdate'];
    total = json['Total'];
    language = json['Language'];
    message = json['message'];
    status = json['status'];
    success = json['success'];
    info = json['info'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['LastUpdate'] = lastUpdate;
    data['Total'] = total;
    data['Language'] = language;
    data['message'] = message;
    data['status'] = status;
    data['success'] = success;
    data['info'] = info;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? startdate;
  String? fullstartdate;
  String? enddate;
  String? url;
  String? urlbase;
  String? copyright;
  String? copyrightlink;
  String? title;

  Data({
    this.startdate,
    this.fullstartdate,
    this.enddate,
    this.url,
    this.urlbase,
    this.copyright,
    this.copyrightlink,
    this.title,
  });

  Data.fromJson(Map<String, dynamic> json) {
    startdate = json['startdate'];
    fullstartdate = json['fullstartdate'];
    enddate = json['enddate'];
    url = json['url'];
    urlbase = json['urlbase'];
    copyright = json['copyright'];
    copyrightlink = json['copyrightlink'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['startdate'] = startdate;
    data['fullstartdate'] = fullstartdate;
    data['enddate'] = enddate;
    data['url'] = url;
    data['urlbase'] = urlbase;
    data['copyright'] = copyright;
    data['copyrightlink'] = copyrightlink;
    data['title'] = title;
    return data;
  }
}

class FunctionPictureCatBean {
  String? id;
  String? url;
  int? width;
  int? height;

  FunctionPictureCatBean({this.id, this.url, this.width, this.height});

  FunctionPictureCatBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class FunctionPictureDogBean {
  String? message;
  String? status;

  FunctionPictureDogBean({this.message, this.status});

  FunctionPictureDogBean.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class FunctionPictureAstronomyBean {
  String? copyright;
  String? date;
  String? explanation;
  String? hdurl;
  String? mediaType;
  String? serviceVersion;
  String? title;
  String? url;

  FunctionPictureAstronomyBean({
    this.copyright,
    this.date,
    this.explanation,
    this.hdurl,
    this.mediaType,
    this.serviceVersion,
    this.title,
    this.url,
  });

  factory FunctionPictureAstronomyBean.fromJson(Map<String, dynamic> json) {
    return FunctionPictureAstronomyBean(
      copyright: json['copyright'],
      date: json['date'],
      explanation: json['explanation'],
      hdurl: json['hdurl'],
      mediaType: json['media_type'],
      serviceVersion: json['service_version'],
      title: json['title'],
      url: json['url'],
    );
  }
}

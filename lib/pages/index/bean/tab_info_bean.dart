class FunctionInfoBean {
  FunctionInfoBean(
      {this.gUID, this.title, this.url, this.iconUrl, this.description});

  FunctionInfoBean.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    url = json['url'];
    iconUrl = json['iconUrl'];
    gUID = json['GUID'];
  }

  String? gUID;
  String? title;
  String? description;
  String? url;
  String? iconUrl;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['GUID'] = gUID;
    data['url'] = url;
    data['iconUrl'] = iconUrl;

    return data;
  }
}

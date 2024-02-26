class MusicInfoBean {
  MusicInfoBean({
    this.name,
    this.artistsname,
    this.picurl,
    this.url,
  });

  MusicInfoBean.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
    artistsname = json['artistsname'];
    picurl = json['picurl'];
  }

  String? name;
  String? artistsname;
  String? picurl;
  String? url;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['artistsname'] = artistsname;
    data['url'] = url;
    data['picurl'] = picurl;

    return data;
  }
}

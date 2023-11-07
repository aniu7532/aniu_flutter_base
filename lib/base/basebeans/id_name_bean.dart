class IdNameBean {
  IdNameBean({
    this.name,
    this.id,
    this.checked,
  });

  IdNameBean.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    checked = json['checked'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['checked'] = checked;
    return data;
  }

  String? id;
  String? name;
  bool? checked;
}

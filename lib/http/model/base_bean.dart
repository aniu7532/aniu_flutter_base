class BaseBean<T> {
  /// {"Result":true,"Type":0,"Title":"提示","Content":"获取数据成功","Extend":T,"Javascript":null,"AutoClose":false}
  bool? result;
  bool? autoClose;
  int? type;
  T? extend;
  String? title;
  String? content;
  dynamic javascript;

  BaseBean({this.result, this.autoClose, this.type, this.extend,  this.content, this.title, this.javascript});

  BaseBean.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    if (json['Extend'] != null) {
      extend = json['Extend'];
    }
    title = json['Title'];
    content = json['Content'];
    type = json['Type'];
  }
}

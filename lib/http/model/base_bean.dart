class BaseBean<T> {
  /// {"Result":true,"Type":0,"Title":"提示","Content":"获取数据成功","Extend":T,"Javascript":null,"AutoClose":false}
  int? code;
  T? data;
  String? msg;

  BaseBean({
    this.code,
    this.data,
    this.msg,
  });

  BaseBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = json['data'];
    }
    msg = json['msg'];
  }
}

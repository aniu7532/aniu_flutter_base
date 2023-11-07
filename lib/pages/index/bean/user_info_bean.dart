class UserInfoBean {
  //{"Result":true,"Type":0,"Title":"提示","Content":"用户验证成功！","Extend":{"Name":"系统管理员","Sex":"男","UserCode":"admin",
  // "DeptName":"综合科","GUID":"5B408040F89E48A1A1C5C4D0C2067175","Icon":null,"PersonId":null,"ValidationType":1},"Javascript":null,"AutoClose":false}
  UserInfoBean({this.name, this.gUID, this.visitNo, this.validationType});

  UserInfoBean.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    visitNo = json['VisitNo'];
    validationType = json['ValidationType'];
    deptName = json['DeptName'];
    deptId = json['DeptId'];
    gUID = json['GUID'];
  }
  String? name;
  String? gUID;
  String? visitNo;
  String? deptName;
  String? deptId;
  int? validationType;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = name;
    data['DeptName'] = deptName;
    data['VisitNo'] = visitNo;
    data['ValidationType'] = validationType;
    data['DeptId'] = deptId;
    data['GUID'] = gUID;

    return data;
  }
}

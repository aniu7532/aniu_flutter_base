import 'package:musico/widgets/file_select/file_bean.dart';

class PickFileEvent {
  PickFileEvent(
    this.type,
    this.files,
  );
  List<FileBean>? files;
  int? type;
}

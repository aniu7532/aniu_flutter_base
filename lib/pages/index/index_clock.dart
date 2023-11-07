import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musico/utils/font_style_utils.dart';

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final dateNow = DateTime.now();
        final week = DateUtil.getWeekday(
          dateNow,
          languageCode: 'zh',
        );
        final date = DateUtil.formatDate(dateNow, format: 'yyyy.MM.dd');
        final time = DateUtil.formatDate(dateNow, format: 'HH:mm:ss');
        return Center(
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    week,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

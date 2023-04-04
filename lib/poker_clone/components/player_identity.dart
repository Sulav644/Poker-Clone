import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../core/utils.dart';

class PlayerIdentity extends StatelessWidget {
  final BuildContext context;
  final double width;
  final String title;
  final int bits;
  const PlayerIdentity(
      {super.key,
      required this.context,
      required this.width,
      required this.title,
      required this.bits});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widthWithScreenRatio(context, width),
        decoration: BoxDecoration(
            color: title.isEmpty
                ? Color.fromARGB(255, 100, 34, 10)
                : Color.fromARGB(255, 44, 13, 2),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: heightWithScreenRatio(context, 0.012)),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white, fontSize: 13),
            child: Row(
                mainAxisAlignment: title.isEmpty
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  title.isEmpty
                      ? Text(
                          '$bits',
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacing().horizontalSpaceWithRatio(context, 0.015),
                            if (title.contains('user'))
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 5,
                              ),
                            Spacing().horizontalSpaceWithRatio(context, 0.005),
                            Text(title),
                            Icon(
                              Icons.card_giftcard,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                  if (title.isNotEmpty && bits != 0)
                    Row(
                      children: [
                        Text('$bits'),
                        Spacing().horizontalSpaceWithRatio(context, 0.04),
                      ],
                    )
                ]),
          ),
        ));
  }
}

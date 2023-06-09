import 'package:flutter/material.dart';
import '../../core/utils.dart';

class SettingsWidgets extends StatelessWidget {
  const SettingsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightWithScreenRatio(context, 0.16),
      child: Row(children: [
        settingChild(context, Colors.black, 'Standard'),
        Spacing().horizontalSpaceWithRatio(context, 0.005),
        settingChild(context, const Color.fromARGB(255, 94, 36, 16), 'vs Bots'),
        Spacing().horizontalSpaceWithRatio(context, 0.015),
        settingIcon(context)
      ]),
    );
  }

  Widget settingIcon(BuildContext context) => Container(
      width: widthWithScreenRatio(context, 0.06),
      height: widthWithScreenRatio(context, 0.06),
      decoration: BoxDecoration(
          color: const Color.fromARGB(0, 199, 197, 197),
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage('assets/images/wood.jpg'), fit: BoxFit.cover),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(-2, 2))
          ]),
      child: Icon(
        Icons.settings,
        size: widthWithScreenRatio(context, 0.044),
        color: Colors.white,
      ));

  Widget settingChild(
    BuildContext context,
    Color color,
    String title,
  ) =>
      Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: heightWithScreenRatio(context, 0.015),
                horizontal: widthWithScreenRatio(context, 0.01)),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ));
}

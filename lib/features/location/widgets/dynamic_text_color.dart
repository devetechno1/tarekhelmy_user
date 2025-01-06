import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class DynamicTextColor extends StatelessWidget {
  final String dynamicText;
  const DynamicTextColor({super.key, required this.dynamicText});

  @override
  Widget build(BuildContext context) {
    List<String> words = dynamicText.split(' ');

    String lastWord = '';
    String secondLastWord = '';
    String thirdLastWord = '';
    String remainingText = '';
    String secondRemainingText = dynamicText;

    if (words.length >= 3) {
      lastWord = words.removeLast();
      secondLastWord = words.removeLast();
      thirdLastWord = words.removeLast();
    } else if (words.length == 2) {
      lastWord = words.removeLast();
      secondLastWord = words.removeLast();
      remainingText = words.join(' ');
    } else if (words.length == 1) {
      lastWord = words.removeLast();
    }

    return RichText(
      text: TextSpan(
        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),
        children: words.length > 4 ? [
          TextSpan(
            text: '$remainingText ',
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          TextSpan(
            text: '$thirdLastWord ',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          TextSpan(
            text: '$secondLastWord ',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          TextSpan(
            text: lastWord,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ] : [
          TextSpan(
            text: secondRemainingText,
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }
}

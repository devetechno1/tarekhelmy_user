import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class RegistrationStepperWidget extends StatelessWidget {
  final String status;
  const RegistrationStepperWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    int state = 0;
    if(status == 'business') {
      state = 1;
    }else if(status == 'payment') {
      state = 2;
    }else if(status == 'complete') {
      state = 3;
    }
    return Row(children: [
      RegistrationStepper(
        title: 'general_information'.tr, isActive: true, haveLeftBar: false, haveRightBar: true, rightActive: true, onGoing: state == 0, state: 1,
      ),
      RegistrationStepper(
        title: 'business_plan'.tr, isActive: state > 1, haveLeftBar: true, haveRightBar: true, rightActive: state > 1, onGoing: state == 1, processing: state != 3 && state != 0, state: 2,
      ),
      RegistrationStepper(
        title: 'complete'.tr, isActive: state == 3, haveLeftBar: true, haveRightBar: false, rightActive: state == 3, state: 3,
      ),
    ]);
  }
}

class RegistrationStepper extends StatelessWidget {
  final bool isActive;
  final bool haveLeftBar;
  final bool haveRightBar;
  final String title;
  final bool rightActive;
  final bool onGoing;
  final bool processing;
  final int state;
  const RegistrationStepper({super.key, required this.isActive, required this.haveLeftBar, required this.haveRightBar,
    required this.title, required this.rightActive, this.onGoing = false, this.processing = false, required this.state});

  @override
  Widget build(BuildContext context) {
    Color color = onGoing ? Theme.of(context).primaryColor : isActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.7);
    Color right = onGoing ? Theme.of(context).disabledColor.withOpacity(0.7) : rightActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.7);
    return Expanded(
      child: Column(children: [

        Row(children: [
          Expanded(child: haveLeftBar ? Divider(color: color, thickness: 2) : const SizedBox()),

          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon((onGoing || processing || rightActive) ? Icons.check_circle : Icons.circle, color: color, size: 40),

              (onGoing || processing || rightActive) ? const SizedBox() : Positioned(
                left: 0, right: 0, top: 0, bottom: 0,
                child: Center(child: Text( state == 1 ? '' : state == 2 ? '2' : '3', style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),)),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            child: Text(
              title, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(color: (onGoing || processing || rightActive) ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor),
            ),
          ),

          Expanded(child: haveRightBar ? Divider(color: right, thickness: 2) : const SizedBox()),
        ]),
      ]),
    );
  }
}

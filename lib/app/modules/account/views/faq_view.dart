import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/back_button.dart';

class FAQView extends StatefulWidget {
  FAQView({Key? key}) : super(key: key);

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBGColor,
      body: Stack(
        children: [
          Image.asset(
            Assets.shop_bg,
            fit: BoxFit.fill,
            height: Dimens.height(100, context),
            width: Dimens.width(100, context),
            alignment: Alignment.topLeft,
            key: DestinationPageKeys.destinationHeaderImageKey,
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: (60),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ArrowedBackButton(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Frequently Asked Questions",
                        textAlign: TextAlign.left,
                        style: FontUtils.TTFirsNeueTrial.copyWith(
                            fontSize: Dimens.currentSize(context, 18, 20, 22),
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlurredContainer(
                    height: Dimens.height(100, context),
                    child: ListView(
                      children: [
                        expansionTile("Where to Get an eSIM?", "", context),
                        const SizedBox(
                          height: 10,
                        ),
                        expansionTile(
                            "How to Delete an eSIM?",
                            "To delete an eSIM: \n •  Navigate to your device’s settings]\n •  Select “Cellular/Mobile”\n •  Select your eSIM line\n •  Select “Remove Mobile Data Plan” (it may say “Remove eSIM” or “Delete Mobile Plan” depending on your device)connect to the internet! ",
                            context),
                        const SizedBox(
                          height: 10,
                        ),
                        expansionTile("How to Disable an eSIM?", "", context),
                        const SizedBox(
                          height: 10,
                        ),
                        expansionTile("I bought an eSIM, how do I install it?", "", context),
                        const SizedBox(
                          height: 10,
                        ),
                        expansionTile("How do I enable eSIM in my phone?", "", context),
                        const SizedBox(
                          height: 10,
                        ),
                        expansionTile("How can I top-up my current active plan?", "", context),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget expansionTile(title, description, BuildContext context) {
  return ExpansionTileCard(
    trailing: const SizedBox.shrink(),
    baseColor: AppColors.faqBG,
    expandedColor: AppColors.faqBG,
    leading: SvgPicture.asset(
      Assets.expansion_close,
      height: 17,
      width: 17,
    ),
    title: Text(
      title,
      style: FontUtils.TTFirsNeueTrial.copyWith(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: Dimens.currentSize(context, 14, 16, 18)),
    ),
    children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(left: 40, right: 20),
        child: Divider(
          thickness: 1.0,
          height: 2.0,
          color: Colors.black,
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 8.0,
          ),
          child: Text(
            description,
            style: FontUtils.TTFirsNeueTrial.copyWith(
                color: Colors.white, height: 2, fontWeight: FontWeight.w400, fontSize: 15),
          ),
        ),
      ),
    ],
  );
}

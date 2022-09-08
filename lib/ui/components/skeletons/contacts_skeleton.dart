import 'package:flutter/material.dart';
import 'package:introchat/core/utils/constants/colors.dart';
import 'package:introchat/ui/components/underline.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ContactsSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //   color: Colors.transparent,
                    // ),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SkeletonAnimation(
                            shimmerColor: ConstantColors.SHIMMER,
                            gradientColor: ConstantColors.BUTTON_PRIMARY,
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: ConstantColors.UNDERLINE,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 5.0),
                                child: SkeletonAnimation(
                                  shimmerColor: ConstantColors.SHIMMER,
                                  gradientColor: ConstantColors.BUTTON_PRIMARY,
                                  child: Container(
                                    height: 15,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10.0),
                                      color: ConstantColors.UNDERLINE,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: SkeletonAnimation(
                                    shimmerColor: ConstantColors.SHIMMER,
                                    gradientColor:
                                        ConstantColors.BUTTON_PRIMARY,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 13,
                                      decoration: BoxDecoration(
                                          // borderRadius:
                                          // BorderRadius.circular(10.0),
                                          color: ConstantColors.UNDERLINE),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Underline(),
              ],
            );
          }),
    );
  }
}

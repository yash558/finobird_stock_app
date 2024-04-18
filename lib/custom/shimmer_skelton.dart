import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// ignore: must_be_immutable
class Skeleton extends StatelessWidget {
  Skeleton({Key? key, this.height, this.width, required this.borderRadius})
      : super(key: key);

  final double? height, width;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      enabled: true,
      color: Colors.black.withOpacity(0.1),
      colorOpacity: 0.1,
      duration: const Duration(seconds: 3),
      interval: const Duration(seconds: 1),
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFF4AB5E5).withOpacity(0.2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class AnnouncementCardSkelton extends StatelessWidget {
  const AnnouncementCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Skeleton(
            height: 80,
            // width: 80,
            borderRadius: 0,
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(
                borderRadius: 20,
                width: 140,
                height: 17,
              ),
              const SizedBox(
                height: 8,
              ),
              Skeleton(
                borderRadius: 20,
                width: 260,
                height: 17,
              )
            ],
          )
        ],
      ),
    );
  }
}

class CompanyCardSkelton extends StatelessWidget {
  const CompanyCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Skeleton(
            height: 50,
            width: 50,
            borderRadius: 100,
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(
                borderRadius: 10,
                width: 180,
                height: 14,
              )
            ],
          )
        ],
      ),
    );
  }
}

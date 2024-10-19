import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final Widget child;

  SkeletonLoader({required this.child});

  @override
  Widget build(BuildContext context) {
    return _buildSkeleton();
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.white!,
      highlightColor: Colors.grey[300]!,
      child: child,
    );
  }
}

class EmptyUtil extends StatelessWidget {
  const EmptyUtil({super.key});

  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "packages/craft_dynamic/assets/images/empty.png",
            height: 64,
            width: 64,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 14,
          ),
          const Text(
            "Nothing found!",
          )
        ],
      ));
}
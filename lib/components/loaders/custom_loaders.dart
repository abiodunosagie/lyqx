import 'package:flutter/material.dart';
import 'package:lyqx/theme/app_colors.dart';

// Circular Progress Loader
class CircularLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? message;

  const CircularLoader({
    super.key,
    this.size = 40,
    this.strokeWidth = 3,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loaderColor = color ?? AppColors.primaryGold;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
            backgroundColor: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// Linear Progress Loader
class LinearLoader extends StatelessWidget {
  final double? value;
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final String? label;

  const LinearLoader({
    super.key,
    this.value,
    this.height = 4,
    this.color,
    this.backgroundColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressColor = color ?? AppColors.primaryGold;
    final bgColor = backgroundColor ??
        (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (value != null)
                Text(
                  '${(value! * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: value,
            minHeight: height,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            backgroundColor: bgColor,
          ),
        ),
      ],
    );
  }
}

// Shimmer Loading Effect
class ShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Widget? child;

  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius,
    this.child,
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkSurface : AppColors.lightGray;
    final highlightColor = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.8);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 1.0,
                _animation.value,
                _animation.value + 1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

// Skeleton Loader for Lists
class SkeletonListLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;

  const SkeletonListLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              ShimmerLoader(
                width: itemHeight,
                height: itemHeight,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(
                      height: 20,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    ShimmerLoader(
                      height: 16,
                      width: 150,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Pulsing Dot Loader
class PulsingDotLoader extends StatefulWidget {
  final int dotCount;
  final double dotSize;
  final Color? color;

  const PulsingDotLoader({
    super.key,
    this.dotCount = 3,
    this.dotSize = 12,
    this.color,
  });

  @override
  State<PulsingDotLoader> createState() => _PulsingDotLoaderState();
}

class _PulsingDotLoaderState extends State<PulsingDotLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.color ?? AppColors.primaryGold;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.dotCount, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.dotSize * 0.3),
          child: AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  color: dotColor.withOpacity(0.3 + (_animations[index].value * 0.7)),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

// Full Screen Loader Overlay
class LoaderOverlay extends StatelessWidget {
  final String? message;
  final Widget? customLoader;
  final bool blur;

  const LoaderOverlay({
    super.key,
    this.message,
    this.customLoader,
    this.blur = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: (isDark ? Colors.black : Colors.white).withOpacity(blur ? 0.8 : 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customLoader ?? const CircularLoader(size: 50),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
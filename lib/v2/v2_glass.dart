import 'dart:ui';

import 'package:flutter/material.dart';

class V2GlassTheme {
  const V2GlassTheme._();

  static ThemeData light({
    required Color seed,
    Color background = const Color(0xFFF7F7FA),
    Color ink = const Color(0xFF24242B),
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: Colors.white,
    ).copyWith(onSurface: ink);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
    );
  }
}

class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(26)),
    this.blurSigma = 18,
    this.tint,
    this.surfaceOpacity,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color? tint;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// Optional local density override for content-heavy glass surfaces.
  ///
  /// The default keeps the lighter control treatment. Higher values are useful
  /// for reading surfaces without changing every glass control in the app.
  final double? surfaceOpacity;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final highContrast = media?.highContrast ?? false;
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final base = tint ?? (dark ? const Color(0xFF24252B) : Colors.white);
    final accent =
        Color.lerp(base, theme.colorScheme.primary, dark ? .16 : .10)!;
    final requestedOpacity = surfaceOpacity?.clamp(.0, 1.0);
    final middleAlpha =
        highContrast ? .96 : requestedOpacity ?? (dark ? .50 : .36);
    final topAlpha = highContrast
        ? .98
        : requestedOpacity == null
            ? (dark ? .60 : .48)
            : (middleAlpha + .10).clamp(.0, 1.0);
    final bottomAlpha = highContrast
        ? .94
        : requestedOpacity == null
            ? (dark ? .42 : .28)
            : (middleAlpha - .08).clamp(.0, 1.0);

    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: content,
        ),
      );
    }

    final body = Stack(
      fit: StackFit.passthrough,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, .48, 1],
              colors: [
                base.withValues(alpha: topAlpha),
                accent.withValues(alpha: middleAlpha),
                base.withValues(alpha: bottomAlpha),
              ],
            ),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: highContrast ? .34 : .28)
                  : Colors.white.withValues(alpha: highContrast ? .96 : .80),
              width: 1,
            ),
          ),
          child: content,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  stops: const [0, .24, .62],
                  colors: [
                    Colors.white.withValues(alpha: dark ? .16 : .36),
                    Colors.white.withValues(alpha: dark ? .05 : .11),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final clipped = ClipRRect(
      borderRadius: borderRadius,
      child: highContrast || blurSigma <= 0
          ? body
          : BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigma + 4,
                sigmaY: blurSigma + 4,
              ),
              child: body,
            ),
    );

    final glass = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? .28 : .13),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: dark ? .04 : .20),
            blurRadius: 10,
            spreadRadius: -5,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: clipped,
    );

    if (semanticLabel == null) return glass;
    return Semantics(label: semanticLabel, button: onTap != null, child: glass);
  }
}

class AppGlassSearchField extends StatelessWidget {
  const AppGlassSearchField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.fieldKey,
    required this.buttonKey,
    this.darkContext = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final Key fieldKey;
  final Key buttonKey;
  final bool darkContext;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tint = darkContext ? Colors.white : null;
    return AppGlassSurface(
      tint: tint,
      borderRadius: BorderRadius.circular(21),
      blurSigma: 16,
      padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 21,
            color:
                darkContext ? const Color(0xFF625D70) : colors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: fieldKey,
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                hintText: '제목, 저자, 출판사를 검색해요',
                hintStyle: TextStyle(
                  color: Color(0xFF96909F),
                  fontWeight: FontWeight.w500,
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Semantics(
            button: true,
            label: '책 검색 실행',
            child: Material(
              color: colors.primary,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                key: buttonKey,
                onTap: () => onSubmitted(controller.text),
                borderRadius: BorderRadius.circular(15),
                child: const SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(Icons.arrow_upward_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppGlassSegmentedControl<T> extends StatelessWidget {
  const AppGlassSegmentedControl({
    super.key,
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final colors = Theme.of(context).colorScheme;
    return AppGlassSurface(
      borderRadius: BorderRadius.circular(22),
      blurSigma: 14,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: values.map((value) {
          final active = value == selected;
          return Expanded(
            child: Semantics(
              selected: active,
              button: true,
              label: labelBuilder(value),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: () => onSelected(value),
                  child: AnimatedContainer(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 210),
                    curve: Curves.easeOutCubic,
                    constraints: const BoxConstraints(minHeight: 42),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                    decoration: BoxDecoration(
                      color: active
                          ? colors.primary.withValues(alpha: .12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(
                      labelBuilder(value),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            active ? colors.primary : colors.onSurfaceVariant,
                        fontSize: 12.5,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AppGlassPrimaryButton extends StatelessWidget {
  const AppGlassPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tint,
    this.foregroundColor,
    this.minHeight = 52,
    this.borderRadius = 17,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? tint;
  final Color? foregroundColor;
  final double minHeight;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final foreground = foregroundColor ?? scheme.onPrimary;
    return Opacity(
      opacity: enabled ? 1 : .46,
      child: SizedBox(
        width: double.infinity,
        height: minHeight,
        child: AppGlassSurface(
          onTap: onPressed,
          semanticLabel: label,
          tint: tint ?? scheme.primary,
          surfaceOpacity: .72,
          blurSigma: 18,
          borderRadius: BorderRadius.circular(borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 19, color: foreground),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppGlassToolbar extends StatelessWidget {
  const AppGlassToolbar({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: AppGlassSurface(
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Semantics(
                button: true,
                label: '뒤로 가기',
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(width: 48, child: trailing),
            ],
          ),
        ),
      ),
    );
  }
}

class AppGlassBottomBar extends StatelessWidget {
  const AppGlassBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: AppGlassSurface(
        borderRadius: BorderRadius.circular(26),
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

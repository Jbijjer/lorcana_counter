import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  runApp(const LorcanaCounterApp());
}

class LorcanaCounterApp extends StatelessWidget {
  const LorcanaCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lorcana Counter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.copyWith(
              displayLarge: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
            ),
      ),
      home: const PlayScreen(),
    );
  }
}

class PlayerColorOption {
  const PlayerColorOption(this.label, this.color);

  final String label;
  final Color color;
}

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  static const List<PlayerColorOption> _colorOptions = [
    PlayerColorOption('Saphir', Color(0xFF3CB9FF)),
    PlayerColorOption('Ambre', Color(0xFFFFA04C)),
    PlayerColorOption('Émeraude', Color(0xFF5CD68C)),
    PlayerColorOption('Rubis', Color(0xFFFF5757)),
    PlayerColorOption('Améthyste', Color(0xFF8F7BFF)),
    PlayerColorOption('Acier', Color(0xFF90A4AE)),
  ];

  int _topScore = 0;
  int _bottomScore = 0;

  late final TextEditingController _topNameController;
  late final TextEditingController _bottomNameController;

  int _topColorIndex = 0;
  int _bottomColorIndex = 3;

  @override
  void initState() {
    super.initState();
    _topNameController = TextEditingController(text: 'Joueur 1')
      ..addListener(() => setState(() {}));
    _bottomNameController = TextEditingController(text: 'Joueur 2')
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _topNameController.dispose();
    _bottomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PlayerScorePanel(
                isTop: true,
                score: _topScore,
                controller: _topNameController,
                colorOptionIndex: _topColorIndex,
                onIncrement: () => setState(() {
                  _topScore = (_topScore + 1).clamp(0, 999);
                }),
                onDecrement: () => setState(() {
                  _topScore = (_topScore - 1).clamp(0, 999);
                }),
                onColorChanged: (index) => setState(() {
                  _topColorIndex = index;
                }),
                colorOptions: _colorOptions,
              ),
            ),
            const MiddleDivider(),
            Expanded(
              child: PlayerScorePanel(
                isTop: false,
                score: _bottomScore,
                controller: _bottomNameController,
                colorOptionIndex: _bottomColorIndex,
                onIncrement: () => setState(() {
                  _bottomScore = (_bottomScore + 1).clamp(0, 999);
                }),
                onDecrement: () => setState(() {
                  _bottomScore = (_bottomScore - 1).clamp(0, 999);
                }),
                onColorChanged: (index) => setState(() {
                  _bottomColorIndex = index;
                }),
                colorOptions: _colorOptions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerScorePanel extends StatelessWidget {
  const PlayerScorePanel({
    required this.isTop,
    required this.score,
    required this.controller,
    required this.colorOptionIndex,
    required this.onIncrement,
    required this.onDecrement,
    required this.onColorChanged,
    required this.colorOptions,
    super.key,
  });

  final bool isTop;
  final int score;
  final TextEditingController controller;
  final int colorOptionIndex;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onColorChanged;
  final List<PlayerColorOption> colorOptions;

  @override
  Widget build(BuildContext context) {
    final PlayerColorOption option = colorOptions[colorOptionIndex];
    final PlayerPalette palette = PlayerPalette.from(option.color);
    final BorderRadius borderRadius = isTop
        ? const BorderRadius.only(
            bottomLeft: Radius.circular(44),
            bottomRight: Radius.circular(44),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(44),
            topRight: Radius.circular(44),
          );

    final TextAlign nameAlign = isTop ? TextAlign.left : TextAlign.right;
    final Alignment nameAlignment =
        isTop ? Alignment.topLeft : Alignment.topRight;
    final WrapAlignment chipsAlignment =
        isTop ? WrapAlignment.start : WrapAlignment.end;

    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
            end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
            colors: palette.background,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(isTop ? -0.6 : 0.6, isTop ? -0.5 : 0.5),
                    radius: 1.1,
                    colors: [
                      palette.lightGlow.withOpacity(0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: isTop
                        ? BorderSide(color: palette.accent.withOpacity(0.35))
                        : BorderSide.none,
                    bottom: isTop
                        ? BorderSide.none
                        : BorderSide(color: palette.accent.withOpacity(0.35)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
              child: Column(
                children: [
                  Align(
                    alignment: nameAlignment,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: TextField(
                        controller: controller,
                        textAlign: nameAlign,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: palette.onBackground,
                              fontWeight: FontWeight.w700,
                            ),
                        decoration: InputDecoration(
                          prefixIcon:
                              isTop ? const Icon(Icons.person_outline) : null,
                          suffixIcon:
                              isTop ? null : const Icon(Icons.person_outline),
                          prefixIconColor: palette.onBackground.withOpacity(0.8),
                          suffixIconColor: palette.onBackground.withOpacity(0.8),
                          filled: true,
                          fillColor: palette.fieldFill,
                          labelText: 'Nom du joueur',
                          labelStyle:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: palette.onBackground.withOpacity(0.75),
                                  ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ScoreControlColumn(
                            onIncrement: onIncrement,
                            onDecrement: onDecrement,
                            palette: palette,
                          ),
                          const SizedBox(width: 32),
                          ScoreCrystal(
                            score: score,
                            palette: palette,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment:
                        isTop ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: chipsAlignment,
                        children: [
                          for (int i = 0; i < colorOptions.length; i++)
                            ColorChoiceChip(
                              option: colorOptions[i],
                              selected: i == colorOptionIndex,
                              palette: palette,
                              onSelected: () => onColorChanged(i),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreControlColumn extends StatelessWidget {
  const ScoreControlColumn({
    required this.onIncrement,
    required this.onDecrement,
    required this.palette,
    super.key,
  });

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final PlayerPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScoreControlButton(
          icon: Icons.add,
          background: palette.controlPrimary,
          foreground: palette.onControl,
          shadowColor: palette.accent,
          onPressed: onIncrement,
        ),
        const SizedBox(height: 18),
        ScoreControlButton(
          icon: Icons.remove,
          background: palette.controlSecondary,
          foreground: palette.onControl,
          shadowColor: palette.controlSecondary,
          onPressed: onDecrement,
        ),
      ],
    );
  }
}

class ScoreControlButton extends StatelessWidget {
  const ScoreControlButton({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.shadowColor,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final Color shadowColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: shadowColor.withOpacity(0.45),
          backgroundColor: background,
          foregroundColor: foreground,
          shape: const CircleBorder(),
          textStyle: Theme.of(context).textTheme.headlineLarge,
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 32),
      ),
    );
  }
}

class ScoreCrystal extends StatelessWidget {
  const ScoreCrystal({
    required this.score,
    required this.palette,
    super.key,
  });

  final int score;
  final PlayerPalette palette;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInBack,
      child: Transform.rotate(
        key: ValueKey<int>(score),
        angle: math.pi / 4,
        child: Container(
          width: 168,
          height: 168,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                palette.crystalHighlight,
                palette.crystalShadow,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: palette.accent.withOpacity(0.8), width: 3),
            boxShadow: [
              BoxShadow(
                color: palette.accent.withOpacity(0.35),
                blurRadius: 22,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Text(
              '$score',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: palette.onCrystal,
                    fontSize: 72,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorChoiceChip extends StatelessWidget {
  const ColorChoiceChip({
    required this.option,
    required this.selected,
    required this.palette,
    required this.onSelected,
    super.key,
  });

  final PlayerColorOption option;
  final bool selected;
  final PlayerPalette palette;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final Color base = option.color;
    return ChoiceChip(
      label: Text(option.label),
      selected: selected,
      onSelected: (_) => onSelected(),
      avatar: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: base,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        ),
      ),
      backgroundColor: palette.fieldFill,
      selectedColor: base.withOpacity(0.95),
      labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: selected
                ? ThemeData.estimateBrightnessForColor(base) ==
                        Brightness.dark
                    ? Colors.white
                    : Colors.black
                : palette.onBackground,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
      side: BorderSide(
        color: selected
            ? base.withOpacity(0.95)
            : palette.onBackground.withOpacity(0.25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }
}

class MiddleDivider extends StatelessWidget {
  const MiddleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color base = theme.colorScheme.outlineVariant;
    return SizedBox(
      height: 132,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 2.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    base.withOpacity(0.0),
                    base.withOpacity(0.45),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                  theme.colorScheme.primary.withOpacity(0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.36),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.65),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.auto_awesome,
              size: 38,
              color: theme.colorScheme.onPrimary,
              semanticLabel: 'Symbole Lorcana',
            ),
          ),
          Expanded(
            child: Container(
              width: 2.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    base.withOpacity(0.45),
                    base.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerPalette {
  PlayerPalette._({
    required this.background,
    required this.onBackground,
    required this.fieldFill,
    required this.controlPrimary,
    required this.controlSecondary,
    required this.onControl,
    required this.accent,
    required this.lightGlow,
    required this.crystalHighlight,
    required this.crystalShadow,
    required this.onCrystal,
  });

  final List<Color> background;
  final Color onBackground;
  final Color fieldFill;
  final Color controlPrimary;
  final Color controlSecondary;
  final Color onControl;
  final Color accent;
  final Color lightGlow;
  final Color crystalHighlight;
  final Color crystalShadow;
  final Color onCrystal;

  static PlayerPalette from(Color base) {
    final hsl = HSLColor.fromColor(base);
    final Color start = hsl
        .withLightness((hsl.lightness + 0.18).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation * 0.85).clamp(0.0, 1.0))
        .toColor();
    final Color end = hsl
        .withLightness((hsl.lightness - 0.22).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation * 1.05).clamp(0.0, 1.0))
        .toColor();
    final Color accent = hsl
        .withLightness((hsl.lightness + 0.04).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation * 1.2).clamp(0.0, 1.0))
        .toColor();
    final Brightness brightness = ThemeData.estimateBrightnessForColor(end);
    final Color onBackground =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    final Color controlPrimary = accent.withOpacity(0.9);
    final Color controlSecondary =
        onBackground == Colors.white ? Colors.white24 : Colors.black12;
    final Color onControl =
        ThemeData.estimateBrightnessForColor(controlPrimary) ==
                Brightness.dark
            ? Colors.white
            : Colors.black;
    final Color crystalHighlight =
        hsl.withLightness((hsl.lightness + 0.28).clamp(0.0, 1.0)).toColor();
    final Color crystalShadow =
        hsl.withLightness((hsl.lightness - 0.25).clamp(0.0, 1.0)).toColor();
    final Color onCrystal =
        ThemeData.estimateBrightnessForColor(crystalShadow) ==
                Brightness.dark
            ? Colors.white
            : Colors.black;
    return PlayerPalette._(
      background: [start, end],
      onBackground: onBackground,
      fieldFill: onBackground.withOpacity(0.08),
      controlPrimary: controlPrimary,
      controlSecondary: controlSecondary,
      onControl: onControl,
      accent: accent,
      lightGlow: start,
      crystalHighlight: crystalHighlight,
      crystalShadow: crystalShadow,
      onCrystal: onCrystal,
    );
  }
}

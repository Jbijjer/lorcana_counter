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
    PlayerColorOption('Saphir', Color(0xFF4FC3F7)),
    PlayerColorOption('Ambre', Color(0xFFFFB74D)),
    PlayerColorOption('Émeraude', Color(0xFF81C784)),
    PlayerColorOption('Rubis', Color(0xFFEF5350)),
    PlayerColorOption('Améthyste', Color(0xFF9575CD)),
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
                onDecrement: () => setState(() {
                  _topScore = (_topScore - 1).clamp(0, 999);
                }),
                onIncrement: () => setState(() {
                  _topScore = (_topScore + 1).clamp(0, 999);
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
                onDecrement: () => setState(() {
                  _bottomScore = (_bottomScore - 1).clamp(0, 999);
                }),
                onIncrement: () => setState(() {
                  _bottomScore = (_bottomScore + 1).clamp(0, 999);
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
    final theme = Theme.of(context);
    final PlayerColorOption option = colorOptions[colorOptionIndex];
    final HSLColor hsl = HSLColor.fromColor(option.color);
    final Color gradientStart =
        hsl.withLightness((hsl.lightness * 0.75).clamp(0.2, 0.85)).toColor();
    final Color gradientEnd =
        hsl.withLightness((hsl.lightness * 0.55).clamp(0.08, 0.7)).toColor();

    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(gradientEnd);
    final Color foreground =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    final Color overlayStrong = foreground.withOpacity(0.38);
    final Color overlayFaint = foreground.withOpacity(0.18);

    final BorderRadius borderRadius = isTop
        ? const BorderRadius.only(
            bottomLeft: Radius.circular(48),
            bottomRight: Radius.circular(48),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(48),
          );

    final TextAlign nameAlign = isTop ? TextAlign.left : TextAlign.right;
    final Alignment nameAlignment =
        isTop ? Alignment.topLeft : Alignment.topRight;
    final Alignment dropdownAlignment =
        isTop ? Alignment.bottomLeft : Alignment.bottomRight;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
          end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
          colors: [gradientStart, gradientEnd],
        ),
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          children: [
            Align(
              alignment: nameAlignment,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: TextField(
                  controller: controller,
                  textAlign: nameAlign,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: foreground.withOpacity(0.12),
                    labelText: 'Nom du joueur',
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: foreground.withOpacity(0.8),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                    prefixIconColor: foreground.withOpacity(0.75),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
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
                      foreground: foreground,
                      accent: overlayStrong,
                      muted: overlayFaint,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    const SizedBox(width: 28),
                    ScoreHexagon(
                      score: score,
                      foreground: foreground,
                      fillColor: overlayFaint,
                      borderColor: overlayStrong,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: dropdownAlignment,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: DropdownButtonFormField<int>(
                  value: colorOptionIndex,
                  dropdownColor: gradientEnd,
                  decoration: InputDecoration(
                    labelText: 'Couleur',
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: foreground.withOpacity(0.8),
                    ),
                    filled: true,
                    fillColor: foreground.withOpacity(0.12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  iconEnabledColor: foreground,
                  style: theme.textTheme.bodyLarge?.copyWith(color: foreground),
                  items: [
                    for (var i = 0; i < colorOptions.length; i++)
                      DropdownMenuItem<int>(
                        value: i,
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: colorOptions[i].color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            Text(
                              colorOptions[i].label,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onColorChanged(value);
                    }
                  },
                ),
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
    required this.foreground,
    required this.accent,
    required this.muted,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  final Color foreground;
  final Color accent;
  final Color muted;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScoreControlButton(
          icon: Icons.add,
          foreground: foreground,
          background: accent,
          onPressed: onIncrement,
        ),
        const SizedBox(height: 16),
        ScoreControlButton(
          icon: Icons.remove,
          foreground: foreground,
          background: muted,
          onPressed: onDecrement,
        ),
      ],
    );
  }
}

class ScoreControlButton extends StatelessWidget {
  const ScoreControlButton({
    required this.icon,
    required this.foreground,
    required this.background,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final Color foreground;
  final Color background;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        textStyle: Theme.of(context).textTheme.headlineLarge,
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 28),
    );
  }
}

class ScoreHexagon extends StatelessWidget {
  const ScoreHexagon({
    required this.score,
    required this.foreground,
    required this.fillColor,
    required this.borderColor,
    super.key,
  });

  final int score;
  final Color foreground;
  final Color fillColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        );
      },
      child: ClipPath(
        key: ValueKey<int>(score),
        clipper: _HexagonClipper(),
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '$score',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      ),
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;
    final double verticalOffset = height / 4;

    return Path()
      ..moveTo(width / 2, 0)
      ..lineTo(width, verticalOffset)
      ..lineTo(width, height - verticalOffset)
      ..lineTo(width / 2, height)
      ..lineTo(0, height - verticalOffset)
      ..lineTo(0, verticalOffset)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class MiddleDivider extends StatelessWidget {
  const MiddleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color dividerColor = theme.colorScheme.outlineVariant;
    return SizedBox(
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(width: 2, color: dividerColor.withOpacity(0.6)),
          ),
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.surfaceVariant,
                  theme.colorScheme.surfaceVariant.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: dividerColor.withOpacity(0.65),
                width: 1.6,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.auto_awesome,
              size: 36,
              color: theme.colorScheme.primary,
              semanticLabel: 'Symbole Lorcana',
            ),
          ),
          Expanded(
            child: Container(width: 2, color: dividerColor.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}

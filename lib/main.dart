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
    final Color background = Color.alphaBlend(
      option.color.withOpacity(0.18),
      theme.colorScheme.surface,
    );

    final BorderRadius borderRadius = isTop
        ? const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          );

    final Alignment alignment =
        isTop ? Alignment.centerLeft : Alignment.centerRight;

    final TextAlign textAlign = isTop ? TextAlign.left : TextAlign.right;
    final brightness = ThemeData.estimateBrightnessForColor(option.color);
    final Color buttonForeground =
        brightness == Brightness.dark ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment:
            isTop ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: TextField(
              controller: controller,
              textAlign: textAlign,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(0.65),
                labelText: 'Nom du joueur',
                labelStyle: theme.textTheme.labelLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: alignment,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: theme.colorScheme.surface.withOpacity(0.7),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                    child: child,
                  ),
                  child: Text(
                    '$score',
                    key: ValueKey<int>(score),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                iconSize: 36,
                style: IconButton.styleFrom(
                  backgroundColor: option.color.withOpacity(0.45),
                  foregroundColor: buttonForeground,
                ),
                onPressed: onDecrement,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 24),
              IconButton.filled(
                iconSize: 36,
                style: IconButton.styleFrom(
                  backgroundColor: option.color,
                  foregroundColor: buttonForeground,
                ),
                onPressed: onIncrement,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: alignment,
            child: DropdownButtonFormField<int>(
              value: colorOptionIndex,
              decoration: InputDecoration(
                labelText: 'Couleur',
                labelStyle: theme.textTheme.labelLarge,
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(0.65),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
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
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Text(colorOptions[i].label,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                            )),
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
        ],
      ),
    );
  }
}

class MiddleDivider extends StatelessWidget {
  const MiddleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceVariant,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 42,
              color: theme.colorScheme.primary,
              semanticLabel: 'Symbole Lorcana',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Partie en cours',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

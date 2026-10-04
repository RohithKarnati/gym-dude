import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/database.dart';

/// Visual styles for the shareable PR card (F4). Each lays the same facts out
/// differently and adapts when a background photo is added.
enum PrCardTemplate {
  emerald('Emerald'),
  midnight('Midnight'),
  minimal('Minimal');

  const PrCardTemplate(this.label);
  final String label;
}

/// Editor + preview for a shareable PR card: choose a template, optionally set
/// a background photo (your own picture shows through behind the stats), then
/// share the rendered image.
class PrCardScreen extends StatefulWidget {
  const PrCardScreen({super.key, required this.pr});

  final PersonalRecord pr;

  @override
  State<PrCardScreen> createState() => _PrCardScreenState();
}

class _PrCardScreenState extends State<PrCardScreen> {
  final _controller = ScreenshotController();
  PrCardTemplate _template = PrCardTemplate.emerald;
  File? _photo;
  bool _busy = false;

  PersonalRecord get pr => widget.pr;

  Future<void> _pickPhoto() async {
    setState(() => _busy = true);
    try {
      final picked = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 90);
      if (picked == null) return;
      final file = File(picked.path);
      // Make sure it's decoded before it lands in the capture.
      if (mounted) {
        await precacheImage(FileImage(file), context);
        setState(() => _photo = file);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final bytes = await _controller.capture(
        pixelRatio: 3,
        delay: const Duration(milliseconds: 120),
      );
      if (bytes == null) throw 'render failed';
      final dir = await getTemporaryDirectory();
      final safeName =
          pr.exerciseName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final file = File(p.join(dir.path, 'pr_${safeName}_${_template.name}.png'));
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text:
              'New PR: ${pr.exerciseName} — ${_fmt(pr.weightKg)}kg × ${pr.reps} 💪 #GymDude',
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not share: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Share PR')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Screenshot(
                  controller: _controller,
                  child: PrShareCard(
                    pr: pr,
                    template: _template,
                    photo: _photo,
                  ),
                ),
              ),
            ),
          ),
          Material(
            elevation: 8,
            color: scheme.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Template',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final t in PrCardTemplate.values)
                          ChoiceChip(
                            label: Text(t.label),
                            selected: _template == t,
                            onSelected: (_) => setState(() => _template = t),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _busy ? null : _pickPhoto,
                            icon: Icon(_photo == null
                                ? Icons.add_photo_alternate_outlined
                                : Icons.swap_horiz),
                            label: Text(_photo == null
                                ? 'Add photo'
                                : 'Change photo'),
                          ),
                        ),
                        if (_photo != null) ...[
                          const SizedBox(width: 8),
                          IconButton.outlined(
                            tooltip: 'Remove photo',
                            onPressed: _busy
                                ? null
                                : () => setState(() => _photo = null),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _busy ? null : _share,
                        icon: _busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.ios_share),
                        label: Text(_busy ? 'Working…' : 'Share'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The rendered-to-image card. Self-contained styling so it looks identical
/// regardless of app theme. Adapts per [template] and shows [photo] behind the
/// stats when provided.
class PrShareCard extends StatelessWidget {
  const PrShareCard({
    super.key,
    required this.pr,
    required this.template,
    this.photo,
  });

  final PersonalRecord pr;
  final PrCardTemplate template;
  final File? photo;

  static const double _w = 360;
  static const double _h = 480;

  @override
  Widget build(BuildContext context) {
    final style = _CardStyle.of(template, hasPhoto: photo != null);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: _w,
        height: _h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background: photo or the template's gradient.
            if (photo != null)
              Image.file(photo!, fit: BoxFit.cover)
            else
              DecoratedBox(
                decoration: BoxDecoration(gradient: style.gradient),
              ),
            // Scrim for legibility (heavier over photos).
            DecoratedBox(
              decoration: BoxDecoration(gradient: style.scrim),
            ),
            // Content: main block positioned per template, footer pinned bottom.
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: style.blockAlign,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: style.horizontal,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🏆',
                                  style: TextStyle(fontSize: style.trophySize)),
                              const SizedBox(width: 10),
                              Text(
                                'NEW PR',
                                style: TextStyle(
                                  color: style.accent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: style.gap),
                          Text(
                            pr.exerciseName,
                            textAlign: style.textAlign,
                            style: TextStyle(
                              color: style.text,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                _fmt(pr.weightKg),
                                style: TextStyle(
                                  color: style.text,
                                  fontSize: 66,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text('kg',
                                    style: TextStyle(
                                        color: style.textFaint, fontSize: 24)),
                              ),
                              const SizedBox(width: 14),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text('× ${pr.reps}',
                                    style: TextStyle(
                                        color: style.accent,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('d MMM yyyy').format(pr.achievedAt),
                        style: TextStyle(color: style.textFaint, fontSize: 14),
                      ),
                      Text(
                        'GYM DUDE',
                        style: TextStyle(
                          color: style.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
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

/// Resolved visual tokens for a template + photo combination.
class _CardStyle {
  const _CardStyle({
    required this.gradient,
    required this.scrim,
    required this.accent,
    required this.text,
    required this.textFaint,
    required this.blockAlign,
    required this.horizontal,
    required this.textAlign,
    required this.gap,
    required this.trophySize,
  });

  final Gradient gradient;
  final Gradient scrim;
  final Color accent;
  final Color text;
  final Color textFaint;
  final Alignment blockAlign;
  final CrossAxisAlignment horizontal;
  final TextAlign textAlign;
  final double gap;
  final double trophySize;

  static const _transparent = Color(0x00000000);

  static _CardStyle of(PrCardTemplate template, {required bool hasPhoto}) {
    switch (template) {
      case PrCardTemplate.emerald:
        return _CardStyle(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E3B33), Color(0xFF3B7A6E)],
          ),
          scrim: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: hasPhoto
                ? const [Color(0x330E3B33), Color(0xE60E3B33)]
                : const [_transparent, _transparent],
          ),
          accent: const Color(0xFF8CE0CE),
          text: Colors.white,
          textFaint: Colors.white70,
          blockAlign: Alignment.topLeft,
          horizontal: CrossAxisAlignment.start,
          textAlign: TextAlign.left,
          gap: 24,
          trophySize: 34,
        );
      case PrCardTemplate.midnight:
        return _CardStyle(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
          ),
          scrim: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: hasPhoto
                ? const [Color(0x99000000), Color(0xF2000000)]
                : const [_transparent, _transparent],
          ),
          accent: const Color(0xFFFFC857),
          text: Colors.white,
          textFaint: Colors.white60,
          blockAlign: Alignment.center,
          horizontal: CrossAxisAlignment.center,
          textAlign: TextAlign.center,
          gap: 22,
          trophySize: 40,
        );
      case PrCardTemplate.minimal:
        return _CardStyle(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F5F3), Color(0xFFEAE8E3)],
          ),
          scrim: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: hasPhoto
                ? const [_transparent, Color(0xD9000000)]
                : const [_transparent, _transparent],
          ),
          accent: hasPhoto ? const Color(0xFF8CE0CE) : const Color(0xFF0E7C66),
          text: hasPhoto ? Colors.white : const Color(0xFF1A1A1A),
          textFaint:
              hasPhoto ? Colors.white70 : const Color(0xFF1A1A1A).withValues(alpha: 0.55),
          blockAlign: Alignment.bottomLeft,
          horizontal: CrossAxisAlignment.start,
          textAlign: TextAlign.left,
          gap: 20,
          trophySize: 30,
        );
    }
  }
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

import 'package:flutter/material.dart';

enum StorageMode { yarn, needle }

enum NeedleKind { straight, crochet }

enum NeedleFilter { all, straight, crochet }

class YarnEntry {
  const YarnEntry({
    required this.name,
    required this.detail,
    required this.color,
    this.isFavorite = false,
  });

  final String name;
  final String detail;
  final Color color;
  final bool isFavorite;

  YarnEntry copyWith({
    String? name,
    String? detail,
    Color? color,
    bool? isFavorite,
  }) {
    return YarnEntry(
      name: name ?? this.name,
      detail: detail ?? this.detail,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class NeedleEntry {
  const NeedleEntry({
    required this.title,
    required this.detail,
    required this.sizeLabel,
    required this.kind,
    this.isFavorite = false,
  });

  final String title;
  final String detail;
  final String sizeLabel;
  final NeedleKind kind;
  final bool isFavorite;

  NeedleEntry copyWith({
    String? title,
    String? detail,
    String? sizeLabel,
    NeedleKind? kind,
    bool? isFavorite,
  }) {
    return NeedleEntry(
      title: title ?? this.title,
      detail: detail ?? this.detail,
      sizeLabel: sizeLabel ?? this.sizeLabel,
      kind: kind ?? this.kind,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

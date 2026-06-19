import 'package:flutter/material.dart';

import 'storage_models.dart';

const initialYarnItems = [
  YarnEntry(
    name: '코튼 베이지',
    detail: '바늘이실 · 면 100% · 4mm · 3볼 보유',
    color: Color(0xFFD5946D),
    isFavorite: true,
  ),
  YarnEntry(
    name: '울 브라운',
    detail: '소예 · 울 80% · 5mm · 사용 중',
    color: Color(0xFF9B7A54),
    isFavorite: true,
  ),
  YarnEntry(
    name: '머스타드',
    detail: '레떼 · 아크릴 · 4mm · 5볼 보유',
    color: Color(0xFFE0B777),
  ),
  YarnEntry(
    name: '아이보리',
    detail: '바늘이실 · 면 100% · 3mm · 소진',
    color: Color(0xFFF1E5D2),
  ),
  YarnEntry(
    name: '테라코타',
    detail: '소예 · 울 50% · 5mm · 2볼 보유',
    color: Color(0xFFC17A60),
  ),
];

const initialNeedleItems = [
  NeedleEntry(
    title: '코바늘 5.0mm',
    detail: '길이 14cm · 가방·소품용',
    sizeLabel: '5.0',
    kind: NeedleKind.crochet,
    isFavorite: true,
  ),
  NeedleEntry(
    title: '대바늘 4.0mm',
    detail: '길이 40cm · 목도리용',
    sizeLabel: '4.0',
    kind: NeedleKind.straight,
  ),
  NeedleEntry(
    title: '코바늘 3.0mm',
    detail: '길이 14cm · 수세미용',
    sizeLabel: '3.0',
    kind: NeedleKind.crochet,
  ),
];

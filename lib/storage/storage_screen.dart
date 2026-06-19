import 'package:flutter/material.dart';

import 'storage_models.dart';
import 'storage_seed_data.dart';
import 'widgets/needle_storage_view.dart';
import 'widgets/storage_mode_chip.dart';
import 'widgets/yarn_storage_view.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  StorageMode _selectedMode = StorageMode.yarn;
  NeedleFilter _needleFilter = NeedleFilter.all;
  late List<YarnEntry> _yarnItems;
  late List<NeedleEntry> _needleItems;

  @override
  void initState() {
    super.initState();
    _yarnItems = List.of(initialYarnItems);
    _needleItems = List.of(initialNeedleItems);
  }

  List<YarnEntry> get _favoriteYarns =>
      _yarnItems.where((item) => item.isFavorite).toList();

  List<YarnEntry> get _otherYarns =>
      _yarnItems.where((item) => !item.isFavorite).toList();

  List<NeedleEntry> get _filteredNeedles {
    switch (_needleFilter) {
      case NeedleFilter.all:
        return _needleItems;
      case NeedleFilter.straight:
        return _needleItems
            .where((item) => item.kind == NeedleKind.straight)
            .toList();
      case NeedleFilter.crochet:
        return _needleItems
            .where((item) => item.kind == NeedleKind.crochet)
            .toList();
    }
  }

  void _selectMode(StorageMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  void _selectNeedleFilter(NeedleFilter filter) {
    setState(() {
      _needleFilter = filter;
    });
  }

  void _toggleYarnFavorite(YarnEntry target) {
    setState(() {
      _yarnItems = _yarnItems
          .map(
            (item) => item == target
                ? item.copyWith(isFavorite: !item.isFavorite)
                : item,
          )
          .toList();
    });
  }

  void _toggleNeedleFavorite(NeedleEntry target) {
    setState(() {
      _needleItems = _needleItems
          .map(
            (item) => item == target
                ? item.copyWith(isFavorite: !item.isFavorite)
                : item,
          )
          .toList();
    });
  }

  StorageMode get _switchTargetMode =>
      _selectedMode == StorageMode.yarn ? StorageMode.needle : StorageMode.yarn;

  String get _switchTargetLabel =>
      _selectedMode == StorageMode.yarn ? '바늘 정리함' : '실 정리함';

  @override
  Widget build(BuildContext context) {
    final isYarnMode = _selectedMode == StorageMode.yarn;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF7EEDF),
                      foregroundColor: const Color(0xFF8A6644),
                      minimumSize: const Size(44, 44),
                    ),
                    icon: const Icon(Icons.chevron_left_rounded, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isYarnMode ? '실 바구니' : '바늘',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A3425),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  StorageModeChip(
                    label: _switchTargetLabel,
                    onTap: () => _selectMode(_switchTargetMode),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: isYarnMode
                    ? YarnStorageView(
                        favoriteYarns: _favoriteYarns,
                        otherYarns: _otherYarns,
                        onFavoriteToggle: _toggleYarnFavorite,
                      )
                    : NeedleStorageView(
                        selectedFilter: _needleFilter,
                        onFilterSelected: _selectNeedleFilter,
                        items: _filteredNeedles,
                        onFavoriteToggle: _toggleNeedleFavorite,
                      ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 24),
                label: Text(
                  isYarnMode ? '실 등록' : '바늘 등록',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF9C6840),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

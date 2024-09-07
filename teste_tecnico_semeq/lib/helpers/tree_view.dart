import 'package:flutter/material.dart';
import 'package:teste_tecnico_semeq/helpers/edit_sheet_bottom.dart';
import 'package:teste_tecnico_semeq/repositories/entities/tree_entity.dart';
import 'package:teste_tecnico_semeq/repositories/tree_repository.dart';

class TreeView extends StatelessWidget {
  final List<TreeEntity> treeData;
  final TreeRepository treeRepository;
  final String accessToken;
  final VoidCallback onRefresh; 

  const TreeView({Key? key, 
    required this.treeData,
    required this.treeRepository,
    required this.accessToken,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: _buildTreeView(context, treeData),
    );
  }

  List<Widget> _buildTreeView(BuildContext context, List<TreeEntity> data) {
    Map<int, List<TreeEntity>> groupedData = {};

    for (var item in data) {
      groupedData.putIfAbsent(item.level, () => []).add(item);
    }

    List<Widget> treeView = [];
    for (var area in groupedData[0]!) {
      treeView.add(
        Column(
          children: [
            _buildExpandableItem(context, area, groupedData, level: 0),
            const SizedBox(height: 20),
          ],
        ),
      );
    }
    return treeView;
  }

  Widget _buildExpandableItem(BuildContext context, TreeEntity item, Map<int, List<TreeEntity>> groupedData, {required int level}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0 * level),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: _getIconForLevel(item.level),
            title: Row(
              children: [
                Text(item.name, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    showEditBottomSheet(
                      context,
                      item.name,
                      item.id,
                      accessToken,
                      treeRepository,
                      onRefresh, 
                    );
                  },
                  child: const Icon(Icons.edit, size: 16, color: Colors.pink),
                ),
              ],
            ),
            childrenPadding: const EdgeInsets.symmetric(vertical: 5),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.centerLeft,
            children: _buildChildItems(context, item.id, groupedData, level + 1),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildItems(BuildContext context, int parentId, Map<int, List<TreeEntity>> groupedData, int level) {
    List<Widget> children = [];

    if (groupedData.containsKey(level)) {
      for (var child in groupedData[level]!.where((item) => item.parent == parentId)) {
        children.add(_buildExpandableItem(context, child, groupedData, level: level));
      }
    }

    return children;
  }

  Icon _getIconForLevel(int level) {
    switch (level) {
      case 0:
        return const Icon(Icons.folder_outlined, color: Colors.black);
      case 1:
        return const Icon(Icons.folder_open_outlined, color: Colors.black);
      case 2:
        return const Icon(Icons.folder_outlined, color: Colors.black);
      case 3:
        return const Icon(Icons.sensors, color: Colors.black);
      default:
        return const Icon(Icons.device_hub, color: Colors.black);
    }
  }
}

import 'package:flutter/material.dart';

import '../domain/playground_property_definition.dart';
import '../domain/property_registry.dart';
import '../services/code_generator.dart';
import '../state/playground_controller.dart';
import '../widgets/configuration_panel.dart';
import '../widgets/generated_code_panel.dart';
import '../widgets/integration_guide_dialog.dart';
import '../widgets/live_preview_panel.dart';
import '../widgets/property_inspector_widget.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen>
    with SingleTickerProviderStateMixin {
  late final PlaygroundController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = PlaygroundController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _showIntegrationGuide() {
    final state = _controller.state;
    final currentCode = CodeGenerator.generateCode(
      config: state.configuration,
      oldContentVarName: 'oldContent',
      newContentVarName: 'newContent',
      oldLabel: state.oldLabel,
      newLabel: state.newLabel,
      minimalMode: true,
      includeImports: false,
    );

    showDialog<void>(
      context: context,
      builder: (_) => IntegrationGuideDialog(currentCode: currentCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final state = _controller.state;
        final isDesktop = MediaQuery.of(context).size.width >= 1024;

        final selectedDef = state.selectedPropertyKey != null
            ? PropertyRegistry.definitions.firstWhere(
                (d) => d.key == state.selectedPropertyKey,
                orElse: () => PropertyRegistry.definitions.first,
              )
            : null;

        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Icon(Icons.palette_outlined, size: 20),
                SizedBox(width: 8),
                Text('Flutter Diff Viewer Customization Studio'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.undo, size: 20),
                tooltip: 'Undo',
                onPressed: state.canUndo ? _controller.undo : null,
              ),
              IconButton(
                icon: const Icon(Icons.redo, size: 20),
                tooltip: 'Redo',
                onPressed: state.canRedo ? _controller.redo : null,
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.integration_instructions, size: 16),
                label: const Text('Use in Project'),
                onPressed: _showIntegrationGuide,
              ),
              const SizedBox(width: 12),
            ],
            bottom: !isDesktop
                ? TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(icon: Icon(Icons.tune), text: 'Controls'),
                      Tab(icon: Icon(Icons.preview), text: 'Live Preview'),
                      Tab(icon: Icon(Icons.code), text: 'Generated Code'),
                    ],
                  )
                : null,
          ),
          body: isDesktop
              ? _buildDesktopLayout(selectedDef)
              : _buildMobileLayout(selectedDef),
        );
      },
    );
  }

  Widget _buildDesktopLayout(PlaygroundPropertyDefinition? selectedDef) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              // Left: Configuration Panel
              SizedBox(
                width: 340,
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: ConfigurationPanel(controller: _controller),
                ),
              ),

              // Center: Live Preview Panel
              Expanded(
                flex: 5,
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: LivePreviewPanel(controller: _controller),
                ),
              ),

              // Right: Generated Code Panel
              Expanded(
                flex: 4,
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: GeneratedCodePanel(controller: _controller),
                ),
              ),
            ],
          ),
        ),

        // Bottom Property Inspector Help Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: PropertyInspectorWidget(definition: selectedDef),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(PlaygroundPropertyDefinition? selectedDef) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ConfigurationPanel(controller: _controller),
              LivePreviewPanel(controller: _controller),
              GeneratedCodePanel(controller: _controller),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PropertyInspectorWidget(definition: selectedDef),
        ),
      ],
    );
  }
}

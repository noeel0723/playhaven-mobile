import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/empty_state.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Komunitas')),
    body: const SafeArea(
      top: false,
      child: EmptyState(
        icon: Icons.people_outline,
        title: 'Bermain lebih seru bersama',
        message: 'Profil pemain, ulasan, dan aktivitas teman akan hadir di sini. Fitur komunitas belum tersedia dalam demo.',
      ),
    ),
  );
}

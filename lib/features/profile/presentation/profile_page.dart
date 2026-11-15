import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/empty_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil')),
    body: const SafeArea(
      top: false,
      child: EmptyState(
        icon: Icons.person_outline,
        title: 'Selamat datang, pemain!',
        message: 'Kamu sedang menjelajahi mode demo. Login dan sinkronisasi akun PlayHaven akan tersedia setelah integrasi akun selesai.',
      ),
    ),
  );
}

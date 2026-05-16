import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/admin/admin_page.dart'; // ← sesuaikan path import AdminPage kamu

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onMenuTap;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onMenuTap,
  });

  static const _menus = [
    {'icon': Icons.home_rounded, 'label': 'Beranda'},
    {'icon': Icons.article_rounded, 'label': 'Berita & Informasi'},
    {'icon': Icons.school_rounded, 'label': 'Profil Sekolah'},
    {'icon': Icons.workspace_premium_rounded, 'label': 'Portofolio & Skill'},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.navy,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header drawer ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Row: Logo + Tombol Admin ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo box
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // ── Tombol Admin ──
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // tutup drawer
                          Navigator.of(context).push( // ← langsung push ke AdminPage
                            MaterialPageRoute(
                              builder: (_) => const AdminPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                color: AppColors.gold,
                                size: 14,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Text(
                    'SMK NEGERI 3',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Text(
                    'BALIGE',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tahun Ajaran 2024/2025',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ──
            Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
            const SizedBox(height: 8),

            // ── Menu items ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _menus.length,
                itemBuilder: (_, i) {
                  final isActive = currentIndex == i;
                  final menu = _menus[i];
                  return _DrawerItem(
                    icon: menu['icon'] as IconData,
                    label: menu['label'] as String,
                    isActive: isActive,
                    onTap: () {
                      Navigator.of(context).pop();
                      onMenuTap(i);
                    },
                  );
                },
              ),
            ),

            // ── Footer ──
            Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '© 2025 SMK Negeri 3 Balige',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.gold.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isActive ? AppColors.gold : Colors.white.withValues(alpha: 0.7),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.gold : Colors.white,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
        trailing: isActive
            ? Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
          ),
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
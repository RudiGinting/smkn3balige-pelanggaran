import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'providers/profil_provider.dart';
import 'features/home/home_screen.dart';
import 'features/berita/berita_screen.dart';
import 'features/profil/profil_screen.dart';
import 'features/portofolio/portofolio_screen.dart';
import 'shared/drawer/app_drawer.dart';
import 'shared/widgets/app_top_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.navy,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfilProvider()),
      ],
      child: const SmkApp(),
    ),
  );
}

class SmkApp extends StatelessWidget {
  const SmkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMK Negeri 3 Balige',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.navy,
        scaffoldBackgroundColor: AppColors.lightBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.navy,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Label tiap menu untuk title AppBar
  static const _titles = [
    'SMK Negeri 3 Balige',
    'Berita & Informasi',
    'Profil Sekolah',
    'Portofolio & Skill',
  ];

  void _navigate(int index) {
    setState(() => _currentIndex = index);
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(onNavigate: _navigate);
      case 1:
        return const BeritaScreen();
      case 2:
        return const ProfilScreen();
      case 3:
        return const PortofolioScreen();
      default:
        return HomeScreen(onNavigate: _navigate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.lightBg,

      // ── AppBar dengan hamburger ──
      appBar: AppTopBar(
        title: _titles[_currentIndex],
        scaffoldKey: _scaffoldKey,
      ),

      // ── Drawer (hamburger menu) ──
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onMenuTap: _navigate,
      ),

      // ── Body ──
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _buildBody(),
        ),
      ),
    );
  }
}

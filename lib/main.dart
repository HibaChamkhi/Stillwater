import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection.dart';
import 'core/ui/styles/colors.dart';
import 'presentation/shell/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const StillwaterApp());
}

class StillwaterApp extends StatelessWidget {
  const StillwaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Stillwater',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.pageBg,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.sage,
              surface: AppColors.pageBg,
            ),
          ),
          home: const MainShell(),
        );
      },
    );
  }
}

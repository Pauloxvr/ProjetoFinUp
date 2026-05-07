import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ══════════════════════════════════════════════════════════════════════════
  // PALETA SKEUOMORPHIC — TONS DE BRANCO A AZUL
  // ══════════════════════════════════════════════════════════════════════════

  // Azuis principais
  static const Color primaryBlue = Color(0xff3b6cb7);
  static const Color deepBlue = Color(0xff2a4a7f);
  static const Color lightBlue = Color(0xff6a9bd1);
  static const Color skyBlue = Color(0xff8ec5fc);
  static const Color paleBlue = Color(0xffc9dff2);
  static const Color iceBlue = Color(0xffe8f1fa);

  // Brancos e neutros frios
  static const Color pureWhite = Color(0xffffffff);
  static const Color softWhite = Color(0xfff8fafc);
  static const Color pearlWhite = Color(0xfff0f4f8);
  static const Color silverMist = Color(0xffe2e8f0);
  static const Color coolGray = Color(0xffcbd5e1);

  // Cores de destaque
  static const Color successGreen = Color(0xff22c55e);
  static const Color warningAmber = Color(0xfffbbf24);
  static const Color dangerRed = Color(0xffef4444);

  // Backgrounds
  static const Color background = Color(0xffeef2f7);
  static const Color cardBackground = Color(0xffffffff);

  // ══════════════════════════════════════════════════════════════════════════
  // GRADIENTES SKEUOMORPHIC
  // ══════════════════════════════════════════════════════════════════════════

  /// Gradiente principal para botões e cards destacados
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [skyBlue, primaryBlue, deepBlue],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradiente de vidro/glass para overlays
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xaaffffff),
      Color(0x55ffffff),
      Color(0x22ffffff),
    ],
  );

  /// Gradiente metálico para elementos premium
  static const LinearGradient metallicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xfff8fafc),
      Color(0xffe2e8f0),
      Color(0xfff8fafc),
      Color(0xffcbd5e1),
    ],
    stops: [0.0, 0.3, 0.6, 1.0],
  );

  /// Gradiente para cards com efeito de luz
  static const LinearGradient cardLightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffffffff),
      Color(0xfff8fafc),
      Color(0xfff0f4f8),
    ],
  );

  /// Gradiente de sucesso (receitas)
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff4ade80), Color(0xff22c55e), Color(0xff16a34a)],
  );

  /// Gradiente de perigo (despesas)
  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xfffca5a5), Color(0xffef4444), Color(0xffdc2626)],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // SOMBRAS SKEUOMORPHIC
  // ══════════════════════════════════════════════════════════════════════════

  /// Sombra externa suave (neumorphism light)
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  /// Sombra elevada para cards flutuantes
  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          offset: const Offset(0, 4),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  /// Sombra interna (inset) para campos de input
  static List<BoxShadow> get insetShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
        const BoxShadow(
          color: Color(0x22000000),
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ];

  /// Sombra de brilho superior (luz)
  static List<BoxShadow> get topGlow => [
        const BoxShadow(
          color: Color(0x44ffffff),
          offset: Offset(0, -2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  /// Sombra azulada para elementos destacados
  static List<BoxShadow> get blueShadow => [
        BoxShadow(
          color: primaryBlue.withOpacity(0.25),
          offset: const Offset(0, 6),
          blurRadius: 16,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: primaryBlue.withOpacity(0.15),
          offset: const Offset(0, 3),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ];

  /// Sombra para botões pressionados
  static List<BoxShadow> get pressedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          offset: const Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ];

  // ══════════════════════════════════════════════════════════════════════════
  // BORDAS E RAIOS
  // ══════════════════════════════════════════════════════════════════════════

  static const double cardRadius = 24;
  static const double inputRadius = 16;
  static const double buttonRadius = 20;
  static const double smallRadius = 12;
  static const double chipRadius = 30;

  /// Borda sutil para efeito de vidro
  static Border get glassBorder => Border.all(
        color: Colors.white.withOpacity(0.5),
        width: 1.5,
      );

  /// Borda metálica
  static Border get metallicBorder => Border.all(
        color: const Color(0xffe2e8f0),
        width: 1,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // DECORAÇÕES REUTILIZÁVEIS
  // ══════════════════════════════════════════════════════════════════════════

  /// Card padrão skeuomorphic
  static BoxDecoration get skeuCard => BoxDecoration(
        gradient: cardLightGradient,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: elevatedShadow,
      );

  /// Card com borda azul
  static BoxDecoration get skeuCardBlue => BoxDecoration(
        gradient: cardLightGradient,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: paleBlue,
          width: 1.5,
        ),
        boxShadow: blueShadow,
      );

  /// Input field skeuomorphic
  static BoxDecoration get skeuInput => BoxDecoration(
        color: const Color(0xfff1f5f9),
        borderRadius: BorderRadius.circular(inputRadius),
        border: Border.all(
          color: const Color(0xffe2e8f0),
          width: 1,
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x0a000000),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(0, -1),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      );

  /// Botão primário skeuomorphic
  static BoxDecoration get skeuButtonPrimary => BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(buttonRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: blueShadow,
      );

  /// Botão secundário skeuomorphic
  static BoxDecoration get skeuButtonSecondary => BoxDecoration(
        gradient: metallicGradient,
        borderRadius: BorderRadius.circular(buttonRadius),
        border: Border.all(
          color: const Color(0xffe2e8f0),
          width: 1,
        ),
        boxShadow: softShadow,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // ESTILOS DE TEXTO
  // ══════════════════════════════════════════════════════════════════════════

  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Color(0xff1e293b),
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Color(0xff1e293b),
    letterSpacing: -0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xff334155),
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xff475569),
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xff64748b),
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xff94a3b8),
    letterSpacing: 0.2,
  );

  static const TextStyle moneyLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -1,
  );

  static const TextStyle moneyMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  // ══════════════════════════════════════════════════════════════════════════
  // TEMA DO APP
  // ══════════════════════════════════════════════════════════════════════════

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: background,
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xff334155)),
          titleTextStyle: TextStyle(
            color: Color(0xff1e293b),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryBlue,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: pureWhite,
          elevation: 20,
          selectedItemColor: primaryBlue,
          unselectedItemColor: coolGray,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: pearlWhite,
          selectedColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(chipRadius),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xfff1f5f9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputRadius),
            borderSide: const BorderSide(color: Color(0xffe2e8f0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputRadius),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
      );
}

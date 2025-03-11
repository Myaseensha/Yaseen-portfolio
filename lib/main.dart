import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yaseen Sha – Building Next-Gen Flutter Applications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Color(0xFF121212),
          onSurface: Colors.white,
          secondary: Color(0xFF64FFDA),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: GoogleFonts.roboto(
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.roboto(
            color: Colors.grey[300],
          ),
          bodySmall: GoogleFonts.roboto(
            color: Colors.grey[400],
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  final List<GlobalKey> _sectionKeys = [
    GlobalKey(), // Header
    GlobalKey(), // Experience
    GlobalKey(), // Skills
    GlobalKey(), // Work
    GlobalKey(), // Education
    GlobalKey(), // Contact
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _scrollToSection(int index) {
    setState(() {
      _currentIndex = index;
    });

    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4, // Added subtle elevation
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        title: Row(
          children: [
            // Logo/avatar option

            Text(
              'Yaseen Sha',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
            ),
            const Spacer(),
            (MediaQuery.of(context).size.width > 900)
                ? Row(
                    children: [
                      _buildNavItem('Home', 0),
                      _buildNavItem('Experience', 1),
                      _buildNavItem('Skills', 2),
                      _buildNavItem('Projects', 3),
                      _buildNavItem('Education', 4),
                      _buildNavItem('Contact', 5),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
      drawer: MediaQuery.of(context).size.width < 900
          ? _buildSideDrawer(context)
          : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Define breakpoints for responsive design
            final isDesktop = constraints.maxWidth > 1024;
            final isTablet =
                constraints.maxWidth <= 1024 && constraints.maxWidth > 900;
            final isMobile = constraints.maxWidth <= 900;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(
                    context, isDesktop, isTablet, isMobile, _sectionKeys[0]),
                _buildExperienceSection(
                    context, isDesktop, isTablet, isMobile, _sectionKeys[1]),
                _buildSkillsSection(
                    context, isDesktop, isTablet, isMobile, _sectionKeys[2]),
                _buildWorkSection(
                    context, isDesktop, isTablet, isMobile, _sectionKeys[3]),
                _buildEducationSection(
                    context, isDesktop, isTablet, isMobile, _sectionKeys[4]),
                _buildContactSection(
                    context, isDesktop, isTablet, isMobile, _sectionKeys[5]),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      radius: 30,
                      child: const Text(
                        'YS',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Yaseen Sha',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...[
                    'Home',
                    'Experience',
                    'Skills',
                    'Projects',
                    'Education',
                    'Contact'
                  ]
                      .asMap()
                      .entries
                      .map((entry) => ListTile(
                            leading: Icon(
                              _getIconForSection(entry.key),
                              color: _currentIndex == entry.key
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey,
                            ),
                            title: Text(
                              entry.value,
                              style: GoogleFonts.poppins(
                                color: _currentIndex == entry.key
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.white,
                              ),
                            ),
                            onTap: () {
                              _scrollToSection(entry.key);
                              Navigator.pop(context); // Close the drawer
                            },
                          ))
                      .toList(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '© 2025 Yaseen Sha',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _currentIndex == index
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () => _scrollToSection(index),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _currentIndex == index
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
            fontWeight:
                _currentIndex == index ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

// Helper function to get icons for mobile menu
  IconData _getIconForSection(int index) {
    switch (index) {
      case 0:
        return Icons.home_filled;
      case 1:
        return Icons.workspace_premium_rounded;
      case 2:
        return Icons.code_rounded;
      case 3:
        return Icons.folder_special_rounded;
      case 4:
        return Icons.school_rounded;
      case 5:
        return Icons.connect_without_contact_rounded;
      default:
        return Icons.circle;
    }
  }

  Widget _buildHeader(BuildContext context, bool isDesktop, bool isTablet,
      bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      color: Theme.of(context).colorScheme.surface, // Using theme colors
      padding: EdgeInsets.all(isDesktop
          ? 40
          : isTablet
              ? 30
              : 20),
      child: Column(
        children: [
          SizedBox(
              height: isDesktop
                  ? 60
                  : isTablet
                      ? 40
                      : 30),

          _buildHeroSection(context, isDesktop, isTablet, isMobile),

          SizedBox(
              height: isDesktop
                  ? 30
                  : isTablet
                      ? 20
                      : 15),

          // Bio section with enhanced SEO content
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
                vertical: isDesktop
                    ? 20
                    : isTablet
                        ? 16
                        : 12,
                horizontal: isDesktop
                    ? 40
                    : isTablet
                        ? 30
                        : 0),
            child: Column(
              children: [
                // SEO-friendly semantic header
                Semantics(
                  header: true,
                  child: Text(
                    'Software Engineering Professional',
                    style: GoogleFonts.poppins(fontSize: isDesktop ? 35 : 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Bio with typing animation effect
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                      'Dynamic and highly skilled Software Engineer with over 3.8 years of experience in designing and developing robust, scalable, and high-performance applications across multiple domains. Expertise in Flutter-based mobile development, software architecture, and leading cross-functional teams.',
                      textStyle: GoogleFonts.roboto(
                        fontSize: isDesktop
                            ? 24
                            : isTablet
                                ? 14
                                : 12,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.6,
                      ),
                      speed: const Duration(milliseconds: 50),
                    ),
                  ],
                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                ),

                // Skills section for better SEO
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSkillChip('Flutter'),
                    _buildSkillChip('Dart'),
                    _buildSkillChip('Mobile Development'),
                    _buildSkillChip('Software Architecture'),
                    _buildSkillChip('UI/UX'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper method to build skill chips
  Widget _buildSkillChip(String label) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Chip(
            label: Text(label),
            backgroundColor: Theme.of(context).colorScheme.surface,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      },
    );
  }

// Profile image with animation and positioning
  Widget _buildProfileImageSection(
      BuildContext context, bool isDesktop, bool isTablet, bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated background circle
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: isDesktop
                      ? 220
                      : isTablet
                          ? 180
                          : 150,
                  height: isDesktop
                      ? 220
                      : isTablet
                          ? 180
                          : 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Profile image with circular clip
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: isDesktop
                        ? 200
                        : isTablet
                            ? 160
                            : 130,
                    height: isDesktop
                        ? 200
                        : isTablet
                            ? 160
                            : 130,
                    child: Image.asset(
                      'assets/WhatsApp_Image_2025-03-01_at_6.13.45_PM___-removebg-preview.png', // Replace with your image path
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                            color: Theme.of(context).colorScheme.surface,
                            child: Icon(
                              Icons.code_off_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                              size: isDesktop ? 100 : 80,
                            ));
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
      BuildContext context, bool isDesktop, bool isTablet, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImageSection(context, isDesktop, isTablet, isMobile),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Hello, I\'m Yaseen',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Flutter Developer',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'BASED IN KOCHI, KERALA, INDIA',
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: 1, color: Colors.white),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _launchUrl('mailto:yaseeensha.vm@gmail.com'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('CONTACT ME',
                    style: TextStyle(letterSpacing: 1)),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Hello, I\'m Yaseen',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isDesktop ? 12 : 8),
                Text(
                  'Flutter\nDeveloper',
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 56
                        : isTablet
                            ? 42
                            : 32,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: isDesktop ? 16 : 12),
                const Text(
                  'BASED IN KOCHI, KERALA, INDIA',
                  style: TextStyle(letterSpacing: 1, color: Colors.white),
                ),
                SizedBox(height: isDesktop ? 32 : 24),
                ElevatedButton(
                  onPressed: () => _launchUrl('mailto:yaseeensha.vm@gmail.com'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 24,
                      vertical: isDesktop ? 18 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('CONTACT ME',
                      style: TextStyle(letterSpacing: 1)),
                ),
              ],
            ),
          ),
          Center(
              child: _buildProfileImageSection(
                  context, isDesktop, isTablet, isMobile)),
          SizedBox(width: isDesktop ? 50 : 0),
        ],
      );
    }
  }

  Widget _buildExperienceSection(BuildContext context, bool isDesktop,
      bool isTablet, bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      padding: EdgeInsets.all(isDesktop
          ? 40
          : isTablet
              ? 30
              : 20),
      color: const Color(0xFF121212),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience',
            style: GoogleFonts.roboto(
              fontSize: isDesktop
                  ? 42
                  : isTablet
                      ? 36
                      : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isDesktop ? 32 : 24),
          _buildExperienceItem(
              'Mar 2024 - Present',
              'Senior Software Engineer (SDE 2)',
              'Aindriya Marketing Solutions Pvt',
              'Ernakulam, Kerala, India',
              [
                'Leading a team of developers in architected, designing, and deploying large-scale mobile applications.',
                'Optimized app performance, achieving a reduction in load time.',
                'Integrated real-time payment, live streaming (Agora), Firebase authentication, and AI-driven recommendations.'
              ],
              isDesktop,
              isTablet,
              isMobile,
              context),
          SizedBox(height: isDesktop ? 40 : 32),
          _buildExperienceItem(
              'Apr 2023 - Mar 2024',
              'Flutter Developer',
              'MyParkings',
              'Noida, Delhi, India',
              [
                'Developed a scalable parking management application with real-time booking and payment features.',
                'Designed and implemented Flutter-based UI/UX for a seamless user experience.',
                'Achieved over 10K+ downloads with a 4.5-star rating on Play Store.'
              ],
              isDesktop,
              isTablet,
              isMobile,
              context),
          SizedBox(height: isDesktop ? 40 : 32),
          _buildExperienceItem(
              'Mar 2022 - Feb 2023',
              'Freelance Flutter Developer',
              'Consultant',
              'Calicut, Kerala, India',
              [
                'Developed and deployed multiple e-commerce and food delivery applications.',
                'Integrated advanced payment systems, real-time tracking, and push notifications.',
                'Built scalable architectures for apps handling 50K+ monthly users.'
              ],
              isDesktop,
              isTablet,
              isMobile,
              context),
          SizedBox(height: isDesktop ? 40 : 32),
          _buildExperienceItem(
              'Jul 2021 - Feb 2022',
              'Web Development Intern',
              'Puffin Computers',
              'Calicut, Kerala, India',
              [
                'Contributed to web development projects and UI/UX designs using Figma.',
                'Gained foundational experience in the software development lifecycle and team collaboration.'
              ],
              isDesktop,
              isTablet,
              isMobile,
              context),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(
      String years,
      String title,
      String company,
      String location,
      List<String> descriptions,
      bool isDesktop,
      bool isTablet,
      bool isMobile,
      BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: isDesktop ? 32 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            years,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              fontSize: isDesktop ? 14 : 12,
            ),
          ),
          SizedBox(height: isDesktop ? 12 : 8),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: isDesktop
                  ? 24
                  : isTablet
                      ? 20
                      : 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Text(
            '$company - $location',
            style: GoogleFonts.roboto(
              fontSize: isDesktop
                  ? 16
                  : isTablet
                      ? 14
                      : 12,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          ...descriptions
              .map((desc) => Padding(
                    padding: EdgeInsets.only(bottom: isDesktop ? 8 : 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300],
                            )),
                        Expanded(
                          child: Text(
                            desc,
                            style: GoogleFonts.roboto(
                              fontSize: isDesktop
                                  ? 15
                                  : isTablet
                                      ? 14
                                      : 13,
                              height: 1.5,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context, bool isDesktop,
      bool isTablet, bool isMobile, GlobalKey key) {
    final skills = {
      'Languages':
          'Dart (Proficient), Familiar with (Java, JavaScript, Python, C, HTML, CSS)',
      'Frameworks': 'Flutter (Expert)',
      'State Management': 'GetX, Bloc, Provider, Riverpod',
      'Backend Services': 'Firebase, RESTful APIs, gRPC, Supabase',
      'DevOps': 'GitHub Actions, Firebase Hosting',
      'Tools': 'Android Studio, Xcode, Visual Studio Code, Git, Postman, Figma',
      'Other':
          'Payment Gateways, Socket.IO, WebRTC, Microservices Architecture',
    };

    return Container(
      key: key,
      padding: EdgeInsets.all(isDesktop
          ? 40
          : isTablet
              ? 30
              : 20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Skills',
            style: GoogleFonts.roboto(
              fontSize: isDesktop
                  ? 42
                  : isTablet
                      ? 36
                      : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isDesktop ? 32 : 24),
          ...skills.entries
              .map((entry) => Padding(
                    padding: EdgeInsets.only(bottom: isDesktop ? 24 : 16),
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 0),
                                child: Text(
                                  entry.key,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF64FFDA),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.value,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey[300],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: isDesktop ? 180 : 140,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  child: Text(
                                    entry.key,
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF64FFDA),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: GoogleFonts.roboto(
                                    fontSize: isDesktop ? 15 : 14,
                                    height: 1.5,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildWorkSection(BuildContext context, bool isDesktop, bool isTablet,
      bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      padding: EdgeInsets.all(isDesktop
          ? 40
          : isTablet
              ? 30
              : 20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work',
            style: GoogleFonts.roboto(
              fontSize: isDesktop
                  ? 42
                  : isTablet
                      ? 36
                      : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          Text(
            'Here are some of the projects I\'ve worked on. My expertise spans across various domains including e-commerce, parking management, food delivery, and custom business solutions.',
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 16 : 14,
              height: 1.5,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: isDesktop ? 40 : 32),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile
                    ? 1
                    : isTablet
                        ? 2
                        : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop
                    ? 1.0
                    : isTablet
                        ? 1.1
                        : 0.9),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final projects = [
                {
                  'title': 'Parking App',
                  'desc': 'Real-time booking and payment system',
                  'icon': Icons.local_parking
                },
                {
                  'title': 'E-commerce Application',
                  'desc': 'Feature-rich shopping experience',
                  'icon': Icons.shopping_bag
                },
                {
                  'title': 'Food Delivery Platform',
                  'desc': 'Order tracking and real-time updates',
                  'icon': Icons.delivery_dining
                },
              ];
              return _buildWorkCard(
                  projects[index]['title'] as String,
                  projects[index]['desc'] as String,
                  projects[index]['icon'] as IconData,
                  context,
                  isDesktop,
                  isTablet);
            },
          ),
          SizedBox(height: isDesktop ? 40 : 32),
          isMobile
              ? Column(
                  children: [
                    _buildCaseStudy(
                      'MyParkings App',
                      'Scalable parking management solution with 10K+ downloads and 4.5-star rating. Features real-time booking, payment integration, and user-friendly interface.',
                      context,
                      isDesktop,
                      isTablet,
                    ),
                    const SizedBox(height: 16),
                    _buildCaseStudy(
                      'E-commerce Platform',
                      'Built for high traffic with 50K+ monthly users. Integrated payment gateways, push notifications, and streamlined checkout process for enhanced user experience.',
                      context,
                      isDesktop,
                      isTablet,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildCaseStudy(
                        'MyParkings App',
                        'Scalable parking management solution with 10K+ downloads and 4.5-star rating. Features real-time booking, payment integration, and user-friendly interface.',
                        context,
                        isDesktop,
                        isTablet,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCaseStudy(
                        'E-commerce Platform',
                        'Built for high traffic with 50K+ monthly users. Integrated payment gateways, push notifications, and streamlined checkout process for enhanced user experience.',
                        context,
                        isDesktop,
                        isTablet,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildWorkCard(String title, String description, IconData icon,
      BuildContext context, bool isDesktop, bool isTablet) {
    return Card(
      elevation: 3,
      color: const Color(0xFF121212),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isDesktop ? 48 : 40,
              color: const Color(0xFF64FFDA),
            ),
            SizedBox(height: isDesktop ? 16 : 12),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isDesktop ? 12 : 8),
            Text(
              description,
              style: GoogleFonts.roboto(
                fontSize: isDesktop ? 14 : 13,
                height: 1.5,
                color: Colors.grey[300],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseStudy(String title, String description, BuildContext context,
      bool isDesktop, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64FFDA),
            ),
          ),
          SizedBox(height: isDesktop ? 12 : 8),
          Text(
            description,
            style: GoogleFonts.roboto(
              fontSize: isDesktop ? 15 : 14,
              height: 1.5,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(BuildContext context, bool isDesktop,
      bool isTablet, bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      padding: EdgeInsets.all(isDesktop
          ? 40
          : isTablet
              ? 30
              : 20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: GoogleFonts.roboto(
              fontSize: isDesktop
                  ? 42
                  : isTablet
                      ? 36
                      : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isDesktop ? 32 : 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) ...[
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Education',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64FFDA),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMobile) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 0),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Education',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64FFDA),
                          ),
                        ),
                      ),
                    ],
                    Text(
                      'VHSE THRISSUR',
                      style: GoogleFonts.roboto(
                        fontSize: isDesktop
                            ? 24
                            : isTablet
                                ? 20
                                : 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: const Color(0xFF64FFDA),
                      ),
                    ),
                    Text(
                      'Thrissur, Kerala, India',
                      style: GoogleFonts.roboto(
                        fontSize: isDesktop ? 16 : 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: isDesktop ? 8 : 6),
                    Text(
                      'Computer Science FTCP',
                      style: GoogleFonts.roboto(
                        fontSize: isDesktop ? 16 : 14,
                        height: 1.5,
                        color: Colors.grey[300],
                      ),
                    ),
                    Text(
                      '2019 - 2021',
                      style: GoogleFonts.roboto(
                        fontSize: isDesktop ? 14 : 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 40 : 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) ...[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Languages',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64FFDA),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMobile) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 0),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Languages',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64FFDA),
                          ),
                        ),
                      ),
                    ],
                    Text(
                      'Malayalam (Native)',
                      style: GoogleFonts.roboto(
                        fontSize: isDesktop ? 16 : 14,
                        height: 1.5,
                        color: Colors.grey[300],
                      ),
                    ),
                    Text(
                      'English (Proficient)',
                      style: GoogleFonts.roboto(
                        fontSize: isDesktop ? 16 : 14,
                        height: 1.5,
                        color: Colors.grey[300],
                      ),
                    ),
                    Text(
                      'Tamil (Basic)',
                      style: GoogleFonts.roboto(
                        fontSize: isDesktop ? 16 : 14,
                        height: 1.5,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool isDesktop,
      bool isTablet, bool isMobile, GlobalKey key) {
    return Container(
      key: key,
      padding: EdgeInsets.all(isDesktop
          ? 40
          : isTablet
              ? 30
              : 20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact',
            style: GoogleFonts.roboto(
              fontSize: isDesktop
                  ? 42
                  : isTablet
                      ? 36
                      : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isDesktop ? 32 : 24),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactCard(
                      'Email',
                      'yaseeensha.vm@gmail.com',
                      Icons.email,
                      'mailto:yaseeensha.vm@gmail.com',
                      isDesktop,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildContactCard(
                      'LinkedIn',
                      'linkedin.com/in/yaseensha',
                      FontAwesomeIcons.linkedin,
                      'https://www.linkedin.com/in/yaseen-sha/',
                      isDesktop,
                      context,
                    ),
                    const SizedBox(height: 16),
                    _buildContactCard(
                      'GitHub',
                      'github.com/yaseensha',
                      FontAwesomeIcons.github,
                      'https://github.com/Myaseensha',
                      isDesktop,
                      context,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildContactCard(
                        'Email',
                        'yaseeensha.vm@gmail.com',
                        Icons.email,
                        'mailto:yaseeensha.vm@gmail.com',
                        isDesktop,
                        context,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildContactCard(
                        'LinkedIn',
                        'linkedin.com/in/yaseen sha',
                        FontAwesomeIcons.linkedin,
                        'https://www.linkedin.com/in/yaseensha/',
                        isDesktop,
                        context,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildContactCard(
                        'GitHub',
                        'github.com/yaseensha',
                        FontAwesomeIcons.github,
                        'https://github.com/yaseensha',
                        isDesktop,
                        context,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildContactCard(
                        'Twitter',
                        'yaseensha',
                        FontAwesomeIcons.twitter,
                        'https://twitter.com/yaseeeensha',
                        isDesktop,
                        context,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildContactCard(
                        'Whatsapp',
                        '+91 892-159-0995',
                        FontAwesomeIcons.whatsapp,
                        'https://wa.me/918921590995',
                        isDesktop,
                        context,
                      ),
                    ),
                  ],
                ),
          SizedBox(height: isDesktop ? 48 : 32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isDesktop
                ? 40
                : isTablet
                    ? 30
                    : 20),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get In Touch',
                  style: GoogleFonts.roboto(
                    fontSize: isDesktop
                        ? 32
                        : isTablet
                            ? 28
                            : 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isDesktop ? 16 : 12),
                Text(
                  'I\'m currently available for freelance work. If you have a project that you want to get started, think you need my help with something or just want to say hello, then get in touch.',
                  style: GoogleFonts.roboto(
                    fontSize: isDesktop ? 16 : 14,
                    height: 1.6,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: isDesktop ? 32 : 24),
                ElevatedButton(
                  onPressed: () => _launchUrl('mailto:yaseeensha.vm@gmail.com'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF64FFDA),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 24,
                      vertical: isDesktop ? 18 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'MESSAGE ME',
                    style: GoogleFonts.roboto(
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isDesktop ? 48 : 32),
          Center(
            child: Text(
              '© ${DateTime.now().year} Yaseen Sha. All rights reserved. \nCrafted with Flutter @ 2024.',
              style: GoogleFonts.roboto(
                fontSize: isDesktop ? 14 : 12,
                color: Colors.grey[500], // Subtle professional color
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, String details, IconData icon,
      String url, bool isDesktop, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF64FFDA),
            size: 24,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _launchUrl(url),
            child: Text(
              details,
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: Colors.grey[300],
                decoration: TextDecoration.underline,
                decorationColor: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

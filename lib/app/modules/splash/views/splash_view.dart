import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 251, 207, 207),
              Color.fromARGB(255, 252, 186, 88),
              Color.fromARGB(255, 255, 140, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const _LogoIcon(),
              const SizedBox(height: 12),
              _FadeSlide(
                delay: 400,
                child: Text(
                  'Just Task It!',
                  style: GoogleFonts.lobster(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 242, 243, 244),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
               SizedBox(height: 8),
              _FadeSlide(
                delay: 750,
                slide: false,
                child: Text(
                  'Stay organized. Get things done.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.75),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              _FadeSlide(
                delay: 1000,
                slide: false,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoIcon extends StatefulWidget {
  const _LogoIcon();

  @override
  State<_LogoIcon> createState() => _LogoIconState();
}

class _LogoIconState extends State<_LogoIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final _scale = Tween<double>(
    begin: 0.4,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));

  late final _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 171, 171).withOpacity(0.15),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color.fromARGB(255, 121, 121, 121),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.checklist_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FadeSlide extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool slide;

  const _FadeSlide({
    required this.child,
    required this.delay,
    this.slide = true,
  });

  @override
  State<_FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<_FadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final _fade = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

  late final _slide = Tween<Offset>(
    begin: const Offset(0, 0.4),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child:
          widget.slide
              ? SlideTransition(position: _slide, child: widget.child)
              : widget.child,
    );
  }
}

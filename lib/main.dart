import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nirmala AI Assistant',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF0D0D0D),
            colorScheme: const ColorScheme.dark(
              surface: Color(0xFF171717),
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
              bodyColor: const Color(0xFFD9D9D9),
              displayColor: const Color(0xFFD9D9D9),
            ),
          ),
          home: const ChatScreen(),
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                children: [
                  _buildUserMessage("Tell me a quick life hack", "1 min ago"),
                  SizedBox(height: 24.h),
                  _buildAiMessage(),
                  SizedBox(height: 24.h),
                  _buildUserMessage("Why should we drink water?", "8 sec ago"),
                  SizedBox(height: 16.h),
                  _buildThinkingIndicator(),
                ],
              ),
            ),
            _buildBottomInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.sort, color: Colors.white, size: 28.w),
          Row(
            children: [
              Icon(Icons.graphic_eq, color: const Color(0xFFE79471), size: 24.w),
              SizedBox(width: 8.w),
              Text(
                'Nirmala',
                style: GoogleFonts.familjenGrotesk(
                  color: const Color(0xFFD9D9D9),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.36,
                ),
              ),
            ],
          ),
          Icon(Icons.add_box_outlined, color: Colors.white, size: 28.w),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF212121),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFF2E2E2E)),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFFD9D9D9),
                fontSize: 14.sp,
                letterSpacing: -0.14,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            time,
            style: TextStyle(
              color: const Color(0xFF7E7E7E),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF131313),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF2E2E2E)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Feeling overwhelmed?",
              style: TextStyle(
                color: const Color(0xFFD9D9D9),
                fontSize: 14.sp,
                letterSpacing: -0.14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: const Border(left: BorderSide(color: Color(0xFFE79471), width: 2)),
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "— Drink water", style: TextStyle(fontStyle: FontStyle.italic)),
                    const TextSpan(text: ", "),
                    const TextSpan(text: "put your phone down", style: TextStyle(fontStyle: FontStyle.italic)),
                    const TextSpan(text: ", and "),
                    const TextSpan(text: "take a 10-minute power nap", style: TextStyle(fontStyle: FontStyle.italic)),
                    const TextSpan(text: ".\nSometimes you don't need a solution, you just need a restart 😃"),
                  ],
                ),
                style: TextStyle(
                  color: const Color(0xFFD9D9D9),
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Need more? I got hacks for productivity, food, dating, saving money—you name it.",
              style: TextStyle(
                color: const Color(0xFFD9D9D9),
                fontSize: 14.sp,
                letterSpacing: -0.14,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(Icons.copy, color: const Color(0xFF7E7E7E), size: 16.w),
                SizedBox(width: 16.w),
                Icon(Icons.volume_up_outlined, color: const Color(0xFF7E7E7E), size: 18.w),
                SizedBox(width: 16.w),
                Icon(Icons.refresh, color: const Color(0xFF7E7E7E), size: 18.w),
                SizedBox(width: 16.w),
                Icon(Icons.ios_share, color: const Color(0xFF7E7E7E), size: 16.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Row(
      children: [
        Icon(Icons.auto_awesome, color: const Color(0xFF7E7E7E), size: 16.w),
        SizedBox(width: 8.w),
        Text(
          "Still thinking...",
          style: TextStyle(
            color: const Color(0xFF7E7E7E),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "and why 10-minute power nap? |",
                  style: TextStyle(
                    color: const Color(0xFFD9D9D9),
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Icon(Icons.attach_file, color: const Color(0xFF7E7E7E), size: 24.w),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_upward, color: const Color(0xFF171717), size: 18.w),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0x33E79471),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFE79471), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.psychology_outlined, color: const Color(0xFFE79471), size: 14.w),
                        SizedBox(width: 6.w),
                        Text(
                          "Deep Think",
                          style: TextStyle(
                            color: const Color(0xFFE79471),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0x08FFFFFF),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0x1AFFFFFF), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.public, color: const Color(0xFFAEAEAE), size: 14.w),
                        SizedBox(width: 6.w),
                        Text(
                          "Search",
                          style: TextStyle(
                            color: const Color(0xFFAEAEAE),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "GPT 4.1 mini",
                    style: TextStyle(
                      color: const Color(0xFF7E7E7E),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.keyboard_arrow_down, color: const Color(0xFF7E7E7E), size: 16.w),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

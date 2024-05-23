import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../store/tutors.dart';
import 'dart:developer';

part 'tutorpage.g.dart';

List<String> langs = ['en', 'zh'];

final tutors = Tutors();
final ScrollController msgsScrollController = ScrollController();

@swidget
Widget tutorsPage(BuildContext context) {
  reaction((_) => tutors.msgs.length, (_) {
    msgsScrollController
        .jumpTo(msgsScrollController.position.maxScrollExtent + 100);
    // msgsScrollController.animateTo(
    //   msgsScrollController.position.maxScrollExtent + 100,
    //   duration: const Duration(milliseconds: 200),
    //   curve: Curves.fastOutSlowIn,
    // );
  });

  return Scaffold(
    extendBody: true,
    appBar: topBar(),
    body: Container(
      decoration: background(),
      child: Observer(
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tutors.isTutorSelected
              ? tutorBody(tutors.tutor!, context)
              : tutorsBody(),
        ),
      ),
    ),
    floatingActionButton: fab(),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: appBar(),
  );
}

InkWell menuIcon(
  IconData icon,
  Color color,
  String text,
  void Function() onPress,
) =>
    InkWell(
      onTap: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );

BoxDecoration headerImg() => const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/header.png"),
        fit: BoxFit.cover,
      ),
    );

BoxDecoration background() => const BoxDecoration(
      // image: DecorationImage(
      //   image: AssetImage("images/background-gradient-lights.jpg"),
      //   fit: BoxFit.cover,
      // ),
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue,
          Colors.white,
        ],
      ),
    );

PreferredSize topBar() => PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Observer(
        builder: (_) => AppBar(
          title: Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
                width: 80,
              ),
              Expanded(
                child: Text(
                  tutors.isTutorSelected ? tutors.tutor!.name : 'Tutors',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(5, 5),
                          blurRadius: 5,
                        )
                      ]),
                ),
              ),
            ],
          ),
          flexibleSpace: Container(decoration: headerImg()),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          actions: tutors.isTutorSelected ? tutorActions() : tutorsActions(),
        ),
      ),
    );

List<Widget> tutorsActions() => const [
      IconButton(
        onPressed: null,
        icon: Icon(Icons.search, color: Colors.white),
      ),
      IconButton(
        onPressed: null,
        icon: Icon(Icons.bookmark, color: Colors.white),
      )
    ];

List<Widget> tutorActions() => [
      Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: DropdownButton(
          value: tutors.lang,
          items: langs
              .map(
                (e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())),
              )
              .toList(),
          onChanged: (l) {
            if (l != null) tutors.setLang(l);
          },
          underline: null,
        ),
      ),
    ];

InkWell tutorIcon = menuIcon(Icons.school, Colors.blue, '外教', () {
  tutors.clearTutor();
});
InkWell courseIcon =
    menuIcon(Icons.menu_book_rounded, Colors.black45, '课程', () {});
InkWell metaIcon = menuIcon(Icons.language, Colors.black45, '元宇宙', () {});
InkWell accountIcon = menuIcon(Icons.person, Colors.black45, '我的', () {});
InkWell invisibleIcon = menuIcon(Icons.menu, Colors.transparent, '', () {});

List<InkWell> menuIcons = [tutorIcon, courseIcon, metaIcon, accountIcon];
List<InkWell> menuMicIcons = [
  tutorIcon,
  courseIcon,
  invisibleIcon,
  metaIcon,
  accountIcon
];

Widget appBar() => Observer(
      builder: (_) => BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 50,
        shape: tutors.isTutorSelected ? const CircularNotchedRectangle() : null,
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tutors.isTutorSelected ? menuMicIcons : menuIcons,
        ),
      ),
    );

Widget fab() => Observer(
      builder: (_) => tutors.isTutorSelected
          ? SizedBox(
              height: 80,
              width: 80,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: tutors.isRecording
                      ? tutors.stopRecording
                      : tutors.startRecording,
                  shape: const CircleBorder(),
                  backgroundColor:
                      tutors.isRecording ? Colors.red : Colors.green,
                  child: const Icon(Icons.mic, size: 30),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );

SizedBox tutorCard(Tutor t) => SizedBox(
      width: 325,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Card(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/tutoricons/${t.id}.png",
                      height: 100,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(t.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(t.skill),
                        Text('语速 ${t.speed2}'),
                        Text(t.personality),
                      ],
                    ),
                    const Spacer(),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        Text(
                          '19,999',
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Text(t.desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          tutors.selectTutor(t);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[500]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Chat',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

SizedBox tutorList(int level) => SizedBox(
      height: 267,
      child: Observer(
        builder: (_) => ListView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          children: tutors.tutors
              .where((t) => t.level == level)
              .map((t) => tutorCard(t))
              .toList(),
        ),
      ),
    );

Container levelText(int level) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                    '⬤ ',
                    style: TextStyle(fontSize: 8, color: Colors.blue),
                  ),
                ),
                TextSpan(
                  text: 'Level $level',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );

List<Widget> tutorsBody() => [
      const SizedBox(height: 20),
      levelText(1),
      tutorList(1),
      const SizedBox(height: 10),
      levelText(2),
      tutorList(2),
    ];

List<Widget> tutorBody(Tutor t, BuildContext context) => [
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Image.asset(
          'assets/images/${tutors.isReading ? 'gif' : 'tutoricons'}/${t.id}.${tutors.isReading ? 'gif' : 'png'}',
          width: MediaQuery.of(context).size.width,
          height: 400,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
        ),
      ),
      msgList(context),
      const SizedBox(height: 80)
    ];

Widget msgList(BuildContext context) => Observer(
      builder: (_) => Expanded(
        child: ListView(
          controller: msgsScrollController,
          padding: const EdgeInsets.all(8),
          children: tutors.msgs
              .map(
                (m) =>
                    m.url != '' ? msgVoiceRow(m, context) : msgRow(m, context),
              )
              .toList(),
        ),
      ),
    );

Widget msgDot(Msg m, bool before) => Container(
      padding: const EdgeInsets.only(top: 4),
      child: before && m.url != ''
          ? const Icon(Icons.volume_up, size: 15, color: Colors.green)
          : Text(
              before ? (m.isAI ? '⬤ ' : '') : (m.isAI ? '' : ' ⬤'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w100,
                color: m.isAI ? Colors.green : Colors.blue[700],
              ),
            ),
    );

Row msgRow(Msg m, BuildContext context) => Row(
      mainAxisAlignment:
          m.isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: m.isWaiting
          ? [
              Image.asset(
                'assets/images/gif/dots.gif',
                width: 100,
                height: 50,
              ),
            ]
          : [
              msgDot(m, true),
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: Text(
                  ' ${m.text}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          m.isReading ? FontWeight.w800 : FontWeight.w500,
                      color: m.isAI ? Colors.black : Colors.indigo),
                  textAlign: m.isAI ? TextAlign.start : TextAlign.end,
                ),
              ),
              msgDot(m, false),
            ],
    );

InkWell msgVoiceRow(Msg m, BuildContext context) => InkWell(
    onTap: () {
      tutors.read(m);
    },
    child: msgRow(m, context));

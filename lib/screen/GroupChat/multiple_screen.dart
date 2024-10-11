// ignore_for_file: use_build_context_synchronously

import 'package:agora_new_updated/screen/Homepage/dashboardScreen.dart';
import 'package:agora_new_updated/screen/Homepage/home_screen.dart';
import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../helper/ad_helper.dart';
import '../../provider/agora_credientials.dart';
import '../../utils/constants.dart';

class MultipleUserVideo extends StatefulWidget {
  final String nodeKey;
  final String channelName;
  final String token;
  final bool isFirstTime;

  const MultipleUserVideo({
    required this.nodeKey,
    super.key,
    required this.channelName,
    required this.token,
    required this.isFirstTime,
  });

  @override
  State<MultipleUserVideo> createState() => _MultipleUserVideoState();
}

class _MultipleUserVideoState extends State<MultipleUserVideo>
    with WidgetsBindingObserver {
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool joined = false;
  int? uID;
  List<int> listOfUsers = [];
  late Future myFuture;
  bool isFindingNext = false;
  final createdNodeAsList = [];
  bool firstTime = false;
  bool isShowing = false;
  bool background = false;
  bool effects = false;
  bool voice = false;
  bool gifts = false;
  bool giftShow = true;
  bool isMute = false;
  bool soundLess = false;
  bool flash = false;
  Color selectedColor = Colors.transparent;

  bool isLocalView = true;

  @override
  void dispose() {
    _engine.leaveChannel();
    if (isFindingNext == false) {
      _engine.release();
    }

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFirstTime) {
        InterstitialAdClass.showInterstitialAd(
          context,
        );
      } else {
        if (InterstitialAdClass.count == InterstitialAdClass.limit) {
          InterstitialAdClass.showInterstitialAd(context);
        }
      }
    });
    myFuture = initAgora();
    super.initState();
  }

  initAgora() async {
    await Future.delayed(const Duration(seconds: 1));
    if (await Permission.camera.isGranted == false ||
        await Permission.microphone.isGranted == false) {
      await [Permission.microphone, Permission.camera].request();
    }
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: AgoraCredientials.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await _engine.enableVideo();

    await _engine.startPreview();
    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          if (joined == false) {
            setState(() {
              _localUserJoined = true;
            });
            uID = connection.localUid;
            listOfUsers.add(uID!);

            joined = true;
          }
        },
        onLeaveChannel: (rtc, stats) async {
          if (firstTime == true) {
            if (isFindingNext == false) {
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (ctx) => const DashBoardScreen(),
                  ),
                  (route) => false);
            } else {
              await _engine.release();
              final token =
                  await generateToken(createdNodeAsList[0]['channelName']);

              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => MultipleUserVideo(
                    nodeKey: createdNodeAsList[0]['key'],
                    channelName: createdNodeAsList[0]['channelName'],
                    token: token,
                    isFirstTime: false,
                  ),
                ),
                (route) => false,
              );
            }
            if (listOfUsers.length == 1) {
              await FirebaseDatabase.instance
                  .ref()
                  .child("multipleUsers")
                  .child(widget.nodeKey)
                  .remove();
            }
          }

          // listOfUsers.clear();
          // createdNodeAsList.clear();
        },
        onUserJoined: (RtcConnection connection, int id, int elapsed) async {
          listOfUsers.add(id);
          setState(() {});
          if (listOfUsers.length >= 4) {
            await FirebaseDatabase.instance
                .ref()
                .child("multipleUsers")
                .child(widget.nodeKey)
                .update(
              {
                'isWaiting': false,
              },
            );
          }
        },
        onUserOffline: (connection, remoteUid, reason) async {
          listOfUsers.remove(remoteUid);
          setState(() {});
          if (listOfUsers.length < 4) {
            await FirebaseDatabase.instance
                .ref()
                .child("multipleUsers")
                .child(widget.nodeKey)
                .update(
              {
                'isWaiting': true,
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 2,
        backgroundColor: mainClr,
        automaticallyImplyLeading: false,
        title: const Text(
          'Group Call',
          style: TextStyle(color: white),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : Stack(
                      children: [
                        listOfUsers.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.red,
                                ),
                              )
                            : listOfUsers.length == 1
                                ? createViewForOne()
                                : listOfUsers.length == 2
                                    ? Column(
                                        children: [
                                          Expanded(
                                            child: _remoteVideo(
                                                widget.channelName, 1),
                                          ),
                                          Expanded(
                                            child: createViewForOne(),
                                          ),
                                        ],
                                      )
                                    : listOfUsers.length == 3
                                        ? Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: _remoteVideo(
                                                          widget.channelName,
                                                          1),
                                                    ),
                                                    Expanded(
                                                      child: _remoteVideo(
                                                          widget.channelName,
                                                          2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: createViewForOne(),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: _remoteVideo(
                                                          widget.channelName,
                                                          1),
                                                    ),
                                                    Expanded(
                                                      child: _remoteVideo(
                                                          widget.channelName,
                                                          2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: _remoteVideo(
                                                        widget.channelName, 3),
                                                  ),
                                                  Expanded(
                                                    child: createViewForOne(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                        Positioned(
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      if (flash == false) {
                                        await _engine.setCameraTorchOn(true);
                                        flash = true;
                                      } else {
                                        await _engine.setCameraTorchOn(false);
                                        flash = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      flash
                                          ? 'assets/images/flash.png'
                                          : 'assets/images/flashOn.png',
                                      color: Colors.white,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      InterstitialAdClass.count += 1;
                                      if (InterstitialAdClass.count ==
                                          InterstitialAdClass.limit) {
                                        InterstitialAdClass.showInterstitialAd(
                                            context);
                                      }
                                      setState(() {
                                        background = false;
                                        gifts = false;
                                        voice = false;
                                        if (effects == false) {
                                          isShowing = true;
                                          effects = true;
                                        } else {
                                          isShowing = false;
                                          effects = false;
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/filter.png',
                                      color: Colors.white,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        effects = false;
                                        gifts = false;
                                        background = false;
                                        if (voice == false) {
                                          isShowing = true;
                                          voice = true;
                                        } else {
                                          isShowing = false;
                                          voice = false;
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/mic.png',
                                      color: Colors.white,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        effects = false;
                                        gifts = false;
                                        voice = false;
                                        if (background == false) {
                                          isShowing = true;
                                          background = true;
                                        } else {
                                          isShowing = false;
                                          background = false;
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/background.png',
                                      color: Colors.white,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isShowing && background,
                          child: Positioned(
                            bottom: 60.h,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _disableVirtualBackground();
                                        setState(() {
                                          selectedColor = Colors.transparent;
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/block.png',
                                        width: 40.h,
                                        height: 40.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _virtualBackgroundCOLOR(
                                            const Color(0xff56636A));
                                        setState(() {
                                          selectedColor =
                                              const Color(0xff56636A);
                                        });
                                      },
                                      child: absortPainter(
                                          const Color(0xff56636A)),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _virtualBackgroundCOLOR(
                                            const Color(0xff156C13));
                                        setState(() {
                                          selectedColor =
                                              const Color(0xff156C13);
                                        });
                                      },
                                      child: absortPainter(
                                          const Color(0xff156C13)),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _virtualBackgroundCOLOR(
                                                const Color(0xffEB19D6));

                                            selectedColor =
                                                const Color(0xffEB19D6);
                                          });
                                        },
                                        child: absortPainter(
                                            const Color(0xffEB19D6))),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          _virtualBackgroundCOLOR(
                                              const Color(0xff000000));
                                          setState(() {
                                            selectedColor =
                                                const Color(0xff000000);
                                          });
                                        },
                                        child: absortPainter(
                                            const Color(0xff000000))),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          _virtualBackgroundCOLOR(primaryColor);
                                          setState(() {
                                            selectedColor = primaryColor;
                                          });
                                        },
                                        child: absortPainter(primaryColor)),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          _virtualBackgroundCOLOR(
                                              const Color(0xffC81616));
                                          setState(() {
                                            selectedColor =
                                                const Color(0xffC81616);
                                          });
                                        },
                                        child: absortPainter(
                                            const Color(0xffC81616))),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          _virtualBackgroundCOLOR(
                                              const Color(0xff1688C8));
                                          setState(() {
                                            selectedColor =
                                                const Color(0xff1688C8);
                                          });
                                        },
                                        child: absortPainter(
                                            const Color(0xff1688C8))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // !onceReported ? reportUser(widget.nodeCreated) : null;

                        Visibility(
                          visible: isShowing && effects,
                          child: Positioned(
                            bottom: 60.h,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        LowlightEnhanceOptions
                                            lowlightEnhanceOptions =
                                            const LowlightEnhanceOptions();
                                        ColorEnhanceOptions
                                            colorEnhanceOptions =
                                            const ColorEnhanceOptions();

                                        await _engine.setBeautyEffectOptions(
                                            enabled: false,
                                            options: const BeautyOptions());

                                        await _engine.setLowlightEnhanceOptions(
                                            enabled: false,
                                            options: lowlightEnhanceOptions);

                                        await _engine.setColorEnhanceOptions(
                                            enabled: false,
                                            options: colorEnhanceOptions);
                                      },
                                      child: Image.asset(
                                        'assets/images/default.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        LowlightEnhanceOptions
                                            lowlightEnhanceOptions =
                                            const LowlightEnhanceOptions();
                                        ColorEnhanceOptions
                                            colorEnhanceOptions =
                                            const ColorEnhanceOptions(
                                                skinProtectLevel: 0.5,
                                                strengthLevel: 0.4);
                                        BeautyOptions beautyOptions =
                                            const BeautyOptions(
                                                lighteningLevel: 1,
                                                rednessLevel: 0.3,
                                                sharpnessLevel: 0.2,
                                                smoothnessLevel: 0.4);
                                        await _engine.setBeautyEffectOptions(
                                            enabled: true,
                                            options: beautyOptions);
                                        await _engine.setLowlightEnhanceOptions(
                                            enabled: true,
                                            options: lowlightEnhanceOptions);
                                        await _engine.setColorEnhanceOptions(
                                            enabled: true,
                                            options: colorEnhanceOptions);
                                      },
                                      child: Image.asset(
                                        'assets/images/vivid.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        LowlightEnhanceOptions
                                            lowlightEnhanceOptions =
                                            const LowlightEnhanceOptions();
                                        ColorEnhanceOptions
                                            colorEnhanceOptions =
                                            const ColorEnhanceOptions(
                                                skinProtectLevel: 1,
                                                strengthLevel: 1);
                                        BeautyOptions beautyOptions =
                                            const BeautyOptions(
                                                lighteningLevel: 1,
                                                rednessLevel: 0.9,
                                                sharpnessLevel: 0.8,
                                                smoothnessLevel: 0.1);
                                        await _engine.setBeautyEffectOptions(
                                            enabled: true,
                                            options: beautyOptions);
                                        await _engine.setLowlightEnhanceOptions(
                                            enabled: true,
                                            options: lowlightEnhanceOptions);
                                        await _engine.setColorEnhanceOptions(
                                            enabled: true,
                                            options: colorEnhanceOptions);
                                      },
                                      child: Image.asset(
                                        'assets/images/pop.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        ColorEnhanceOptions
                                            colorEnhanceOptions =
                                            const ColorEnhanceOptions(
                                                skinProtectLevel: 0.5,
                                                strengthLevel: 0.4);
                                        await _engine.setBeautyEffectOptions(
                                            enabled: true,
                                            options: const BeautyOptions(
                                                lighteningContrastLevel:
                                                    LighteningContrastLevel
                                                        .lighteningContrastHigh));
                                        await _engine.setColorEnhanceOptions(
                                            enabled: true,
                                            options: colorEnhanceOptions);
                                      },
                                      child: Image.asset(
                                        'assets/images/smooth.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        BeautyOptions beautyOptions =
                                            const BeautyOptions(
                                                rednessLevel: 1);
                                        await _engine.setBeautyEffectOptions(
                                            enabled: true,
                                            options: beautyOptions);
                                      },
                                      child: Image.asset(
                                        'assets/images/chromic.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        LowlightEnhanceOptions
                                            lowlightEnhanceOptions =
                                            const LowlightEnhanceOptions();
                                        BeautyOptions beautyOptions =
                                            const BeautyOptions(
                                                rednessLevel: 1);
                                        await _engine.setLowlightEnhanceOptions(
                                            enabled: true,
                                            options: lowlightEnhanceOptions);

                                        await _engine.setBeautyEffectOptions(
                                            enabled: true,
                                            options: beautyOptions);
                                      },
                                      child: Image.asset(
                                        'assets/images/pastel.png',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // !onceReported ? reportUser(widget.nodeCreated) : null;

                        Visibility(
                          visible: isShowing && voice,
                          child: Positioned(
                            bottom: 60.h,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await _engine.setVoiceBeautifierPreset(
                                            VoiceBeautifierPreset
                                                .voiceBeautifierOff);
                                        await _engine.setAudioEffectPreset(
                                            AudioEffectPreset.audioEffectOff);
                                        await _engine.setVoiceConversionPreset(
                                            VoiceConversionPreset
                                                .voiceConversionOff);
                                      },
                                      child: Image.asset(
                                        'assets/images/block.png',
                                        color: Colors.white,
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await _engine.setAudioEffectPreset(
                                            AudioEffectPreset
                                                .voiceChangerEffectOldman);
                                      },
                                      child: Image.asset(
                                        'assets/images/oldMan.png',
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await _engine.setAudioEffectPreset(
                                            AudioEffectPreset
                                                .voiceChangerEffectHulk);
                                      },
                                      child: Image.asset(
                                        'assets/images/hulk.png',
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await _engine.setAudioEffectPreset(
                                            AudioEffectPreset
                                                .voiceChangerEffectUncle);
                                      },
                                      child: Image.asset(
                                        'assets/images/uncle.png',
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await _engine.setAudioEffectPreset(
                                            AudioEffectPreset
                                                .voiceChangerEffectGirl);
                                      },
                                      child: Image.asset(
                                        'assets/images/girl.png',
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await _engine.setAudioEffectPreset(
                                            AudioEffectPreset
                                                .voiceChangerEffectBoy);
                                      },
                                      child: Image.asset(
                                        'assets/images/boy.png',
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await _engine.setVoiceBeautifierPreset(
                                            VoiceBeautifierPreset
                                                .singingBeautifier);
                                      },
                                      child: Image.asset(
                                        'assets/images/singing.png',
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 50.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      firstTime = true;
                                      await _engine.leaveChannel();
                                      Navigator.pushReplacement<void, void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const MyHomePage(),
                                        ),
                                      );
                                    },
                                    child: AbsorbPointer(
                                      child: Image.asset(
                                        'assets/images/endCall.png',
                                        width: 35.w,
                                        height: 35.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      if (isMute == false) {
                                        await _engine
                                            .muteLocalAudioStream(true);
                                        isMute = true;
                                      } else {
                                        await _engine
                                            .muteLocalAudioStream(false);
                                        isMute = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      !isMute
                                          ? 'assets/images/mic.png'
                                          : 'assets/images/micMute.png',
                                      color: Colors.white,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      await _engine.switchCamera();
                                    },
                                    child: Image.asset(
                                      'assets/images/cameraRotation.png',
                                      color: Colors.white,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      if (soundLess == false) {
                                        await _engine
                                            .muteAllRemoteAudioStreams(true);
                                        soundLess = true;
                                      } else {
                                        await _engine
                                            .muteAllRemoteAudioStreams(false);
                                        soundLess = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      !soundLess
                                          ? 'assets/images/speaker.png'
                                          : 'assets/images/speakerMute.png',
                                      color: Colors.white,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: listOfUsers.length == 1
                                        ? () {
                                            Fluttertoast.showToast(
                                                msg: 'finding next...');
                                          }
                                        : () async {
                                            InterstitialAdClass.count += 1;

                                            firstTime = true;

                                            final createdNodeFromDB =
                                                await FirebaseDatabase.instance
                                                    .ref()
                                                    .child('multipleUsers')
                                                    .orderByChild('isWaiting')
                                                    .equalTo(true)
                                                    .once();

                                            final createdNode =
                                                createdNodeFromDB
                                                    .snapshot.value;
                                            if (createdNode == null) {
                                              showException(
                                                  'No more people are online',
                                                  context);
                                              return;
                                            }
                                            final createdNodeAsMap =
                                                createdNode as Map;

                                            createdNodeAsMap.forEach(
                                              (key, value) {
                                                createdNodeAsList.add(
                                                  {
                                                    "key": key,
                                                    ...value,
                                                  },
                                                );
                                              },
                                            );

                                            createdNodeAsList.removeWhere(
                                              (element) =>
                                                  widget.nodeKey ==
                                                  element['key'],
                                            );

                                            if (createdNodeAsList.isEmpty) {
                                              showException(
                                                  'No more people are onli',
                                                  context);
                                            } else {
                                              await _engine.leaveChannel();

                                              isFindingNext = true;
                                            }
                                          },
                                    child: const Text(
                                      'Find Next',
                                      style: TextStyle(color: white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createViewForOne() {
    return _localUserJoined
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          )
        : const CircularProgressIndicator.adaptive(
            backgroundColor: Colors.red,
          );
  }

  Center _remoteVideo(String channelName, int index) {
    return Center(
      child: AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: listOfUsers[index]),
          connection: RtcConnection(channelId: channelName),
        ),
      ),
    );
  }

  bool _virtualBackgroundToggle = false;

  Future<String> generateToken(String channelName) async {
    var result =
        await FirebaseFunctions.instance.httpsCallable("generateToken").call(
      {
        'channelName': channelName,
      },
    );
    return result.data;
  }

  void _virtualBackgroundCOLOR(Color color) {
    late int newColor;
    if (color == const Color(0xff156C13)) {
      newColor = 0x156C13;
    } else if (color == const Color(0xffEB19D6)) {
      newColor = 0xEB19D6;
    } else if (color == const Color(0xff000000)) {
      newColor = 0x000000;
    } else if (color == primaryColor) {
      newColor = 0x9610FF;
    } else if (color == const Color(0xffC81616)) {
      newColor = 0xC81616;
    } else if (color == const Color(0xff1688C8)) {
      newColor = 0x1688C8;
    } else if (color == const Color(0xff56636A)) {
      newColor = 0x56636A;
    }

    VirtualBackgroundSource backgroundSource = VirtualBackgroundSource(
        backgroundSourceType: BackgroundSourceType.backgroundColor,
        color: newColor);

    _enableVirtualBackground(backgroundSource);
    _virtualBackgroundToggle = true;
  }

  void _enableVirtualBackground(VirtualBackgroundSource backgroundSource) {
    _engine.enableVirtualBackground(
        enabled: true,
        backgroundSource: backgroundSource,
        segproperty: const SegmentationProperty());
  }

  void _disableVirtualBackground() {
    _virtualBackgroundToggle = false;
    _engine.enableVirtualBackground(
      enabled: false,
      backgroundSource: const VirtualBackgroundSource(),
      segproperty: const SegmentationProperty(),
    );
  }

  AbsorbPointer absortPainter(Color color) {
    return AbsorbPointer(
      child: Container(
        width: 40.h,
        height: 40.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(30.r),
          ),
        ),
        child: selectedColor == color
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : const SizedBox(),
      ),
    );
  }
}

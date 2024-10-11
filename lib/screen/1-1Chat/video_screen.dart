import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:agora_new_updated/provider/agora_credientials.dart';
import 'package:agora_new_updated/screen/Homepage/dashboardScreen.dart';
import 'package:agora_new_updated/screen/Homepage/home_screen.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:agora_new_updated/utils/getDeviceID.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/ad_helper.dart';
import '../../utils/random_string.dart';

class VideoScreen extends StatefulWidget {
  final bool nodeCreated;
  final String token;
  final String channelName;
  final String nodeKey;
  final String? localuID;
  final bool isFirstTime;

  const VideoScreen({
    super.key,
    required this.nodeCreated,
    required this.channelName,
    required this.token,
    required this.nodeKey,
    this.localuID,
    required this.isFirstTime,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late SharedPreferences prefs;

  bool isLeaving = false;
  int? _remoteUid;
  bool findingNext = false;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  late Timer timer;
  User user = FirebaseAuth.instance.currentUser!;

  // final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  //     GlobalKey<ScaffoldMessengerState>();
  bool _virtualBackgroundToggle = false;
  late Directory dir;
  late File file;
  bool onceReported = false;
  String connectedTo = '';
  String uiDForBlocking = '';
  Color selectedColor = Colors.transparent;
  bool isShowing = false;
  bool background = false;
  bool effects = false;
  bool voice = false;
  bool gifts = false;
  bool giftShow = true;
  bool isMute = false;
  bool soundLess = false;
  bool flash = false;
  bool isLocalView = true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (isLeaving) {
      _engine.leaveChannel();
      _engine.release();
    }
    // timer.cancel();

    super.dispose();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
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

    initPrefs();

    loadModel();
    initDirectory();
    Future.delayed(Duration.zero).then(
      (value) {
        _initAgora();
      },
    );

    super.initState();
  }

  initDirectory() async {
    dir = await getApplicationDocumentsDirectory();
    file = File('${dir.path}/checkNudity.jpg');
  }

  Future<void> _initAgora() async {
    debugPrint('_initAgora called');
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: AgoraCredientials.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onLeaveChannel: (connection, stats) async {
          debugPrint("onLeaveChannel Local Side");
          if (findingNext == true) {
            if (widget.nodeCreated == true) {
              await findNextFromLocalUser();
            } else {
              await findNextFromRemoteUser();
            }
          } else {
            await leaveChannelFromLocalSide();
          }
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
          debugPrint('local user with ${connection.localUid} joined');

          if (mounted) {
            setState(
              () {
                _localUserJoined = true;
              },
            );
          }
        },
        onSnapshotTaken:
            (connection, uid, filePath, width, height, errCode) async {
          if (errCode == 0) {
            await imageClassification(filePath);
          }
        },
        onUserJoined: (RtcConnection connection, int id, int elapsed) async {
          await getUsername(widget.nodeCreated);
          await FirebaseDatabase.instance
              .ref()
              .child("users")
              .child(widget.nodeKey)
              .update(
            {
              'isWaiting': false,
            },
          );

          if (mounted) {
            setState(
              () {
                _remoteUid = id;
              },
            );
          }
          takeScreenShot();
        },
        onUserOffline: (connection, remoteUid, reason) async {
          debugPrint("onUserOffline RemoteSide");

          await leaveChannelFromRemoteSide();
        },
        onTokenPrivilegeWillExpire: (connection, token) async {
          String newToken = await generateToken(widget.channelName);
          _engine.renewToken(newToken);
        },
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
    _engine.registerMediaMetadataObserver(
        observer: MetadataObserver(
          onMetadataReceived: (metadata) {
            if (metadata.size == 1) {
              blockUser(widget.nodeCreated);
            }
          },
        ),
        type: MetadataType.videoMetadata);
    await _engine.setMaxMetadataSize(1024);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: const Text(
          "Video Screen",
          style: TextStyle(color: white),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: [
            _remoteVideo(widget.channelName),
            _localVideo()

            //             _remoteUid != null
            //                 ? Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Align(
            //                       alignment: Alignment.bottomRight,
            //                       child: ElevatedButton(
            //                         onPressed: () async {
            //                           findingNext = true;
            //                           await _engine.leaveChannel();
            //                         },
            //                         child: const Text('Find Next '),
            //                       ),
            //                     ),
            //                   )
            //                 : const SizedBox(),
            //             _remoteUid != null
            //                 ? Align(
            //                     alignment: Alignment.topRight,
            //                     child: ElevatedButton(
            //                       child:
            //                           Text(onceReported == false ? 'Report' : 'Reported'),
            //                       onPressed: () {
            //                         !onceReported ? reportUser(widget.nodeCreated) : null;
            //                       },
            //                     ),
            //                   )
            //                 : const SizedBox(),
            //             _remoteUid != null
            //                 ? Positioned(
            //                     top: 200,
            //                     child: ElevatedButton(
            //                       child: const Text('Block'),
            //                       onPressed: () async {
            //                         await blockUser(widget.nodeCreated);
            //                         await _engine.sendMetaData(
            //                             metadata: Metadata(
            //                               size: 1,
            //                               buffer: Uint8List(1),
            //                             ),
            //                             sourceType: VideoSourceType.videoSourceCamera);
            //                         await _engine.leaveChannel();
            //                       },
            //                     ),
            //                   )
            //                 : const SizedBox(),
            ,
            Positioned(
              top: 0,
              right: 120,
              child: Text(
                'Connected To: $connectedTo',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // _remoteUid != null
            //     ?
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
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: !onceReported
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                          'Do you want to report him/her?',
                                        ),
                                        actions: [
                                          CupertinoButton(
                                              child: const Text(
                                                'No',
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                          CupertinoButton(
                                            onPressed: _remoteUid == null
                                                ? null
                                                : () async {
                                                    await reportUser(
                                                        widget.nodeCreated);
                                                    Navigator.pop(context);
                                                  },
                                            child: const Text(
                                              'Yes',
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            : null,
                        child: Image.asset(
                          'assets/images/report.png',
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
                            InterstitialAdClass.showInterstitialAd(context);
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
                      SizedBox(
                        height: 15.h,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text(
                                      'Do you want to block him/her?'),
                                  content: const Text(
                                      'The call will be disconnected immediately after blocking'),
                                  actions: [
                                    CupertinoButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoButton(
                                        onPressed: _remoteUid == null
                                            ? null
                                            : () async {
                                                await blockUser(
                                                    widget.nodeCreated);
                                                await _engine.sendMetaData(
                                                    metadata: Metadata(
                                                      size: 1,
                                                      buffer: Uint8List(1),
                                                    ),
                                                    sourceType: VideoSourceType
                                                        .videoSourceCamera);
                                                await _engine.leaveChannel();
                                              },
                                        child: const Text('Yes'))
                                  ],
                                );
                              });
                        },
                        child: Image.asset(
                          'assets/images/block.png',
                          color: Colors.white,
                          width: 30.w,
                          height: 30.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            // : const SizedBox(),
            ,
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
                            await _engine.muteLocalAudioStream(true);
                            isMute = true;
                          } else {
                            await _engine.muteLocalAudioStream(false);
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
                            await _engine.muteAllRemoteAudioStreams(true);
                            soundLess = true;
                          } else {
                            await _engine.muteAllRemoteAudioStreams(false);
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
                        onPressed: _remoteUid == null
                            ? () {
                                Fluttertoast.showToast(msg: 'finding next...');
                              }
                            : () async {
                                InterstitialAdClass.count += 1;

                                findingNext = true;
                                await _engine.leaveChannel();
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
                            _virtualBackgroundCOLOR(const Color(0xff56636A));
                            setState(() {
                              selectedColor = const Color(0xff56636A);
                            });
                          },
                          child: absortPainter(const Color(0xff56636A)),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            _virtualBackgroundCOLOR(const Color(0xff156C13));
                            setState(() {
                              selectedColor = const Color(0xff156C13);
                            });
                          },
                          child: absortPainter(const Color(0xff156C13)),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _virtualBackgroundCOLOR(
                                    const Color(0xffEB19D6));

                                selectedColor = const Color(0xffEB19D6);
                              });
                            },
                            child: absortPainter(const Color(0xffEB19D6))),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                            onTap: () {
                              _virtualBackgroundCOLOR(const Color(0xff000000));
                              setState(() {
                                selectedColor = const Color(0xff000000);
                              });
                            },
                            child: absortPainter(const Color(0xff000000))),
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
                              _virtualBackgroundCOLOR(const Color(0xffC81616));
                              setState(() {
                                selectedColor = const Color(0xffC81616);
                              });
                            },
                            child: absortPainter(const Color(0xffC81616))),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                            onTap: () {
                              _virtualBackgroundCOLOR(const Color(0xff1688C8));
                              setState(() {
                                selectedColor = const Color(0xff1688C8);
                              });
                            },
                            child: absortPainter(const Color(0xff1688C8))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //   !onceReported ? reportUser(widget.nodeCreated) : null;

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
                            LowlightEnhanceOptions lowlightEnhanceOptions =
                                const LowlightEnhanceOptions();
                            ColorEnhanceOptions colorEnhanceOptions =
                                const ColorEnhanceOptions();

                            await _engine.setBeautyEffectOptions(
                                enabled: false, options: const BeautyOptions());

                            await _engine.setLowlightEnhanceOptions(
                                enabled: false,
                                options: lowlightEnhanceOptions);

                            await _engine.setColorEnhanceOptions(
                                enabled: false, options: colorEnhanceOptions);
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
                            LowlightEnhanceOptions lowlightEnhanceOptions =
                                const LowlightEnhanceOptions();
                            ColorEnhanceOptions colorEnhanceOptions =
                                const ColorEnhanceOptions(
                                    skinProtectLevel: 0.5, strengthLevel: 0.4);
                            BeautyOptions beautyOptions = const BeautyOptions(
                                lighteningLevel: 1,
                                rednessLevel: 0.3,
                                sharpnessLevel: 0.2,
                                smoothnessLevel: 0.4);
                            await _engine.setBeautyEffectOptions(
                                enabled: true, options: beautyOptions);
                            await _engine.setLowlightEnhanceOptions(
                                enabled: true, options: lowlightEnhanceOptions);
                            await _engine.setColorEnhanceOptions(
                                enabled: true, options: colorEnhanceOptions);
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
                            LowlightEnhanceOptions lowlightEnhanceOptions =
                                const LowlightEnhanceOptions();
                            ColorEnhanceOptions colorEnhanceOptions =
                                const ColorEnhanceOptions(
                                    skinProtectLevel: 1, strengthLevel: 1);
                            BeautyOptions beautyOptions = const BeautyOptions(
                                lighteningLevel: 1,
                                rednessLevel: 0.9,
                                sharpnessLevel: 0.8,
                                smoothnessLevel: 0.1);
                            await _engine.setBeautyEffectOptions(
                                enabled: true, options: beautyOptions);
                            await _engine.setLowlightEnhanceOptions(
                                enabled: true, options: lowlightEnhanceOptions);
                            await _engine.setColorEnhanceOptions(
                                enabled: true, options: colorEnhanceOptions);
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
                            ColorEnhanceOptions colorEnhanceOptions =
                                const ColorEnhanceOptions(
                                    skinProtectLevel: 0.5, strengthLevel: 0.4);
                            await _engine.setBeautyEffectOptions(
                                enabled: true,
                                options: const BeautyOptions(
                                    lighteningContrastLevel:
                                        LighteningContrastLevel
                                            .lighteningContrastHigh));
                            await _engine.setColorEnhanceOptions(
                                enabled: true, options: colorEnhanceOptions);
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
                                const BeautyOptions(rednessLevel: 1);
                            await _engine.setBeautyEffectOptions(
                                enabled: true, options: beautyOptions);
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
                            LowlightEnhanceOptions lowlightEnhanceOptions =
                                const LowlightEnhanceOptions();
                            BeautyOptions beautyOptions =
                                const BeautyOptions(rednessLevel: 1);
                            await _engine.setLowlightEnhanceOptions(
                                enabled: true, options: lowlightEnhanceOptions);

                            await _engine.setBeautyEffectOptions(
                                enabled: true, options: beautyOptions);
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

            //   !onceReported ? reportUser(widget.nodeCreated) : null;

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
                                VoiceBeautifierPreset.voiceBeautifierOff);
                            await _engine.setAudioEffectPreset(
                                AudioEffectPreset.audioEffectOff);
                            await _engine.setVoiceConversionPreset(
                                VoiceConversionPreset.voiceConversionOff);
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
                                AudioEffectPreset.voiceChangerEffectOldman);
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
                                AudioEffectPreset.voiceChangerEffectHulk);
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
                                AudioEffectPreset.voiceChangerEffectUncle);
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
                                AudioEffectPreset.voiceChangerEffectGirl);
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
                                AudioEffectPreset.voiceChangerEffectBoy);
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
                                VoiceBeautifierPreset.singingBeautifier);
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
          ],
        ),
      ),
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

  showMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  Center _remoteVideo(String channelName) {
    if (_remoteUid != null) {
      return Center(
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channelName),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Please wait for remote user to join',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget remoteVideo(String channelName) {
    if (_remoteUid != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 150,
          width: 100,
          child: AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: _remoteUid),
              connection: RtcConnection(channelId: channelName),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          color: backgroundColor,
          height: 150,
          width: 100,
          child: const Text(
            'Please wait for remote user to join',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Padding _localVideo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150,
        width: 100,
        child: _localUserJoined
            ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget localVideo() {
    return _localUserJoined
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          )
        : const CircularProgressIndicator();
  }

  Future leaveChannelFromLocalSide() async {
    isLeaving = true;
    final navigator = Navigator.of(context);

    if (widget.nodeCreated == true) {
      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(widget.nodeKey)
          .remove();

      navigator.pushAndRemoveUntil(CupertinoPageRoute(
        builder: (context) {
          return const DashBoardScreen();
        },
      ), (route) => false);
    } else {
      navigator.pushAndRemoveUntil(CupertinoPageRoute(builder: (context) {
        return const DashBoardScreen();
      }), (route) => false);
    }
  }

  Future leaveChannelFromRemoteSide() async {
    isLeaving = true;
    onceReported = false;

    debugPrint("leaveChannelFromRemoteSide called()");
    if (widget.nodeCreated == true) {
      showMessage("User Left");
    } else if (widget.nodeCreated == false) {
      showMessage("User Left, Search For More");
    }
    final navigator = Navigator.of(context);

    if (mounted) {
      setState(
        () {
          _remoteUid = null;
        },
      );
    }
    if (widget.nodeCreated == true) {
      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(widget.nodeKey)
          .update(
        {
          'isWaiting': true,
          'remoteUID': '',
          'connectedTo': '',
        },
      );
    }

    if (widget.nodeCreated == false) {
      navigator.pushAndRemoveUntil(CupertinoPageRoute(
        builder: (context) {
          return const DashBoardScreen();
        },
      ), (route) => false);
    }
  }

  Future findNextFromLocalUser() async {
    findingNext = false;
    debugPrint("findNextFromLocalUser called()");
    final navigator = Navigator.of(context);

    final createdNodesFromDB = await FirebaseDatabase.instance
        .ref()
        .child("users")
        .orderByChild("isWaiting") //deviceId
        .equalTo(true)
        .once();

    final createdNode = createdNodesFromDB.snapshot.value;
    debugPrint('${createdNode}createdCodeFromDatabase');
    if (createdNode == null) {
      debugPrint("createdNode == null");

      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(widget.nodeKey)
          .update(
        {
          'isWaiting': true,
          'remoteUID': '',
          'connectedTo': '',
        },
      );
      await _engine.release();
      debugPrint("${widget.channelName} ${widget.token} token and channelName");
      navigator.push(CupertinoPageRoute(
          builder: (context) {
            return VideoScreen(
              isFirstTime: false,

              nodeCreated: true,
              channelName: widget.channelName,
              token: widget.token, //TOKEN
              nodeKey: widget.nodeKey,
            );
          },
          maintainState: true));
    } else {
      final createdNodeAsMap = createdNode as Map;
      final createdNodeAsList = [];
      createdNodeAsMap.forEach(
        (key, value) {
          createdNodeAsList.add(
            {"key": key, ...value},
          );
        },
      );

      String? savedListString = prefs.getString('myList');
      List<dynamic> savedList = json.decode(savedListString ?? '[]');

      final filteretedList = savedList.isEmpty
          ? createdNodeAsList
          : createdNodeAsList
              .where((e) => !savedList.contains(e['uId']))
              .toList();

      if (filteretedList.isEmpty) {
        await FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(widget.nodeKey)
            .update(
          {
            'isWaiting': true,
            'remoteUID': '',
            'connectedTo': '',
          },
        );
        await _engine.release();
        debugPrint(
            "${widget.channelName} ${widget.token} token and channelName");
        navigator.push(CupertinoPageRoute(
            builder: (context) {
              return VideoScreen(
                isFirstTime: false,

                nodeCreated: true,
                channelName: widget.channelName,
                token: widget.token, //TOKEN
                nodeKey: widget.nodeKey,
              );
            },
            maintainState: true));

        return;
      }

      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(widget.nodeKey)
          .remove();

      await _engine.release();
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(filteretedList[0]['key'])
          .update(
              {"remoteUID": user.uid, 'connectedTo': user.displayName ?? ""});
      String token = await generateToken(filteretedList[0]['channelName']);
      navigator.push(
        CupertinoPageRoute(
            builder: (context) {
              return VideoScreen(
                isFirstTime: false,
                nodeCreated: false,
                channelName: filteretedList[0]['channelName'],
                token: token,
                localuID: filteretedList[0]['uId'],
                nodeKey: filteretedList[0]['key'],
              );
            },
            maintainState: true),
      );
    }
  }

  Future findNextFromRemoteUser() async {
    findingNext = false;
    debugPrint("findNextFromRemoteUser called()");
    final navigator = Navigator.of(context);
    // String? deviceId = await PlatformDeviceId.getDeviceId;
    String? deviceId = await PlatformDeviceId.getDeviceId();

    final createdNodeFromDb = await FirebaseDatabase.instance
        .ref()
        .child("users")
        .orderByChild("isWaiting")
        .equalTo(true)
        .once();

    final createdNode = createdNodeFromDb.snapshot.value;
    if (createdNode == null) {
      createNewNodeForRemoteUser(deviceId);
    } else {
      final createdNodeAsMap = createdNode as Map;
      final createdNodeAsList = [];
      createdNodeAsMap.forEach(
        (key, value) {
          createdNodeAsList.add(
            {"key": key, ...value},
          );
        },
      );
      String? savedListString = prefs.getString('myList');
      List<dynamic> savedList = json.decode(savedListString ?? '[]');

      final filteretedList = savedList.isEmpty
          ? createdNodeAsList
          : createdNodeAsList
              .where((e) => !savedList.contains(e['uId']))
              .toList();

      if (filteretedList.isEmpty) {
        createNewNodeForRemoteUser(deviceId);
        return;
      }
      await _engine.release();
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(filteretedList[0]['key'])
          .update(
              {"remoteUID": user.uid, 'connectedTo': user.displayName ?? ""});
      String token = await generateToken(filteretedList[0]['channelName']);
      navigator.push(
        CupertinoPageRoute(
            builder: (context) {
              return VideoScreen(
                isFirstTime: false,
                nodeCreated: false,
                channelName: filteretedList[0]['channelName'],
                token: token,
                localuID: filteretedList[0]['uId'],
                nodeKey: filteretedList[0]['key'],
              );
            },
            maintainState: true),
      );
    }
  }

  void createNewNodeForRemoteUser(String deviceId) async {
    final nodeId = FirebaseDatabase.instance.ref().push().key;
    final nodeReference =
        FirebaseDatabase.instance.ref().child("users").child(nodeId!);
    final channelName = getRandomString(15);
    String token = await generateToken(channelName);
    await nodeReference.set({
      'uId': user.uid,
      'deviceId': deviceId,
      "channelName": channelName,
      "isWaiting": true,
      "name": user.displayName ?? " ",
      "token": token,
    }).then((value) async {
      final navigator = Navigator.of(context);
      await _engine.release();
      navigator.push(CupertinoPageRoute(builder: (context) {
        return VideoScreen(
            isFirstTime: false,
            nodeCreated: true,
            channelName: channelName,
            token: token,
            nodeKey: nodeId);
      }));
    });
  }

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

  loadModel() async {
    Tflite.close();

    final res = (await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    ))!;
  }

  takeScreenShot() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_remoteUid != null) {
        await _engine.takeSnapshot(uid: 0, filePath: file.path);
      }
    });
  }

  Future imageClassification(String path) async {
    final res = await Tflite.runModelOnImage(
      path: path,
      numResults: 6,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (res![res.length - 1]['label'] == 'sexy' ||
        res[res.length - 1]['label'] == 'porn') {
      Fluttertoast.showToast(
          msg: "Nudity Detected, You will be banned next time");
      await _engine.switchCamera();
    }
  }

  Future reportUser(
    bool nodeCreated,
  ) async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      Fluttertoast.showToast(msg: "User Reported");
      setState(() {
        onceReported = true;
      });
    });
    if (!nodeCreated) {
      final reportedUser = await FirebaseDatabase.instance
          .ref()
          .child('reportedUser')
          .child(widget.localuID!)
          .once();

      if (reportedUser.snapshot.value == null) {
        await FirebaseDatabase.instance
            .ref()
            .child("reportedUser")
            .child(widget.localuID!)
            .set({"count": 1});
      } else {
        final reportedUserAsMap = reportedUser.snapshot.value as Map;
        await FirebaseDatabase.instance
            .ref()
            .child("reportedUser")
            .child(widget.localuID!)
            .set({"count": reportedUserAsMap['count'] + 1});
      }
    } else {
      final key = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(widget.nodeKey)
          .once();

      final nodeKey = key.snapshot.value as Map;

      final remoteUserAuthId = nodeKey['remoteUID'];
      final reportedUser = await FirebaseDatabase.instance
          .ref()
          .child('reportedUser')
          .child(remoteUserAuthId)
          .once();

      if (reportedUser.snapshot.value == null) {
        await FirebaseDatabase.instance
            .ref()
            .child("reportedUser")
            .child(remoteUserAuthId)
            .set({"count": 1});
      } else {
        final reportedUserAsMap = reportedUser.snapshot.value as Map;
        await FirebaseDatabase.instance
            .ref()
            .child("reportedUser")
            .child(remoteUserAuthId)
            .set(
          {
            "count": reportedUserAsMap['count'] + 1,
          },
        );
      }
    }
  }

  Future blockUser(bool nodeCreated) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedListString = prefs.getString('myList');

    List<dynamic> savedList = json.decode(savedListString ?? '[]');
    savedList.add(nodeCreated ? uiDForBlocking : widget.localuID);
    String modifiedListString = json.encode(savedList);
    await prefs.setString('myList', modifiedListString);
  }

  Future getUsername(bool nodeCreated) async {
    final key = await FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(widget.nodeKey)
        .once();

    final nodeKey = key.snapshot.value as Map;
    connectedTo = nodeKey[nodeCreated == true ? 'connectedTo' : 'name'];
    uiDForBlocking = nodeKey['remoteUID'];
    setState(() {});
  }
}

// class Gifss extends StatelessWidget {
//   const Gifss({
//     required this.string,
//     super.key,
//     required this.controller,
//   });
//   final String string;

//   final GifController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Gif(
//       controller: controller,
//       image: AssetImage(
//         "assets/gifs/$string.gif",
//       ),
//     );
//   }
// }

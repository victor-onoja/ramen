import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noodle/src/core/config/rtc.dart';
import 'package:noodle/src/core/config/rtc_signaling.dart';
import 'package:noodle/src/core/models/user.dart';
// ignore: import_of_legacy_library_into_null_safe

class CallScreen extends StatefulWidget {
  CallScreen({Key? key}) : super(key: key);

  static Route route({required User peer}) {
    return MaterialPageRoute<void>(builder: (_) => CallScreen());
  }

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final RTCSignaling rtcSignaling =
      new RTCSignaling(host: "127.0.0.1", port: 3000);

  @override
  void dispose() {
    rtcPeerToPeer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    rtcPeerToPeer.initRenderer();

    rtcPeerToPeer.createPC().then((pc) => rtcPeerToPeer.setPeerConnection(pc));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: SafeArea(
          child: Stack(children: [
            Container(
              key: Key("remote"),
              child: RTCVideoView(
                rtcPeerToPeer.remoteRenderer,
                mirror: true,
              ),
            ),
            Column(
              children: [
                // Top
                _TopSection(),
                // Middle
                _MiddleSection()
              ],
            )
          ]),
        ));
  }
}

class _TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? peer; //TODO
    List<Widget> buildInfo() {
      return [
        // Avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          child: ClipRRect(
            child: Image.network(
                "https://th.bing.com/th/id/OIP.xzIfQQCZiBpvccxSZUsOSAHaHa?pid=ImgDet&rs=1"),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        SizedBox(width: 10),
        // Name & Username
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 200,
              child: Text(
                'Tin Chung',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              height: 30,
              width: 200,
              child: Text(
                '@tinchung',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              alignment: Alignment.centerLeft,
            )
          ],
        )
      ];
    }

    Widget buildBackButton() {
      return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
          child: IconButton(
              icon: FaIcon(FontAwesomeIcons.home),
              onPressed: () {
                Navigator.pop(context);
              }));
    }

    return Container(
        height: 90,
        color: Colors.black54,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                children: peer == null
                    ? [
                        Text(
                          "Finding...",
                          style: Theme.of(context).textTheme.headline1,
                        )
                      ]
                    : buildInfo()),
            Spacer(),
            buildBackButton()
          ],
        ));
  }
}

class _MiddleSection extends StatelessWidget {
  Widget buildInteractionButtons() {
    return Container(
      width: 90,
      color: Colors.blue,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              3,
              (index) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.red,
                  margin: EdgeInsets.only(top: 20)))),
    );
  }

  Widget buildCamera() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          key: Key("local"),
          width: 150,
          height: 230,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: RTCVideoView(
              rtcPeerToPeer.localRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey,
          ),
          margin: EdgeInsets.only(left: 20, bottom: 20),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCamera(), Spacer(), //buildInteractionButtons()
      ],
    ));
  }
}
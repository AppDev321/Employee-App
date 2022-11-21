
import 'package:flutter/material.dart';


class IndividualChats extends StatefulWidget {
  const IndividualChats({Key? key})
      : super(key: key);


  @override
  _IndividualChatsState createState() => _IndividualChatsState();
}

class _IndividualChatsState extends State<IndividualChats> {
  bool showEmoji = false;
  FocusNode focusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  bool sendChatButton = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showEmoji = false;
        });
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, size: 24),
                CircleAvatar(
                  child: Icon(
                   Icons.person,
                      color: Colors.white,
                      size: 38),
                  backgroundColor: Colors.purple[400],
                  radius: 20,
                )
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Test Chat",
                      style: TextStyle(
                          fontSize: 18.5, fontWeight: FontWeight.bold)),
                  Text("last seen at 14:00", style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: Icon(Icons.call)),
            PopupMenuButton<String>(onSelected: (value) {
              print(value);
            }, itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("View Contact"),
                  value: "View Contact",
                ),
                PopupMenuItem(
                  child: Text("Media, links, and docs"),
                  value: "Media, links, and docs",
                ),
                PopupMenuItem(
                  child: Text("Search"),
                  value: "Search",
                ),
                PopupMenuItem(
                  child: Text("Mute notification"),
                  value: "Mute notification",
                ),
                PopupMenuItem(
                  child: Text("Wallpaper"),
                  value: "Wallpaper",
                ),
                PopupMenuItem(
                  child: Text("More"),
                  value: "More",
                ),
              ];
            })
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WillPopScope(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(height: 70);
                      })),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width - 55,
                              child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: TextFormField(
                                    controller: _textController,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        setState(() {
                                          sendChatButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendChatButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type your message",
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                      Colors.transparent,
                                                      context: context,
                                                      builder: (builder) =>
                                                          bottomSheet());
                                                },
                                                icon: Icon(Icons.attach_file)),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.camera))
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.all(5),
                                        prefixIcon: IconButton(
                                          icon: Icon(showEmoji
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions),
                                          onPressed: () {
                                            if (!showEmoji) {
                                              focusNode.unfocus();
                                              focusNode.canRequestFocus = false;
                                            }

                                            setState(() {
                                              showEmoji = !showEmoji;
                                            });
                                          },
                                        )),
                                  ))),
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 8.0, right: 2),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.purple[400],
                              child:
                              IconButton(
                                  onPressed: () {
                                    if (sendChatButton) {
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut);

                                      _textController.clear();
                                      setState(() {
                                        sendChatButton = false;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    sendChatButton ? Icons.send : Icons.mic,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      showEmoji ? emojiSelect() : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onWillPop: () {
            if (showEmoji == true) {
              setState(() {
                showEmoji = false;
              });
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 270,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  bottomSheetIcons(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(width: 40),
                  bottomSheetIcons(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(width: 40),
                  bottomSheetIcons(Icons.insert_photo, Colors.purple, "Gallery")
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  bottomSheetIcons(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(width: 40),
                  bottomSheetIcons(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(width: 40),
                  bottomSheetIcons(Icons.person, Colors.blue, "Contact")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetIcons(IconData icon, Color bgColor, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 30,
            child: Icon(icon, size: 29, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(text, style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return Center(
    );
  }
}
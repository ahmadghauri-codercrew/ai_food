import 'package:ai_food/Constants/app_logger.dart';
import 'package:ai_food/Utils/resources/res/app_theme.dart';
import 'package:ai_food/Utils/widgets/others/app_field.dart';
import 'package:ai_food/Utils/widgets/others/app_text.dart';
import 'package:ai_food/config/dio/app_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Media {
  final String title;
  final String image;
  final String link;

  Media({required this.title, required this.image, required this.link});
}

class Message {
  final String text;
  final List<Media>? media; // Nullable list of media
  final bool isUser;

  Message({required this.text, this.media, required this.isUser});
}

class AskMaidaScreen extends StatefulWidget {
  const AskMaidaScreen({super.key});

  @override
  State<AskMaidaScreen> createState() => _AskMaidaScreenState();
}

class _AskMaidaScreenState extends State<AskMaidaScreen> {
  TextEditingController _controller = TextEditingController();
  AppLogger logger = AppLogger();
  ScrollController _scrollController = ScrollController();
  late AppDio dio;
  List<Message> _messages = [];

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 244, 244),
          appBar: AppBar(
            elevation: 5,
            backgroundColor: AppTheme.whiteColor,
            toolbarHeight: 50,
            title: AppText.appText("Ask Maida",
                fontWeight: FontWeight.w600,
                fontSize: 24,
                textColor: AppTheme.appColor),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.appColor),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AppText.appText(
                          "There are the instances where errors may be generated by AI.",
                          textAlign: TextAlign.center,
                          textColor: AppTheme.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              const Divider(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                child: _buildUserInput(),
              ),
            ],
          )),
    );
  }

  Widget _buildUserInput() {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppTheme.appColor, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
              child: TextField(
                cursorColor: AppTheme.whiteColor,
                style: TextStyle(color: AppTheme.whiteColor, fontSize: 18),
                autofocus: false,
                controller: _controller,
                decoration: InputDecoration.collapsed(
                    hintText: 'Enter Query',
                    hintStyle: TextStyle(color: AppTheme.whiteColor)),
              ),
            ),
            InkWell(
              onTap: () {
                final userMessage = _controller.text;
                if (userMessage.isNotEmpty) {
                  _handleUserInput(userMessage, null);
                  _controller.clear();
                }
              },
              child: Center(
                child: Icon(
                  Icons.send,
                  color: AppTheme.whiteColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleUserInput(String input, media) async {
    _addMessage(input, true, media);
    try {
      var aiResponse = await getAIResponse(input);
      final answerText = aiResponse['answerText'];
      final mediaList = aiResponse['media'];
      final mediaObjects = <Media>[];
      for (var media in mediaList) {
        mediaObjects.add(
          Media(
            title: media['title'],
            image: media['image'],
            link: media['link'],
          ),
        );
      }
      _addMessage(answerText, false, mediaObjects);
    } catch (e) {
      print('Error getting AI response: $e');
    }
  }

  _addMessage(String text, bool isUser, List<Media>? mediaObjects) {
    setState(() {
      _messages.add(Message(text: text, isUser: isUser, media: mediaObjects));
    });
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<Map<String, dynamic>> getAIResponse(String input) async {
    const apiKey = 'd9186e5f351240e094658382be62d948';
    final apiUrl =
        'https://api.spoonacular.com/food/converse?text=$input&contextId=342939&apiKey=$apiKey';
    final response = await dio.get(path: apiUrl);
    if (response.statusCode == 200) {
      final responseData = response.data;
      return responseData;
    } else {
      throw Exception('Failed to get AI response');
    }
  }

  Widget _buildMessageBubble(Message message) {
    return Container(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? AppTheme.appColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.isUser
                ? Container(
                    child: Text(
                      message.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(color: AppTheme.appColor),
                    ),
                  ),
            const SizedBox(
              height: 5,
            ),
            if (message.media != null) ...[
              for (var media in message.media!)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(media.image)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              media.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  final youtubeUrl = "${media.link}";

                                  if (await canLaunch(youtubeUrl)) {
                                    await launch(youtubeUrl);
                                  } else {
                                    throw 'Could not launch $youtubeUrl';
                                  }
                                },
                                child: Text(
                                  media.link,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 108, 142, 170)),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
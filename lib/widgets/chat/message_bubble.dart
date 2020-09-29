import 'package:flutter/material.dart';
import 'package:ivite_flutter/model/chat_message.dart';
import 'package:ivite_flutter/widgets/chat/poll.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.message,
    this.userName,
    this.userImage,
    this.isMe, {
    this.key,
  });

  final Key key;
  final ChatMessage message;
  final String userName;
  final String userImage;
  final bool isMe;


  Widget _getTextMessageWidget(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          userName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isMe
                ? Colors.black
                : Theme.of(context).accentTextTheme.headline1.color,
          ),
        ),
        Text(
          message.content,
          style: TextStyle(
            color: isMe
                ? Colors.black
                : Theme.of(context).accentTextTheme.headline1.color,
          ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }


  Widget _getTextMessageContainer(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
            bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
          ),
        ),
        width: 140,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: _getTextMessageWidget(context)
    );
  }

  Widget _getMessageWidget(BuildContext context) {
    if (this.message.type == MessageType.text) {
      return _getTextMessageContainer(context);
    } else if (this.message.type == MessageType.poll) {
      return PollWidget(pollId: this.message.content);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            _getMessageWidget(context),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: userImage == null || userImage.length == 0
              ? CircleAvatar(
                  child: Image(
                    image: AssetImage('assets/images/no_profile_pic.jpg'),
                  ),

                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(
                    userImage,
                  ),
                ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../bloc/connected_bloc.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/internet_not_available.dart';
import '../../widget/name_icon_badge.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({ Key? key }) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<dynamic> notifications = [];

 readJson(){


    setState(() {
      notifications.add("1");
      notifications.add(1);
      notifications.add(1231);
      notifications.add("1323");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {



    final makeListTile = ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.zero,
        /*  decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.grey))),*/
          child:  new Stack(
            children: <Widget>[
              new Icon(Icons.notifications_rounded,size: 30,),
             /* new Positioned(
                top: 0,
                right:3 ,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 10,
                    minHeight:10,
                  ),
                  child: new Text(
                    '',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )*/
            ],
          ),

        ),



        title: Text(
          "Introduction to Driving",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[

            Text(" Intermediate", style: TextStyle(color: Colors.grey))
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0));


    final makeCard = Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child:

        new Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left:0 ,
              child: Container(
                padding: EdgeInsets.all(4),
                color:Colors.red,child: CustomTextWidget(text:"New",color: Colors.white,size: 10,),),
            ),


                 makeListTile,])
      ),
    );
    final makeBody =


    Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return makeCard;
        },
      ),
    );




    return Scaffold(
        appBar: AppBar(
          title: Text("Notification"),

        ),

        body: Column(
          children: [

            BlocBuilder<ConnectedBloc, ConnectedState>(
                builder: (context, state) {
                  if (state is ConnectedFailureState) {
                    return InternetNotAvailable();
                  }
                  else if(state is FirebaseMsgReceived)
                  {
                    return Container();
                  }
                  else
                  {
                    return Container();
                  }
                }
            ),

            Expanded(
              child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Slidable(

                      // Specify a key if the Slidable is dismissible.
                      key: const ValueKey(0),

                      // The start action pane is the one at the left or the top side.
                      endActionPane: ActionPane(
                         motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: const [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            onPressed: deleteItemClick,
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),

                        ],
                      ),

                      child: makeCard,

                    );
                  }
              ),
            ),
          ],
        )
    );
  }



}
void deleteItemClick(BuildContext context)
{}
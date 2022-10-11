import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/repository/model/response/events_list.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../custom_style/colors.dart';
import 'color_text_round_widget.dart';

class ImageSliderWidget extends StatefulWidget {
 final List<Events> event;

  ImageSliderWidget({
    this.height = 80,
    Key? key,
    this.onClick = null,
   required this.event
  }) : super(key: key);

  final VoidCallback? onClick;
  final double height;

  @override
  _ImageSliderWidget createState() => _ImageSliderWidget();
}

class _ImageSliderWidget extends State<ImageSliderWidget> {
  int _currentIndex = 0;
  List<Events> imagesList = [];
  @override
  void initState() {
    imagesList = widget.event;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //var colorText = !Get.isDarkMode ? blackThemeTextColor : color;
    return Column(
      children: [
        Container(
          height: widget.height,
          width: Get.mediaQuery.size.width,
          child: CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    _currentIndex = index;
                  },
                );
              },
            ),
            items: imagesList
                .map(
                  (item) => Container(
                      width: Get.mediaQuery.size.width,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: gradientColorArray[_currentIndex],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColorArray[_currentIndex][1]
                                .withOpacity(0.10),
                            blurRadius: 6,
                            offset: Offset(0, 6),
                            // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          item.hasImage==false
                              ? Container()
                              : Container(
                                  constraints: BoxConstraints(
                                      minWidth: 150, maxWidth: 150),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item.image.toString(),
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CustomTextWidget(
                               text: item.title ,
                                fontWeight: FontWeight.bold,
                                size: 18,
                                maxLines: 2,
                                color:Colors.white
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextWidget(
                                text:
                                item.description,
                                  fontWeight: FontWeight.bold,
                                size: 12,
                                maxLines: 2,
                                  color:Colors.white
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {

                                  showEventDescriptionDialog(context, item);
                                },
                                child: TextColorContainer(
                                    label: "Read More", color: Colors.white),
                              ),
                            ],
                          ))
                        ],
                      )),
                )
                .toList(),
          ),
        ),
        /* Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagesList.map((urlOfItem) {
            int index = imagesList.indexOf(urlOfItem);
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color.fromRGBO(0, 0, 0, 0.8)
                    : Color.fromRGBO(0, 0, 0, 0.3),
              ),
            );
          }).toList(),
        )*/
      ],
    );
  }

  showEventDescriptionDialog(BuildContext context, Events item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardThemeBaseColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),

      builder: (BuildContext context) {
        return Container(

          child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: CustomTextWidget(
                      text:item.title,
                      fontWeight: FontWeight.bold,
                      size: 18,
                    )),
                item.hasImage==false
                    ? Container()
                    : Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.network(
                              item.image.toString(),
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                Expanded(
                  child:
                  SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: CustomTextWidget(
                          text:
                           item.description     )),
                  ),
                ),
              ],
            ),

        );
      },
    );
  }
}

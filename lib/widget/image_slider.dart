import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../custom_style/colors.dart';
import 'color_text_round_widget.dart';


class ImageSliderWidget extends StatefulWidget {
  final List<String> imagesList = [
    'https://scontent.fisb6-1.fna.fbcdn.net/v/t1.6435-9/164797247_291565822329729_7202526337027002463_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=cs__k59ABbIAX8AbVAM&_nc_ht=scontent.fisb6-1.fna&oh=00_AT_-DvXzYqw45AVb7Lh2Ek5c2dN2gDX3dL3fIr13psaccA&oe=63516E10',
    'https://images.unsplash.com/photo-1584339312444-6952d098e152?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bXVzbGltJTIwZ2lybHxlbnwwfHwwfHw%3D&w=1000&q=80',
'https://pbs.twimg.com/media/DwJz644X4AYS504.jpg',
'https://c.wallhere.com/images/a5/5a/5b12ef0dd27a657915d3adeeb9b1-1920945.jpg!d'

  ];

  ImageSliderWidget({
    this.height = 100,
    Key? key,
    this.onClick = null,
  }) : super(key: key);

  final VoidCallback? onClick;
  final double height;

  @override
  _ImageSliderWidget createState() => _ImageSliderWidget();
}

class _ImageSliderWidget extends State<ImageSliderWidget> {
  int _currentIndex = 0;
  List<String> imagesList = [];

  @override
  Widget build(BuildContext context) {
    imagesList = widget.imagesList;
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
                      padding: EdgeInsets.symmetric(horizontal:2, vertical: 2),
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

                          item.isEmpty ?Container():
                         Container(
                           constraints: BoxConstraints(minWidth: 150, maxWidth: 220),

                                child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item,
                                    fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                          SizedBox(width: 10,),
                          Expanded(

                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CustomTextWidget(text: "Title of WidgetTitle of WidgetTitle",fontWeight:FontWeight.bold,size:18,maxLines: 2,),
                                SizedBox(height: 10,),
                                CustomTextWidget(text: "Title of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of WidgetTitle of Widget",
                                  fontWeight:FontWeight.bold,size:12,maxLines: item.isEmpty ?3:2,),
                                SizedBox(height: 10,),
                                InkWell(
                                  onTap: (){
                                    showEventDescriptionDialog(context,item);
                                  },
                                  child: TextColorContainer(
                                      label: "Read More",
                                      color:
                                      Colors.white),
                                ),

                              ],
                            )
                          )
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




  showEventDescriptionDialog(BuildContext context,String item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardThemeBaseColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: CustomTextWidget(
                      text: "Title of Notification",
                      fontWeight: FontWeight.bold,
                      size: 18,
                    )),
                item.isEmpty ?Container():
                Expanded(
                  child: Image.network(
                    item,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),

                ),

              ],
            ),
          ),
        );
      },
    );
  }









}
import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../custom_style/colors.dart';



class HorizontalItemList extends StatefulWidget {
  final List<String>? itemList;
   HorizontalItemList({
    Key? key,
     @required this.itemList,
     required this.onChanged
  }) : super(key: key);

  final ValueChanged<int> onChanged;


  @override
  _HorizontalItemListState createState() => _HorizontalItemListState();
}

class _HorizontalItemListState extends State<HorizontalItemList> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.itemList!.length,
                  (i) {
                return
                  GestureDetector(
                    onTap: () => setState(
                          () {
                        _currentIndex = i;
                        widget.onChanged(_currentIndex);
                      },
                    ),
                    child:
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 6,
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: i == _currentIndex ? Colors.black : Colors.black12,
                        ),
                        child: CustomTextWidget(text:widget.itemList![i],color: i == _currentIndex ? Colors.white : Colors.black,),
                      ),

                  );

              },
            ),
        ),
          )

    );
  }
}
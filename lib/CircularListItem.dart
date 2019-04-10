import 'package:emsakia/Models/CircularItem.dart';
import 'package:flutter/material.dart';

class CircleListItem extends StatelessWidget {
  final double resizeFactor;
  final CircularItem item;

  const CircleListItem({Key key, this.resizeFactor, this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            item.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22 * resizeFactor,
            ),
          ),
        ),
        Container(
          width: 120 * resizeFactor,
          height: 120 * resizeFactor,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Colors.green,
          ),
          child: Align(
            child: Container(
//              child: Image.asset(
//                item.img,
//                fit: BoxFit.contain,
//              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.green,
                image: DecorationImage(
                  image: AssetImage(
                    item.img,
//                    fit: BoxFit.contain,
                  ),
                  fit: BoxFit.fill
                ),
              ),
              height: 110 * resizeFactor,
              width: 110 * resizeFactor,
            ),
          ),
        ),
      ]),
    );
  }
}

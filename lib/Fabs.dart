

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
//size of floating button
const double buttonSize=80;
class CircularFabWidget extends StatefulWidget {
  const CircularFabWidget({Key? key}) : super(key: key);

  @override
  State<CircularFabWidget> createState() => _CircularFabWidgetState();
}

class _CircularFabWidgetState extends State<CircularFabWidget>
    with
SingleTickerProviderStateMixin{
late AnimationController controller;


@override
  // ignore: must_call_super
  void initState() {
//
super.initState();

controller=AnimationController(
  duration: const Duration(milliseconds: 250),
  vsync: this,
);
  }

  @override
  void dispose() {
controller.dispose();
super.dispose();
  }



  @override
  Widget build(BuildContext context) => Flow(
    //implement the flowMenuDelegate() in a new class
    delegate: FlowMenuDelegate(controller:controller),//make use of animation class
      children:<IconData> [
         Icons.mail,//0
        Icons.call,//1
        Icons.notifications,//2
        Icons.sms,//3
        Icons.menu,//4
                //map (call,sms etc) to the new method called buildFAB
      ].map<Widget>(buildFAB).toList(),
    );


  Widget buildFAB(IconData icon) =>SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: FloatingActionButton(
        elevation: 0,
        splashColor: Colors.white,
        child: Icon(icon,color: Colors.white,size: 45),
        //to open and close the animations
        onPressed: (){
          if(controller.status==AnimationStatus.completed){
            controller.reverse();
          }else
            {
              controller.forward();
            }
        },
    ),
  );


}

//the FlowMenu Delegate class is created
class FlowMenuDelegate extends FlowDelegate{

  // create an object or the animation controller
  final Animation<double> controller;
//create a constructor for the controller
 const FlowMenuDelegate({required this.controller})
     :super(repaint: controller);



  @override
  void paintChildren(FlowPaintingContext context) {
    //move the floating button to the bottom
    final size = context.size;//size of screen
    final xStart = size.width-buttonSize;// determine the new x
    final yStart = size.height-buttonSize;// determine the new y

    // TODO: implement paintChildren
    //create a for loop for the floating button
    final n = context.childCount;
    for (int i = 0; i < n; i++) {


      //6 floating button should go the orign postion
      //use the setValue
final isLastItem=i==context.childCount-1;
final setValue=(value)=>isLastItem ? 0.0: value;// determine if item is the last item

//position the floatingbutton using the formal
      final radius=180 * controller.value;//multiple the radius with the controller[the value is bw 0 & 1]

      final theta= i * pi * 0.5 / (n-2);

      final x =xStart - setValue(radius * cos(theta));//subtract from here
      final y =yStart - setValue(radius * sin(theta));
      context.paintChild(i,
        transform: Matrix4.identity()
          ..translate(x, y, 0)
      //to rotate our widget
        ..translate(buttonSize / 2, buttonSize /2)
          ..rotateZ(isLastItem ? 0.0 :180 *(1 - controller.value) * pi /180)//rotation angle
         ..scale(max(isLastItem ? 1.0 :controller.value, 0.5))//rotation angle
        ..translate(-buttonSize / 2, -buttonSize / 2),
      );
    }
  }
  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

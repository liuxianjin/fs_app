import 'package:flutter/material.dart';
import '../../config/size_fit.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{

  final String title;
  final double boxShadow;
  Color fontColor = Colors.white;
  Color bgColor = Color.fromRGBO(31,112,250,1);
  Widget rightContent = Container();
  bool leftIsExistence;

  MyAppBar(this.title, {this.bgColor, this.boxShadow, this.fontColor, this.rightContent, this.leftIsExistence});

  @override
  Widget build(BuildContext context) {
    SizeFit.initialize();
    return  PreferredSize(
          child: AppBar(
            title:Text(
              this.title,
              style: TextStyle(
                fontSize: 18.rpx,
                color: this.fontColor
              ),
            ),
            leading: this.leftIsExistence!=null?IconButton(//左侧按钮
              icon: Icon(Icons.arrow_back_ios,color: this.fontColor,size: 20.rpx,),
              onPressed: (){
                Navigator.of(context).pop();//返回
              },
            ):Text(''),
            iconTheme: IconThemeData(
              color: this.fontColor, //设置appBar的icon颜色
            ),
            centerTitle: true,//标题居中显示
            backgroundColor:this.bgColor,
            elevation: this.boxShadow,//阴影是否显示

            actions: <Widget>[
              this.rightContent != null?this.rightContent:Container()
            ],
          ),
          preferredSize: Size.fromHeight(50.rpx)
        );
  }

  @override
  Size get preferredSize => getSize();


  Size getSize() {
    return new Size(0,50);
  }
}
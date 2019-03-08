import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+'),),
      body:FutureBuilder(
        future:getHomePageContent(),
        builder: (context,snapshot){
          if(snapshot.hasData){
             var data=json.decode(snapshot.data.toString());
             List<Map> swiperDataList = (data['data']['slides'] as List).cast(); // 顶部轮播组件数
             List<Map> navigatorList = (data['data']['category'] as List).cast(); // 类别列表
             if(navigatorList.length>10){
                navigatorList.removeRange(10, navigatorList.length);
              }
              String adPic = data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
              String leaderImage = data['data']['shopInfo']['leaderImage']; //店长图片
              String leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长图片

            //  TopNavigator(navigatorList: navigatorList);
             return Column(
               children: <Widget>[
                   SwiperDiy(swiperDataList:swiperDataList ),   //页面顶部轮播组件
                   TopNavigator(navigatorList: navigatorList), //导航组件
                   AdBanner(adPic: adPic), //广告图片
                   LeaderPhone(leaderImage:leaderImage,leaderPhone:leaderPhone), //店长电话
               ],
             );
          }else{
            return Center(
              child: Text('加载中'),
            );
          }
        },
      )
    );
  }
}
// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key,this.swiperDataList}):super(key:key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context); //定义一个iphone6的宽高像素数
    return Container(
      height: ScreenUtil().setHeight(333), //定义其元素在ip6上的宽高 其他设备会等比缩放
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
// 首页导航区域 单元素
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key,this.navigatorList}) :super(key:key);
  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: (){print('戳了导航一下');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children:navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告图片
class AdBanner extends StatelessWidget {
  final String adPic;
  AdBanner({Key key,this.adPic}) :super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPic),
    );
  }
}

// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话
  LeaderPhone({Key key,this.leaderImage,this.leaderPhone}) :super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }  

  void _launchURL() async{
    String url = 'tel:'+leaderPhone;
    if(await canLaunch(url)) { //判断url是否是合法的 电话号码/网址/邮件地址
      await launch(url); //启动相关默认程打开这个 电话号码/网址/邮件地址
    } else {
      throw 'Could not launch $url';
    }
  }
}




import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/widgets/date_time.dart';
import 'package:url_launcher/url_launcher.dart';

class detail_news extends StatefulWidget {
  final news_model data;
  final int index;
  const detail_news({super.key,required this.data,required this.index});

  @override
  State<detail_news> createState() => _detail_newsState();
}

class _detail_newsState extends State<detail_news> {
  @override
  Widget build(BuildContext context) {
    news_model data = widget.data;
    int index = widget.index;
    return SafeArea(
      child: Scaffold(
        body: OrientationBuilder(
          builder: (BuildContext context,orientaion) {
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool issrcolled) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    title: Text(data.articles![index].source!.name.toString(),
                      style: TextStyle(fontWeight: FontWeight.w600),),
                    centerTitle: true,
                    actions: [
                      Container(
                        margin: orientaion == Orientation.landscape ? EdgeInsets.only(right: MediaQuery.of(context).size.width*0.2): null,
                        child: IconButton(onPressed: ()async{
                          String url = data.articles![index].url.toString();
                          if(!await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication)){
                            throw Exception("not open");
                          }
                        }, icon: Icon(Icons.shortcut,semanticLabel: "go to",)),
                      )
                    ],
                  ),
                ];
              }, body: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin:orientaion == Orientation.portrait ? null : EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height:orientaion == Orientation.landscape? MediaQuery.of(context).size.height*0.4 : MediaQuery
                        .of(context)
                        .size
                        .height * 0.4,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: data.articles![index].urlToImage == null
                                ? null
                                : Image.network(data.articles![index].urlToImage
                                .toString(), fit: BoxFit.fill,)),
                        BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 8),
                            blendMode: BlendMode.src,
                            child: Container(
                                width: double.maxFinite, height: double.maxFinite)
                        ),
                        Center(
                            child: data.articles![index].urlToImage == null ? Icon(
                              Icons.person,) : Image.network(data.articles![index]
                                .urlToImage.toString(), fit: BoxFit.contain,)),
                      ],
                    ),
                  ),
                  Text(data.articles![index].title.toString(), style: TextStyle(
                      fontSize: orientaion == Orientation.portrait ? 25.sp : 8.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.1),),
                  Text(data.articles![index].description.toString(), style: TextStyle(
                      fontSize: orientaion == Orientation.portrait ? 18.sp : 5.sp,
                      height: 1),),
                  Container(
                    alignment: Alignment.bottomRight,
                    width: MediaQuery.of(context).size.width,
                    child:Text(
                      "~Author ${data.articles![index].author.toString()}",style: TextStyle(fontSize:orientaion == Orientation.portrait ?  12.sp : 3.sp,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    width: MediaQuery.of(context).size.width,
                    child:Text(date_formatter(data.articles![index].publishedAt.toString()),style: TextStyle(fontSize:orientaion == Orientation.portrait ?  12.sp : 3.sp,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                  )
                ],
                          ),
              ),
            );
          }
        ),
      ),
    );
  }
}

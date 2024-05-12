import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Screens/breaking%20news.dart';
import 'package:news_app/Screens/detail_news.dart';
import 'package:news_app/bloc/news_bloc.dart';
import 'package:news_app/bloc/news_event.dart';
import 'package:news_app/bloc/news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/date_time.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late var date;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NewsBloc>().add(data());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context,oriention){
            return NestedScrollView(
                headerSliverBuilder: (BuildContext context,bool isScrolled){
                  return [
                    SliverAppBar(
                      centerTitle: true,
                      elevation: 0,
                      leading: oriention == Orientation.portrait ? Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width*0.05,
                            child: Image.asset("assets/download.png"),
                          ),
                        ),
                      ) : null,
                      title: Container(
                        margin:oriention == Orientation.portrait ? null : EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2),
                        child: oriention == Orientation.landscape ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Image.asset("assets/download.png"),
                            ),
                            Text("Breaking News",style: TextStyle(fontWeight: FontWeight.bold),),
                            FittedBox()
                          ],
                        ) : Text("Breaking News",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      actions: [
                        Container(
                          margin: oriention == Orientation.portrait ? null : EdgeInsets.only(right: MediaQuery.of(context).size.width*0.2),
                            child: IconButton(onPressed: (){}, icon: const Icon(Icons.search,weight:10,)))
                      ],
                      floating: true,
                      snap: true,
                    ),
                  ];
                },
                body:BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if(state is Newserror){
                      return Center(child: Text(state.error),);
                    }
                    else if(state is Newsloading){
                      return Center(child: CircularProgressIndicator.adaptive(),);
                    }
                    else if(state is Newsloaded){
                      return Container(
                        margin:oriention == Orientation.portrait ? null : EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(state.data.articles!.length, (index) {
                              date = state.data.articles![index].publishedAt;
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>detail_news(data: state.data,index: index,)));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical:3,horizontal: 5),
                                  clipBehavior: Clip.antiAlias,
                                  height:oriention == Orientation.portrait ? MediaQuery.of(context).size.height*0.2 : MediaQuery.of(context).size.height*0.25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.grey.withOpacity(0.3)
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(2),
                                        width:oriention == Orientation.portrait ? MediaQuery.of(context).size.width*0.3 : MediaQuery.of(context).size.width*0.3/2,
                                        height:double.infinity,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          // color: Colors.grey.withOpacity(0.5),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(width:double.infinity,height: double.infinity,child:state.data.articles![index].urlToImage == null ?  null : Image.network(state.data.articles![index].urlToImage.toString(),fit: BoxFit.fill,)),
                                            BackdropFilter(filter: ImageFilter.blur(sigmaY: 5,sigmaX: 8),blendMode: BlendMode.src,child: Container(width: double.maxFinite,height: double.maxFinite)
                                                ),
                                            Center(child:state.data.articles![index].urlToImage == null ?  Icon(Icons.person,) :  Image.network(state.data.articles![index].urlToImage.toString(),fit: BoxFit.contain,)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(state.data.articles![index].title.toString(),style: TextStyle(fontSize:oriention == Orientation.portrait ?  18.sp : 8.sp,fontWeight: FontWeight.bold,height:1),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                              Expanded(
                                                  child: Container(margin: EdgeInsets.only(top: 5),child: Text(state.data.articles![index].description.toString(),style: TextStyle(fontSize:oriention == Orientation.portrait ?  14.sp : 4.sp,height: 1)))),
                                              Container(
                                                width: double.infinity,
                                                alignment: Alignment.bottomRight,
                                                margin: EdgeInsets.only(top:3),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        child: Text("~ author ${state.data.articles![index].author}",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:oriention == Orientation.portrait ?  12.sp : 3.sp,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic))
                                                    ),
                                                    Text(date_formatter(state.data.articles![index].publishedAt.toString()),style: TextStyle(fontSize:oriention == Orientation.portrait ?  12.sp : 3.sp)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                )
            );
          },
        ),
      ),
    );
  }
}

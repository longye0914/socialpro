
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/utils/colors.dart';
import 'package:tnsocialpro/widget/card_mylikeuser.dart';
import 'package:tnsocialpro/widget/load_state_layout.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/utils/global.dart';

/**
 * 我喜欢  看过我
 */
String tkV, userpicVal;
int userId, indexVal, genderVal;
class MylikelookPage extends StatefulWidget {
  String tk, userpicVa;
  int user_id, indexV, genderVa;
  MylikelookPage(this.tk, this.user_id, this.indexV, this.genderVa, this.userpicVa) {
    tkV = this.tk;
    // idV = this.idV;
    userId = this.user_id;
    indexVal = this.indexV;
    genderVal = this.genderVa;
    userpicVal = this.userpicVa;
    // mheadimgVal = this.mheadimgV;
  }

  @override
  _MylikelookPageState createState() => _MylikelookPageState();
}

class _MylikelookPageState extends State<MylikelookPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Tab> myTabs = <Tab>[];
  List<FindingTabView> bodys = [];
  TabController mController;
  LoadState _layoutState = LoadState.State_Loading;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
        child: Scaffold(
            // appBar: customAppbar(context: context, borderBottom: false, title: '康复指南'),
            backgroundColor: rgba(255, 255, 255, 1),
            body: LoadStateLayout(
              state: _layoutState,
              errorRetry: () {
                setState(() {
                  _layoutState = LoadState.State_Loading;
                });
                loadCateGoryData();
              },
              successWidget: Container(
                color: rgba(255, 255, 255, 1),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(bottom: 15.5, top: 40),
                      child: Row(children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/icon_back.png',
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBar(
                            isScrollable: true,
                            controller: mController,
                            labelColor: rgba(69, 65, 103, 1),
                            indicatorColor: rgba(209, 99, 242, 1),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 4.0,
                            unselectedLabelColor: rgba(150, 148, 166, 1),
                            unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: rgba(150, 148, 166, 1)),
                            labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: rgba(69, 65, 103, 1)),
                            tabs: myTabs,
                          ),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: mController,
                        children: bodys,
                      ),
                    )
                  ],
                ),
              ),
            )
        ));
  }

  @override
  void initState() {
    super.initState();
    loadCateGoryData();
  }
  /**
   * 加载大类列表和标签
   */
  void loadCateGoryData() async {
    List<CategoryModel> dataList = [];
    CategoryModel data1 = new CategoryModel();
    data1.id = 1;
    data1.name = "看过我";
    dataList.add(data1);
    CategoryModel data4 = new CategoryModel();
    data4.id = 2;
    data4.name = "我喜欢";
    dataList.add(data4);
    if (dataList != null) {
      List<Tab> myTabsTmp = <Tab>[];
      List<FindingTabView> bodysTmp = [];
      for (int i = 0; i < dataList.length; i++) {
        CategoryModel model = dataList[i];
        myTabsTmp.add(Tab(text: model.name));
        bodysTmp.add(FindingTabView(i, model.id));
      }
      myTabs.addAll(myTabsTmp);
      bodys.addAll(bodysTmp);
      mController = TabController(
        initialIndex: indexVal,
        length: myTabs.length,
        vsync: this,
      );
      if (dataList.length > 0) {
        _layoutState = LoadState.State_Success;
      } else {
        _layoutState = LoadState.State_Empty;
      }
    }else{
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(null!=mController) {
      mController.dispose();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryModel{

  String name;
  int id;
  CategoryModel({this.name,this.id});
  factory CategoryModel.fromJson(Map<String, dynamic> parsedJson){
    return CategoryModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}

/**
 * 类别子页面
 */
class FindingTabView extends StatefulWidget {
  final int currentPage;
  final int id;
  FindingTabView(this.currentPage,this.id);

  @override
  _FindingTabViewState createState() => _FindingTabViewState();
}

class _FindingTabViewState extends State<FindingTabView> with AutomaticKeepAliveClientMixin{
  GlobalKey _headerKey = GlobalKey();
  GlobalKey _footerKey = GlobalKey();
  LoadState _layoutState = LoadState.State_Loading;
  final List<MyUserData> visitUser = [];
  final List<MyUserData> fansUser = [];
  bool _isLoading = false;
  MyInfoData myInfoData;

  @override
  void initState() {
    _isLoading = true;
    getUserInfo();
    Future.delayed(Duration.zero, () async {
      if(tkV == null) {
        Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new LoginIndex())
        );
      } else {
        loadData(this.widget.id);
      }
    });
    super.initState();
  }

  /// 获取列表
  void loadData(int id) async{
    if (1 == id) {
      // 看过我
      try {
        var res = await G.req.shop.getVisitUserReq(
          tk: tkV,
          follow_id: userId,
        );
        setState(() {
          if (res.data != null) {
            if(mounted) {
              visitUser.clear();
              visitUser.addAll(UserlistParent.fromJson(res.data).data);
              _isLoading = false;
              if (visitUser.length > 0) {
                _layoutState = LoadState.State_Success;
              } else {
                _layoutState = LoadState.State_Empty;
              }
            } else {
              _layoutState = LoadState.State_Error;
            }
          } else {
            _layoutState = LoadState.State_Empty;
          }
        });
      } catch(e) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      }
    } else {
      // 我喜欢的
      try {
        var res = await G.req.shop.getMyLikelistReq(
            tk: tkV,
            user_id: userId
        );
        setState(() {
          if (res.data != null) {
            if(mounted) {
              fansUser.clear();
              fansUser.addAll(UserlistParent.fromJson(res.data).data);
              _isLoading = false;
              if (fansUser.length > 0) {
                _layoutState = LoadState.State_Success;
              } else {
                _layoutState = LoadState.State_Empty;
              }
            } else {
              _layoutState = LoadState.State_Error;
            }
          } else {
            _layoutState = LoadState.State_Empty;
          }
        });
      } catch(e) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      }
    }
  }

  /// 获取个人信息
  getUserInfo() async {
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: tkV,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            myInfoData = MyInfoParent.fromJson(res.data).data;
          });
        }
      }
    } catch (e) {}
  }


  Widget _getContent(){
    if(_isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      return Container(
        child: EasyRefresh(
            header: MaterialHeader(
              key: _headerKey,
            ),
            footer: MaterialFooter(
              key: _footerKey,
            ),
            child:ListView(
              children: <Widget>[
                CardMylikeUser(articleData: (1 == widget.id) ? visitUser : fansUser, tk: tkV, gender: genderVal, headimg: userpicVal, myInfo: myInfoData,)
              ],
            ),
            onRefresh: () async {
              _isLoading = true;
              loadData(widget.id);
            },
            onLoad: () async {}
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return
      LoadStateLayout(
          state: _layoutState,
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            loadData(widget.id);
          }, //错误按钮点击过后进行重新加载
          successWidget:_getContent()
      );

  }
  @override
  bool get wantKeepAlive => true;
}
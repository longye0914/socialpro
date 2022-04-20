import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/incomeitemlist/data.dart';
import 'package:tnsocialpro/data/paylist/data.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:tnsocialpro/widget/card_consumelist.dart';
import 'package:tnsocialpro/widget/card_payoutlist.dart';
import 'package:tnsocialpro/widget/load_state_layout.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';

/**
 * 男 交易明细
 */
final List<Paylist> withdrawLists = new List<Paylist>();
final List<Incomeitemlist> incomeitemLists = new List<Incomeitemlist>();
String tkV;
class ChargeDetailPage extends StatefulWidget {
  String tk;
  ChargeDetailPage(this.tk) {
    tkV = this.tk;
  }

  @override
  _ChargeDetailPageState createState() => _ChargeDetailPageState();
}

class _ChargeDetailPageState extends State<ChargeDetailPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Tab> myTabs = <Tab>[];
  List<FindingTabView> bodys = [];
  TabController mController;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: customAppbar(
                context: context, borderBottom: false, title: '交易明细'),
            body: Container(
              // color: rgba(184, 115, 236, 1),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                    margin: EdgeInsets.only(top: 0),
                    // color: rgba(184, 115, 236, 1),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: TabBar(
                          isScrollable: false,
                          controller: mController,
                          labelColor: rgba(69, 65, 103, 1),
                          indicatorColor: rgba(255, 255, 255, 1),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 0.1,
                          unselectedLabelColor:rgba(150, 148, 166, 1),
                          unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: rgba(150, 148, 166, 1)),
                          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: rgba(69, 65, 103, 1)),
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
                  ),
                ],
              ),
            ),
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
    data1.name = "支出明细";
    dataList.add(data1);
    CategoryModel data2 = new CategoryModel();
    data2.id = 2;
    data2.name = "充值明细";
    dataList.add(data2);
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
        length: myTabs.length,
        vsync: this,
      );
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
  int userId;
  bool _isLoading = false;
  SharedPreferences _prefs;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      userId = _prefs.getInt('account_id');
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

  /// 获取居家康复列表
  void loadData(int id) async{
    if (1 == id) {
      //  支出明细
      try {
        var res = await G.req.shop.getPayoutItemlist(
            tk: tkV,
            user_id: userId
        );
        setState(() {
          if (res.data != null) {
            _isLoading = false;
            incomeitemLists.clear();
            incomeitemLists.addAll(IncomeitemlistParent.fromJson(res.data).data);
            if (incomeitemLists.isEmpty) {
              _layoutState = LoadState.State_Empty;
            } else {
              _layoutState = LoadState.State_Success;
            }
          } else {
            setState(() {
              _layoutState = LoadState.State_Empty;
            });
          }
        });
      } catch(e) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      }
    } else {
      // 充值明细
      try {
        var res = await G.req.shop.getRechargeDetail(
            tk: tkV,
            userid: userId
        );
        setState(() {
          if (res.data != null) {
            _isLoading = false;
            withdrawLists.clear();
            withdrawLists.addAll(PaylistParent.fromJson(res.data).data);
            if (withdrawLists.isEmpty) {
              _layoutState = LoadState.State_Empty;
            } else {
              _layoutState = LoadState.State_Success;
            }
          } else {
            setState(() {
              _layoutState = LoadState.State_Empty;
            });
          }
        });
      } catch(e) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      }
    }
  }


  Widget _getContent(id){
    if(_isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      return Container(
        color: rgba(255, 255, 255, 1),
        child: EasyRefresh(
            header: MaterialHeader(
              key: _headerKey,
            ),
            footer: MaterialFooter(
              key: _footerKey,
            ),
            child:ListView(
              children: <Widget>[
                (1 == id) ? CardConsumelist(articleData: incomeitemLists, tk: tkV) : CardPayoutlist(articleData: withdrawLists, tk: tkV)
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
    return LoadStateLayout(
        state: _layoutState,
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          loadData(widget.id);
        }, //错误按钮点击过后进行重新加载
        successWidget:_getContent(widget.id)
    );

  }
  @override
  bool get wantKeepAlive => true;
}

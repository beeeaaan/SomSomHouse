import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:somsomhouse/models/apartname_list_model.dart';
import 'package:somsomhouse/models/dongname_model.dart';
import 'package:somsomhouse/services/dbservices.dart';
import 'package:somsomhouse/views/dorimdong_prediction.dart';
import 'package:somsomhouse/views/garakdong_prediction.dart';
import 'package:somsomhouse/views/gwangjangdong_prediction.dart';
import 'package:somsomhouse/views/ohgeumdong_prediction.dart';
import 'package:somsomhouse/views/pungnabdong_prediction.dart';
import 'package:somsomhouse/views/siheungdong_prediction.dart';
import 'package:somsomhouse/views/sinchundong_prediction.dart';
import 'package:somsomhouse/views/sinjungdong_prediction.dart';

class Songpa extends StatefulWidget {
  const Songpa({super.key});

  @override
  State<Songpa> createState() => _SongpaState();
}

class _SongpaState extends State<Songpa> {
  late List<Widget> widgetList;
  late List<String> nameList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widgetList = [];
    nameList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 121, 119, 166),
        title: const Text('송파구 지도'),
      ),
      body: Center(
        child: InkWell(
          splashColor: Colors.orange,
          onTapDown: (TapDownDetails details) {
            _handleTapDown(
                context, details.localPosition.dx, details.localPosition.dy);
          },
          child: Image.asset(
            'images/송파구.png',
            width: 400,
            height: 300,
          ),
        ),
      ),
    );
  }

  //-----function-------
  _handleTapDown(BuildContext context, var dx, var dy) async {
    if ((dx > 187 && dx < 211 && dy > 62 && dy < 98) ||
        (dx > 172 && dx < 208 && dy > 80 && dy < 101)) {
      DongModel.dongName = '풍납동';
    } else if ((dx > 161 && dx < 197 && dy > 110 && dy < 132) ||
        (dx > 151 && dx < 167 && dy > 99 && dy < 129)) {
      DongModel.dongName = '신천동';
    } else if ((dx > 236 && dx < 251 && dy > 143 && dy < 161) ||
        (dx > 219 && dx < 237 && dy > 140 && dy < 158)) {
      DongModel.dongName = '오금동';
    } else if ((dx > 166 && dx < 195 && dy > 167 && dy < 182) ||
        (dx > 198 && dx < 224 && dy > 160 && dy < 179) ||
        (dx > 208 && dx < 236 && dy > 170 && dy < 179)) {
      DongModel.dongName = '가락동';
    }
    widgetList = await selectApartName();
    showPicker(widgetList);
  }

  /// 아래쪽 스낵바에 선택한 동의 아파트 이름을 가져오기 위해서 DB 서비스와 연결하는 함수
  /// 만든 날짜 : 2023.1.10
  /// 만든이 : 노현석
  Future<List<Widget>> selectApartName() async {
    DBServices dbServices = DBServices();
    ApartNameListModel apartNameListModel =
        await dbServices.callapartName(DongModel.dongName, DongModel.guName);

    List<Widget> widgetList = [];

    for (var apartNameModel in apartNameListModel.apartNameListModel) {
      widgetList.add(Text(apartNameModel.apartName));
      nameList.add(apartNameModel.apartName);
    }

    return widgetList;
  }

  //모달팝업창을 뜨게 하고 버튼을 누르면 다음 페이지로 이동한다.
  showPicker(List<Widget> widgetList) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
              height: 300,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 50,
                      scrollController: FixedExtentScrollController(
                        initialItem: 1,
                      ),
                      children: widgetList,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          DongModel.apartNamePredict = nameList[value];
                          //CupertinoPicker에서 선택한 아파트 이름을 static에 저장해준다.
                        });
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      goDongPage();
                    },
                  ),
                ],
              ),
            ));
  }

  //선택된 아파트에 해당되는 동으로 각각 다른 예측페이지로 이동하게 함
  //만든날짜 : 2023.01.12
  //만든이 : 노현석
  goDongPage() {
    if (DongModel.dongName == '도림동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DorimdongPrediction(),
          ));
    } else if (DongModel.dongName == '가락동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GarakdongPrediction(),
          ));
    } else if (DongModel.dongName == '광장동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GwangjangdongPrediction(),
          ));
    } else if (DongModel.dongName == '오금동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OgmdongPrediction(),
          ));
    } else if (DongModel.dongName == '풍납동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PunabdongPrediction(),
          ));
    } else if (DongModel.dongName == '시흥동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SiheungdongPrediction(),
          ));
    } else if (DongModel.dongName == '신천동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SinchundongPrediction(),
          ));
    } else if (DongModel.dongName == '신정동') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SinjungdongPrediction(),
          ));
    }
  }
}//end

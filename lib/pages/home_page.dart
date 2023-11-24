import 'package:flutter/material.dart';
import '../data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// LocationBarに表示する文字リスト
  List<String> _locations = ['Poulare', 'Japan', 'Moscow', 'London'];

  /// 現在選択中のLocationBarのインデックス値
  int _currentLocation = 1;

  @override
  Widget build(BuildContext context) {
    /// MEMO: SafeAreaの左右方向の間隔調整用
    double insetsLeftRight = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      body: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: true,
        minimum:
            EdgeInsets.fromLTRB(insetsLeftRight, 0.0, insetsLeftRight, 0.0),
        child: _mainColumnContents(context),
      ),
    );
  }

  /// メイン画面表示部分のWidget
  Widget _mainColumnContents(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Header
        _headerContentsWidget(),

        /// LocationBar
        _locationBarContentsWidget(context),

        /// ArticleListContents
        _articleListContentsWidget(context),
      ],
    );
  }

  /// ヘッダー表示部分のWidget
  Widget _headerContentsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Menuボタン表示
        Icon(
          Icons.menu,
          color: Colors.black87,
          size: 35.0,
        ),

        /// アプリロゴ表示
        Container(
          height: 39.0,
          width: 144.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/logo_discover.png'),
            ),
          ),
        ),

        /// 検索ボタン表示
        Icon(
          Icons.search,
          color: Colors.black87,
          size: 35.0,
        ),
      ],
    );
  }

  /// ロケーションバー表示部分のWidget
  Widget _locationBarContentsWidget(BuildContext context) {
    /// MEMO: 配置要素における上下方向の間隔調整用
    double insetsTopBottom = MediaQuery.of(context).size.height * 0.03;

    /// MEMO: ロケーションバー表示要素高さ調整用
    double containerHeight = MediaQuery.of(context).size.height * 0.065;

    /// MEMO: 間隔調整用にPaddingを利用する
    return Padding(
      padding: EdgeInsets.only(
        top: insetsTopBottom,
        bottom: insetsTopBottom,
      ),
      child: Container(
        height: containerHeight,
        decoration: BoxDecoration(
          color: Color.fromRGBO(69, 69, 69, 1),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,

          /// MEMO: _locationsの個数分だけ要素を横方向に配置して表示する
          children: _locations.map((location) {
            /// 現在選択中の位置の文言と合致しているかを判定する
            bool _isActive =
                (_locations[_currentLocation] == location) ? true : false;

            /// MEMO: 下線表示のためにColumnを利用sいて表示する
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// 現在選択中の場合は原色のWhiteにしてそれ以外は薄くする
                Text(
                  location,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: _isActive ? Colors.white : Colors.white54,
                      fontFamily: 'Montserrat'),
                ),

                /// 現在選択中の場合は下線部分を表示する
                _isActive
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Colors.redAccent,
                        ),
                        height: 6.0,
                        width: 30.0,
                      )
                    : Container(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 記事一覧表示部分のWidget
  Widget _articleListContentsWidget(BuildContext context) {

    /// articleモデルデータをListViewで一覧表示をする
    return Expanded(
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              /// ArticleInformation
              _articleInformationContainerContentsWidget(context, index),
              /// SocialInformation
              _socialInformationContainerContentsWidget(context, index),
            ],
          );
        },
      ),
    );
  }

  /// ListViewの表示内容でサムネイル画像に重ねて表示する情報部分のWidget(1)
  Widget _articleInformationContainerContentsWidget(BuildContext context, int index) {

    /// MEMO: 配置要素における上方向の間隔調整用
    double insetsBottom = MediaQuery.of(context).size.height * 0.05;

    /// MEMO: Container表示要素高さ調整用
    double containerHeight = MediaQuery.of(context).size.height * 0.3;

    return Padding(
      padding: EdgeInsets.only(bottom: insetsBottom),
      /// ClipRRectで角丸を付与する
      /// MEMO: ClipRRect → Container → _articleInformationColumnContentsWidget(BuildContext context) の順番
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          height: containerHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(articles[index].image),
            ),
            /// 表示部分に対するシャドウを付与する
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 2.0,
                blurRadius: 20.0,
                offset: Offset(0.0, 6.0),
              ),
            ],
          ),
          /// Containerの子要素として情報を表示する
          child:
          _articleInformationColumnContentsWidget(context, index),
        ),
      ),
    );
  }

  /// ListViewの表示内容でサムネイル画像に重ねて表示する情報部分のWidget(2)
  Widget _articleInformationColumnContentsWidget(
      BuildContext context, int index) {

    /// MEMO: 配置要素における上方向の間隔調整用
    double insetsTop = MediaQuery.of(context).size.height * 0.05;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        /// AuthorInformation
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 30.0, 0.0),
          child: _authorInformationRowContentsWidget(context, index),
        ),

        /// DetailInformation
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, insetsTop, 30.0, 0.0),
          child: _detailInformationRowContentsWidget(context, index),
        ),
      ],
    );
  }

  /// ListViewの表示内容でサムネイル画像に重ねて表示する情報部分のWidget(3)
  Widget _authorInformationRowContentsWidget(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            /// アバター画像表示部分
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/300'),
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
            ),

            /// 名前＆時間表示部分
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// テキスト表示1列目
                  Text(
                    articles[index].author,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// テキスト表示2列目
                  Text(
                    '3 Hours Ago',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// お気に入り＆ブックマークアイコン表示部分
        Column(
          children: <Widget>[
            /// アイコン表示1列目
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20.0,
              ),
            ),

            /// アイコン表示2列目
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ListViewの表示内容でサムネイル画像に重ねて表示する情報部分のWidget(4)
  Widget _detailInformationRowContentsWidget(BuildContext context, int index) {

    /// MEMO: Container表示要素幅調整用
    double containerWidth = MediaQuery.of(context).size.width * 0.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// 再生ボタン表示部分
        FloatingActionButton(
          onPressed: () {
            print("ListView Tapped !!!");
          },
          backgroundColor: Colors.white,
          child: Icon(
            Icons.play_arrow,
            color: Colors.redAccent,
            size: 30.0,
          ),
        ),

        /// タイトル＆場所テキスト表示部分
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /// 文言表示1列目
              Container(
                width: containerWidth,
                child: Text(
                  articles[index].title,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// 文言表示2列目
              Padding(
                padding: EdgeInsets.only(
                  top: 3.0,
                  bottom: 3.0,
                ),
                child: Text(
                  articles[index].location,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              /// 星形レーティング表示3列目
              Row(
                children: List<Widget>.generate(5, (currentIndex) {
                  double fillAmount = articles[index].rating - currentIndex;
                  Icon starIcon;
                  if (fillAmount >= 1) {
                    starIcon = Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                      size: 15.0,
                    );
                  } else if (fillAmount >= 0.5) {
                    starIcon = Icon(
                      Icons.star_half,
                      color: Colors.amberAccent,
                      size: 15.0,
                    );
                  } else {
                    starIcon = Icon(
                      Icons.star_border,
                      color: Colors.amberAccent,
                      size: 15.0,
                    );
                  }
                  return starIcon;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ListViewの表示内容でサムネイル画像に重ねて表示する情報部分のWidget(5)
  Widget _socialInformationContainerContentsWidget(
      BuildContext context, int index) {

    /// MEMO: Container表示要素高さ調整用
    double positionedLeft = MediaQuery.of(context).size.width * 0.1;

    /// MEMO: Container表示要素高さ調整用
    double containerHeight = MediaQuery.of(context).size.height * 0.08;

    /// MEMO: Container表示要素幅調整用
    double containerWidth = MediaQuery.of(context).size.width * 0.7;

    return Positioned(
      bottom: 30.0,
      left: positionedLeft,
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// ソーシャル表示1行目
            Row(
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                Text(
                  articles[index].likes.toString(),
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            /// ソーシャル表示2行目
            Row(
              children: <Widget>[
                Icon(
                  Icons.mode_comment,
                  color: Colors.grey,
                ),
                Text(
                  articles[index].comments.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            /// ソーシャル表示3行目
            Row(
              children: <Widget>[
                Icon(
                  Icons.share,
                  color: Colors.grey,
                ),
                Text(
                  articles[index].shares.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ichimai/src/shared/loading.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String state = 'searching';

  void refresh() {
    setState(() {
      state = 'refresh';
    });
  }

  Future<void> search() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: refresh,
        ),
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Column(children: [
          Container(
            child: Text(state),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder(
                future: search(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    return Text('Success');
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}

//* StateBar: 검색중, 검색완료 등 상태를 나타내는 바
class StateBar extends StatefulWidget {
  final String state;

  const StateBar({Key key, this.state}) : super(key: key);
  @override
  _StateBarState createState() => _StateBarState();
}

class _StateBarState extends State<StateBar> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    if (widget.state == 'searching') {
      text = 'Searching...';
    } else if (widget.state == 'refreshing') {
      text = 'Refreshing...';
    }

    return Container(
      child: Text(text),
    );
  }
}

// * HostList: 검색된 결과; 호스트 리스트
class HostList extends StatefulWidget {
  @override
  _HostListState createState() => _HostListState();
}

class _HostListState extends State<HostList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {},
    );
  }
}

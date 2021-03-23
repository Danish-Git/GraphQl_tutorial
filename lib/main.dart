import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'AddScreen.dart';
import 'QueryMutation.dart';
import 'consonents.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _httpLink = HttpLink("https://gorgeous-stud-70.hasura.app/v1/graphql",
      defaultHeaders: {
      'x-hasura-admin-secret' : kx_hasura_admin_secret,
      //'X-Parse-REST-API-Key' : kParseRestApiKey,
      },);
    final ValueNotifier<GraphQLClient> _client = ValueNotifier<GraphQLClient>(GraphQLClient(
        link: _httpLink,
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: _client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
   /* return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );*/
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      /*body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen())),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(r"""
                      query {
                        mockdata {
                          id
                          first_name
                          last_name
                          email
                          gender
                          ip_address
                        }
                      }
          """)),
        builder: (
            QueryResult result, {
            Refetch refetch,
            FetchMore fetchMore,
            }) {
          print("result : ${result.isLoading}");
          if(result.hasException) {
            return Text("${result.exception}");
          } else if(result.data == null) {
            return Text("No Data Found");
          } else {
            return ListView.builder(
              itemCount: result.data["mockdata"].length,
              itemBuilder: (BuildContext context, int index) {
                return Text(result.data["mockdata"][index]["first_name"]);
            });
          }
        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

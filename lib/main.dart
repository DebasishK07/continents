import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initHiveForFlutter();

    final HttpLink httpLink =
    HttpLink('https://countries.trevorblades.com/',);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
          cache: GraphQLCache(store: HiveStore()),

          link: httpLink as Link),
    );
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        home: MyHomePage(
          title: "List of Continents",
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String query = """
                query {
  continents {
        code
        name
        country{
        name
        }
    }
  }
""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Query(
          options: QueryOptions(document: gql(query),
          ),

          builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
            if (result.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (result.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.all(5),
                  onTap: ()=>{},
                  title:
                  Text(result.data['continents'][index]['name']),




                );
              },
              itemCount: result.data['continents'].length,
            );
          },
        )
    );
  }
}

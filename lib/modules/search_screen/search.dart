import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/news_cubit/states.dart';
import 'package:news_app/shared/news_cubit/cubit.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        NewsCubit cubit = NewsCubit.get(context);
        var list = cubit.searchData;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: defaultTextField(
                    controller: searchController,
                    type: TextInputType.text,
                    text: 'Search',
                    prefix: Icons.search,
                    onChange: (value) {
                      cubit.getSearchData(value.toString());
                    }),
              ),
              Expanded(child: articleBuilder(list, context, true)),
            ],
          ),
        );
      },
    );
  }
}

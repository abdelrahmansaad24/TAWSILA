

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawsila/modules/search-result/cubit/SeachCubit.dart';
import 'package:tawsila/modules/search-result/cubit/SearchStates.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:tawsila/shared/components/Components.dart';

import '../../shared/network/local/Cachhelper.dart';
import '../filter/FilterScreen.dart';
/*
  Map<String, dynamic> query = {
    "brands": "",
    "fuelTypes": "",
    "hasAbs": false,
    "hasAirConditioning": false,
    "hasRadio": false,
    "hasSunroof": false,
    "latitude": searchCubit.latitude,
    "longitude": searchCubit.longitude,
    "maxPrice":"",
    "maxYear":"",
    "minPrice":"",
    "minYear":"",
    "models":"",
    "offset": 0,
    "seatsCount": 0,
    "sortBy":"",
    "transmission":"",
  };
 */
class SearchResultScreen extends StatelessWidget {
  final Map<String, dynamic> query;
  const SearchResultScreen({super.key, required this.query});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit()..getLocation()..getData(query: query),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder:(context, state) {
          var searchCubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black,),
              ),
              centerTitle: true,
              title: const Text(
                "Search Results",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context: context, screen: FilterSearchResultsScreen());
                    },
                    icon: const Icon(
                      Icons.menu_sharp,
                      color: Colors.black,)),
              ],
            ),
            body: ConditionalBuilder(
              condition: searchCubit.totalCount > 0,
              builder: (BuildContext context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 8),
                      child: Text(
                        "${searchCubit.totalCount} results found",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return buildCar(searchCubit.cars[index]);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 4,
                            width: double.infinity,
                          ),
                          itemCount: searchCubit.totalCount),
                    ),
                  ],
                );
              },
              fallback: (context) => const Center(child: CircularProgressIndicator())
            ),
          );
        }
      ),
    );
  }
  Widget buildCar(Map<String, dynamic> car) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 3),
                gradient: const LinearGradient(
                  colors: [Colors.black, Colors.black54],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center
                ),
              ),
              child: Image(
                image: NetworkImage('${car['thumbnail']}'),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(child: Text("")),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${car['brand']}  ${car['model']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                      Row(
                        children:  [
                          const Icon(Icons.ac_unit, color: Colors.white,),
                          Text(
                            "${car['year']}.  ${car['seatsCount']} Seats",
                            style: const TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${car['price']} EGP",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children:  [
                          Text(
                            "${car['updatedAt']}",
                            style: const TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            "per day",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                    ],
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/bloc/home_bloc/home_events.dart';
import 'package:ecommerce_store/bloc/home_bloc/home_states.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/models/product.model.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/shared_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchProductController = TextEditingController();
  Set<Product> products = {};
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomeBloc>(context).add(FetchDataEvent());
    });
  }

  @override
  void dispose() {
    searchProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: const DefaultAppbar(),
        body: InkWell(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: BlocListener<HomeBloc, HomeStates>(
                    listener: (context, state) {
                      if (state is HomeStateWithData) {
                        products = BlocProvider.of<HomeBloc>(context).products;
                      }
                    },
                    child: TypeAheadField(
                      builder: (context, searchProductController, focusNode) {
                        return TextField(
                          controller: searchProductController,
                          focusNode: focusNode,
                          autofocus: false,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Search product by name or category',
                            hintStyle: theme.textTheme.displaySmall,
                          ),
                        );
                      },
                      errorBuilder: (context, error) {
                        return Text(
                          error.toString(),
                          style: theme.textTheme.labelSmall,
                        );
                      },
                      itemBuilder: (context, suggestion) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(suggestion.title),
                            subtitle: Text(suggestion.category),
                          ),
                        );
                      },
                      onSelected: (value) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: value,
                        );
                      },
                      suggestionsCallback: (pattern) {
                        return products.where((product) {
                          return product.title
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()) ||
                              product.category
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase());
                        }).toList();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Products',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeStates>(
                    bloc: BlocProvider.of<HomeBloc>(context),
                    builder: (context, state) {
                      if (state is HomeLoadingData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is HomeStateWithData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.product.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.productDetail,
                                arguments: state.product.elementAt(index),
                              ),
                              child: ProductCard(
                                product: state.product.elementAt(index),
                              ),
                            );
                          },
                        );
                      } else if (state is HomeStateWithNoData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message,
                                style: theme.textTheme.labelSmall),
                            Center(
                              child: ElevatedButton(
                                onPressed: () =>
                                    BlocProvider.of<HomeBloc>(context)
                                        .add(FetchDataEvent()),
                                child: Text(
                                  'retry',
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                      // return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              imageUrl: product.image,
              fit: BoxFit.fill,
              height: 200.0,
            ),
            const Divider(
              color: Colors.grey,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                product.title,
                style: theme.textTheme.displayMedium,
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.price.toString()}",
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0),
                ),
                const Spacer(),
                const Icon(
                  Icons.star,
                  color: AppColors.yellow,
                ),
                Text(
                  product.rating.rate.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

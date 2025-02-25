import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/bloc/orderBloc/order_bloc.dart';
import 'package:ecommerce_store/bloc/orderBloc/order_events.dart';
import 'package:ecommerce_store/bloc/orderBloc/order_states.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<OrderBloc>(context).add(GetAllOrders());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 0.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<HomeBloc>(context)
                            .selectedDrawerTileIndex = 0;
                      },
                    ),
                    Text(
                      'Orders',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              BlocBuilder<OrderBloc, OrdersStates>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80.0),
                        child: Lottie.asset('assets/loading_indicator.json'),
                      ),
                    );
                  } else if (state is AllOrdersLoaded) {
                    return state.orders.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.orders.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Card(
                                      color: AppColors.white,
                                      elevation: 1.0,
                                      semanticContainer: true,
                                      shadowColor: AppColors.black,
                                      child: ListTile(
                                        leading: SizedBox(
                                          width: 50.0,
                                          child: CachedNetworkImage(
                                            imageUrl: state
                                                .orders[index].productImage,
                                            height: 150.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(
                                          state.orders[index].productName,
                                          maxLines: 2,
                                          style: theme.textTheme.displaySmall,
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "\$${state.orders[index].price}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "Quantity: ${state.orders[index].quantity}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5.0),
                                              Text(
                                                state.orders[index].orderStatus,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 18.0,
                                                  color: state.orders[index]
                                                              .orderStatus ==
                                                          'in process'
                                                      ? AppColors.primary
                                                      : AppColors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Expanded(
                            child: Center(
                              child: Text(
                                'No Orders to display',
                                style: theme.textTheme.displayMedium,
                              ),
                            ),
                          );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No Orders to display',
                          style: theme.textTheme.displayMedium,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/bloc/home_bloc/home_events.dart';
import 'package:ecommerce_store/bloc/home_bloc/home_states.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_bloc.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_events.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_states.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/models/product.model.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/shared_widgets/appbar.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final TextEditingController searchProductController = TextEditingController();

  final auth = FirebaseAuth.instance;
  Map<String, IconData> drawerTile = {
    'Home': Icons.home_outlined,
    'Cart': Icons.shopping_cart_outlined,
    'Orders': Icons.list_alt_outlined,
    'Profile': Icons.person_outline,
  };
  Set<Product> products = {};
  Position? currentPosition;

  Future<String> getAddressFromLatLng(Position currentPosition) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = placemarks.first;

    String currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    return currentAddress;
  }

  Stream<String> _handleLocationPermission() async* {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      yield 'Please enable location service from settings';
    } else {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          openAppSettings();
        }
      } else if (permission == LocationPermission.whileInUse &&
          serviceEnabled) {
        currentPosition = await Geolocator.getCurrentPosition();
        BlocProvider.of<CartBloc>(context).currentAddress =
            await getAddressFromLatLng(currentPosition!);
        String address = await getAddressFromLatLng(currentPosition!);

        yield address;
      } else if (permission == LocationPermission.deniedForever) {
        openAppSettings();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomeBloc>(context).add(FetchDataEvent());
      BlocProvider.of<ProfileBloc>(context).add(CheckProfilePhoto());
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    searchProductController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleLocationPermission();
    }
  }

  Set<String> pages = {
    AppRoutes.home,
    AppRoutes.cart,
    AppRoutes.orders,
    AppRoutes.profile,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userCreated = BlocProvider.of<SignUpBloc>(context).userCreated;

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: AppColors.white,
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        BlocBuilder<ProfileBloc, ProfileStates>(
                          builder: (context, state) {
                            if (state is HasProfilePhoto) {
                              return CircleAvatar(
                                radius: 30.0,
                                child: (auth.currentUser != null ||
                                            userCreated) &&
                                        !BlocProvider.of<ProfileBloc>(context)
                                            .hasProfilePhoto
                                    ? Text(auth.currentUser!.displayName![0])
                                    : ClipOval(
                                        child: Image.file(
                                          BlocProvider.of<ProfileBloc>(context)
                                              .imageFile!,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              );
                            } else if (state is ProfilePhotoLoading) {
                              return const CircleAvatar(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        const SizedBox(width: 10.0),
                        BlocBuilder<ProfileBloc, ProfileStates>(
                          builder: (context, state) {
                            return Text(
                              userCreated || auth.currentUser != null
                                  ? auth.currentUser!.displayName.toString()
                                  : 'Guest User',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 20.0,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: drawerTile.length,
                  itemBuilder: (context, index) {
                    return BlocBuilder<HomeBloc, HomeStates>(
                      builder: (context, state) {
                        return ListTile(
                          selected: BlocProvider.of<HomeBloc>(context)
                                  .selectedDrawerTileIndex ==
                              index,
                          // selectedTileColor: AppColors.primary,
                          trailing: BlocProvider.of<HomeBloc>(context)
                                      .selectedDrawerTileIndex ==
                                  index
                              ? const Icon(
                                  Icons.circle,
                                  size: 15.0,
                                )
                              : const SizedBox(),
                          selectedColor: AppColors.primary,
                          title: Text(drawerTile.keys.elementAt(index)),
                          leading: Icon(drawerTile.values.elementAt(index)),
                          onTap: () {
                            Navigator.pop(context);
                            BlocProvider.of<HomeBloc>(context)
                                .selectedDrawerTileIndex = index;
                            Navigator.pushNamed(
                              context,
                              pages.elementAt(index),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  if (auth.currentUser != null) {
                    auth.signOut();
                    Utils.showLoadingDialog(context);
                    Navigator.popAndPushNamed(context, AppRoutes.login);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.login);
                  }
                },
                label: auth.currentUser != null
                    ? const Text(
                        'Logout',
                        style: TextStyle(fontSize: 18.0, color: AppColors.grey),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(fontSize: 18.0, color: AppColors.grey),
                      ),
                icon: const Icon(
                  Icons.logout,
                  size: 28.0,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
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
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    StreamBuilder(
                      stream: _handleLocationPermission(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Fetching location...');
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.hasData) {
                          return Flexible(
                            child: Text(
                              snapshot.data.toString(),
                            ),
                          );
                        } else {
                          return Text(snapshot.data.toString());
                        }
                      },
                    ),
                  ],
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
                            tileColor: AppColors.white,
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
          color: AppColors.grey,
          width: 1.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: AppColors.white,
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
              color: AppColors.grey,
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
                      color: AppColors.black,
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

import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/shared_widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShipmentDetail extends StatelessWidget {
  const ShipmentDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = BlocProvider.of<CartBloc>(context).getCartItems;
    double totalAmount = BlocProvider.of<CartBloc>(context).totalAmount;
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavbar(
          onPressed: () => BlocProvider.of<CartBloc>(context)
              .checkout(cartItems, context, AppRoutes.checkout),
          title: 'Place Order',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Shipping Details',
                        style: theme.textTheme.titleLarge,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Text(
                  'Address',
                  style: theme.textTheme.labelSmall,
                ),
                const AddressBar(),
                const SizedBox(height: 10.0),
                Text(
                  'Payment Method',
                  style: theme.textTheme.labelSmall,
                ),
                const Card(
                    elevation: 1.0,
                    color: AppColors.white,
                    child: RadioTiles()),
                const SizedBox(height: 10.0),
                Text(
                  'Products',
                  style: theme.textTheme.labelSmall,
                ),
                Card(
                  elevation: 1.0,
                  color: AppColors.white,
                  child: Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(cartItems.elementAt(index).productName),
                          subtitle: Text(
                              'Quantity: ${cartItems.elementAt(index).quantity}'),
                          trailing: Text(
                              '\$ ${cartItems.elementAt(index).variants.first.price}'),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.labelMedium,
                    ),
                    const Spacer(),
                    Text(
                      " \$${totalAmount.round().toString()}",
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RadioTiles extends StatefulWidget {
  const RadioTiles({
    super.key,
  });

  @override
  State<RadioTiles> createState() => _RadioTilesState();
}

class _RadioTilesState extends State<RadioTiles> {
  String? _selectedPaymentMethod;

  final List<Map<String, String>> _paymentMethods = [
    {'title': 'Credit Card', 'value': 'credit_card'},
    {'title': 'COD', 'value': 'cod'},
    {'title': 'Google Pay', 'value': 'google_pay'},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _paymentMethods.map((method) {
        return RadioListTile<String>(
          title: Text(method['title']!),
          value: method['value']!,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value;
            });
          },
        );
      }).toList(),
    );
  }
}

class AddressBar extends StatefulWidget {
  const AddressBar({super.key});

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  bool addressChanged = false;
  @override
  Widget build(BuildContext context) {
    final currentAddress = BlocProvider.of<CartBloc>(context).currentAddress;
    // bool addressChanged = BlocProvider.of<CartBloc>(context).addressChanged!;
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              enabled: addressChanged,
              autoFocus: true,
              controller: BlocProvider.of<CartBloc>(context).addressController,
              backgroundColor: const WidgetStatePropertyAll(AppColors.white),
              hintText: currentAddress,
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  addressChanged = !addressChanged;
                });
                print(addressChanged);
              },
              child: const Text(
                'Change my Current Location',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
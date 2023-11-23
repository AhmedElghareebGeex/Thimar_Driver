import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiwi/kiwi.dart';
import 'package:thimar_driver/core/logic/helper_methods.dart';
import 'package:thimar_driver/features/orders/bloc.dart';
import 'package:thimar_driver/features/orders/events.dart';
import 'package:thimar_driver/features/orders/model.dart';
import 'package:thimar_driver/features/orders/states.dart';

import '../../../core/design/app_input.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final bloc = KiwiContainer().resolve<OrdersBloc>();
  String type = "current_orders";

  void _init() {
    bloc.add(
      GetOrdersDataEvent(
        type: type,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلباتي"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 55.h,
              width: 343.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10.r),
                border: Border.all(
                  color: const Color(
                    0xff000000,
                  ).withOpacity(
                    0.16,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      type = 'current_orders';
                      setState(() {});
                      _init();
                    },
                    child: Container(
                      height: 42.h,
                      width: 165.w,
                      decoration: BoxDecoration(
                          color: type == 'current_orders'
                              ? getMaterialColor()
                              : null,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Center(
                        child: Text(
                          "الحالية",
                          style: TextStyle(
                            color: type == 'current_orders'
                                ? Colors.white
                                : const Color(
                                    0xffA2A1A4,
                                  ),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      type = 'finished_orders';
                      setState(() {});
                      _init();
                    },
                    child: Container(
                      height: 42.h,
                      width: 165.w,
                      decoration: BoxDecoration(
                          color: type == 'finished_orders'
                              ? getMaterialColor()
                              : null,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Center(
                        child: Text(
                          "المنتهية",
                          style: TextStyle(
                            color: type == 'finished_orders'
                                ? Colors.white
                                : const Color(
                                    0xffA2A1A4,
                                  ),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 17.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
              child: const AppInput(
                isFilled: true,
                labelText: "ابحث عن ما تريد ؟",
                prefixIcon: "assets/icons/Search.svg",
              ),
            ),
            SizedBox(
              height: 17.h,
            ),
            Expanded(
              child: BlocBuilder(
                bloc: bloc,
                builder: (context, state) {
                  if (state is GetOrdersDataLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetOrdersDataSuccessState) {
                    return state.data.isEmpty
                        ? const Center(
                            child: Text("لا يوجد بيانات"),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: state.data.length,
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 16.w,
                            ),
                            separatorBuilder: (context, index) => const SizedBox(),
                            itemBuilder: (context, index) {
                              final item = state.data[index];
                              return _Item(item: item);
                            },
                          );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
  });

  final DriverOrdersModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigateTo(
        //   OrderDetails(
        //     id: item.id,
        //   ),
        // );
      },
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          vertical: 10.h,
          horizontal: 14.w,
        ),
        margin: EdgeInsetsDirectional.symmetric(
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadiusDirectional.circular(
            15.r,
          ),
          color: Colors.black.withOpacity(
            0.005,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 2.r,
              blurStyle: BlurStyle.inner,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "طلب رقم : # ${item.id}",
                  style: TextStyle(
                      fontSize: 17.sp,
                      color: getMaterialColor(),
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 95.w,
                  height: 23.h,
                  padding:
                      EdgeInsetsDirectional.symmetric(
                    horizontal: 11.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional
                            .circular(
                      7.r,
                    ),
                    color: getOrderStatusColor(
                        item.status),
                  ),
                  child: Center(
                    child: Text(
                      getOrderStatus(
                        item.status,
                      ),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: getOrderStatusTextColor(
                          item.status
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              item.date,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w300,
                color: const Color(
                  0xff9C9C9C,
                ),
              ),
            ),
            const Divider(
              color: Color(0xffE4E4E4),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional
                            .circular(
                      8.r,
                    ),
                  ),
                  margin: EdgeInsetsDirectional.only(
                    end: 10.w,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    item.clientImage,
                    width: 46.w,
                    height: 41.h,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      item.clientName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: getMaterialColor(),
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/location.svg",
                          width: 12.w,
                          height: 14.h,
                          fit: BoxFit.scaleDown,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          item.location,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                FontWeight.w300,
                            color: const Color(
                              0xff9A9A9A,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment:
            //   MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       mainAxisAlignment:
            //       MainAxisAlignment.start,
            //       children: [
            //         Text(
            //           "طلب رقم : ${item.id}#",
            //           style: TextStyle(
            //             fontSize: 17.sp,
            //             fontWeight:
            //             FontWeight.bold,
            //             color: getMaterialColor(),
            //           ),
            //         ),
            //         SizedBox(
            //           height: 8.h,
            //         ),
            //         Text(
            //           item.date,
            //           style: TextStyle(
            //             fontSize: 14.sp,
            //             fontWeight:
            //             FontWeight.w300,
            //             color: const Color(
            //               0xff9C9C9C,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Container(
            //       width: 95.w,
            //       height: 23.h,
            //       padding: EdgeInsetsDirectional
            //           .symmetric(
            //         horizontal: 11.w,
            //         vertical: 5.h,
            //       ),
            //       decoration: BoxDecoration(
            //         borderRadius:
            //         BorderRadiusDirectional
            //             .circular(7.r),
            //         color: getOrderStatusColor(
            //           item.status,
            //         ),
            //       ),
            //       child: Center(
            //         child: Text(
            //           getOrderStatus(
            //             item.status,
            //           ),
            //           style: TextStyle(
            //             fontSize: 11.sp,
            //             fontWeight:
            //             FontWeight.bold,
            //             color:
            //             getOrderStatusTextColor(
            //                 item.status),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const Divider(
              color: Color(0xffE4E4E4),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ...List.generate(
                      item.images.length,
                      (index) => Container(
                        width: 25.w,
                        height: 25.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadiusDirectional
                                  .circular(7.r),
                          border: Border.all(
                            color: const Color(
                              0xff61B80C,
                            ).withOpacity(0.06),
                          ),
                        ),
                        margin: EdgeInsetsDirectional
                            .only(end: 3.w),
                        child: Image.network(
                          item.images[index].url,
                          width: 25.w,
                          height: 25.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    if (item.images.length > 3)
                      Container(
                        width: 25.w,
                        height: 25.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadiusDirectional
                                  .circular(7.r),
                          color: getMaterialColor()
                              .withOpacity(0.13),
                        ),
                        child: Center(
                          child: Text(
                            "+${item.images.length - 3}",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  getMaterialColor(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  "${item.totalPrice} ر.س",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.sp,
                    color: getMaterialColor(),
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

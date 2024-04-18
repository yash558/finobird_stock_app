import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';

import '../repository/watchlist_repo.dart';

class BrowseCardOld extends StatelessWidget {
  const BrowseCardOld({
    Key? key,
    required this.title,
    required this.ontap,
    required this.getWatchlistFeed,
    required this.id,
  }) : super(key: key);

  final String title;
  final Function() ontap;
  final Function() getWatchlistFeed;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: InkWell(
        onTap: () {
          ontap();
        },
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4AB5E5).withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        title,
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.text.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      width: 78,
                      child: InkWell(
                        onTap: () {
                          getWatchlistFeed();
                        },
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                  width: 60,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xFF4AB5E5)
                                        .withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Feeds",
                                      style: Styles.text.copyWith(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                            // Positioned(
                            //   right: 0,
                            //   child: Container(
                            //     width: 20,
                            //     height: 20,
                            //     decoration: BoxDecoration(
                            //       color: const Color(0xFF4AB5E5),
                            //       borderRadius: BorderRadius.circular(100),
                            //     ),
                            //     child: Center(
                            //       child: Text(
                            //         "23",
                            //         style: Styles.text.copyWith(
                            //           fontSize: 8,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      animType: AnimType.bottomSlide,
                      title: 'Delete',
                      desc: 'Are you sure you want to delete the watchlist?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        WatchlistRepo().deleteWatchlist(id);
                      },
                      width: 400,
                      btnOkColor: const Color(0xFF4AB5E5),
                      titleTextStyle: Styles.semiBold,
                      descTextStyle: Styles.text,
                      buttonsTextStyle: Styles.text,
                    ).show();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

                // if (showDelete.value)
                //   Align(
                //     alignment: Alignment.center,
                //     child: Container(
                //       height: 200,
                //       width: 200,
                //       decoration: BoxDecoration(
                //         color: Colors.white.withOpacity(0.6),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: IconButton(
                //         onPressed: () {
                //           WatchlistRepo().deleteWatchlist(id);
                //         },
                //         icon: const Icon(
                //           Icons.delete,
                //           color: Colors.red,
                //         ),
                //       ),
                //     ),
                //   ),
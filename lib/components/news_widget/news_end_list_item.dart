import 'package:flutter/material.dart';

class NewsEndListItem extends StatelessWidget {
  const NewsEndListItem({
    super.key,
    this.isRefreshing = false,
    this.refreshRequested,
  });
  final bool isRefreshing;
  final Function()? refreshRequested;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: InkWell(
        onTap: isRefreshing
            ? null
            : () {
                if (refreshRequested != null) {
                  refreshRequested!();
                }
              },
        child: Center(
          child: isRefreshing ? _refreshing() : _clickToRefresh(),
        ),
      ),
    );
  }

  Widget _clickToRefresh() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Click here or scroll to end of list again to refresh",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _refreshing() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
        ),
        Text(
          "Refreshing...",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class MenuListGroupItem<T> {
  final String title;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onClick;
  final bool spaceForEmptyLeading;
  final bool wrapTextWhenOverflow;
  final bool isEnabled;

  MenuListGroupItem({
    required this.title,
    this.description,
    this.leading,
    this.trailing,
    this.onClick,
    this.spaceForEmptyLeading = false,
    this.wrapTextWhenOverflow = false,
    this.isEnabled = true,
  });

  factory MenuListGroupItem.toggleButton({
    required String title,
    String? description,
    Widget? leading,
    bool spaceForEmptyLeading = false,
    bool wrapTextWhenOverFlow = false,
    bool switchValue = false,
    bool isEnabled = true,
    Function(bool)? onSwitchChanged,
  }) {
    return MenuListGroupItem(
      title: title,
      description: description,
      leading: leading,
      trailing: Switch(
        value: switchValue,
        onChanged: (value) {
          if (isEnabled) {
            onSwitchChanged?.call(value);
          }
        },
      ),
      spaceForEmptyLeading: spaceForEmptyLeading,
      wrapTextWhenOverflow: wrapTextWhenOverFlow,
      onClick: () {
        onSwitchChanged?.call(!switchValue);
      },
      isEnabled: isEnabled,
    );
  }

  factory MenuListGroupItem.checkboxButton({
    required String title,
    String? description,
    Widget? trailing,
    bool wrapTextWhenOverFlow = false,
    bool switchValue = false,
    bool isEnabled = true,
    Function(bool)? onSwitchChanged,
  }) {
    return MenuListGroupItem(
      title: title,
      description: description,
      leading: Checkbox(
        value: switchValue,
        onChanged: (value) {
          if (isEnabled) {
            onSwitchChanged?.call(value ?? false);
          }
        },
      ),
      trailing: trailing,
      spaceForEmptyLeading: false,
      wrapTextWhenOverflow: wrapTextWhenOverFlow,
      onClick: () {
        onSwitchChanged?.call(!switchValue);
      },
      isEnabled: isEnabled,
    );
  }

  factory MenuListGroupItem.radioButton({
    required String title,
    String? description,
    Widget? trailing,
    bool wrapTextWhenOverFlow = false,
    required T currentValue,
    required T radioValue,
    bool isEnabled = true,
    Function()? onRadioClicked,
  }) {
    return MenuListGroupItem(
      title: title,
      description: description,
      leading: Radio(
        value: radioValue,
        groupValue: currentValue,
        onChanged: (value) {
          if (isEnabled) {
            onRadioClicked?.call();
          }
        },
      ),
      trailing: trailing,
      spaceForEmptyLeading: false,
      wrapTextWhenOverflow: wrapTextWhenOverFlow,
      onClick: () {
        onRadioClicked?.call();
      },
      isEnabled: isEnabled,
    );
  }
}

class MenuListGroup extends StatelessWidget {
  const MenuListGroup({
    super.key,
    required this.itemList,
    this.itemMinHeight = 85,
    this.groupTitle,
  });

  final List<MenuListGroupItem> itemList;
  final double itemMinHeight;
  final String? groupTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        groupTitle != null ? (itemList.length + 1) : itemList.length,
        (index) {
          if (index == 0 && groupTitle != null) {
            return Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                groupTitle!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            );
          } else {
            var indexTemp = groupTitle != null ? index - 1 : index;
            return _ListGroupItemView(
              listGroupItem: itemList.elementAt(indexTemp),
              shouldRadiusOnTop: indexTemp == 0,
              shouldRadiusOnBottom: indexTemp == (itemList.length - 1),
              wrapTextWhenOverflow: itemList.elementAt(indexTemp).wrapTextWhenOverflow,
              minHeight: itemMinHeight,
            );
          }
        },
      ),
    );
  }
}

class _ListGroupItemView extends StatelessWidget {
  const _ListGroupItemView({
    required this.listGroupItem,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.wrapTextWhenOverflow = false,
    this.minHeight = -1,
  });

  final bool shouldRadiusOnTop;
  final bool shouldRadiusOnBottom;
  final bool wrapTextWhenOverflow;
  final double minHeight;
  final MenuListGroupItem listGroupItem;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(shouldRadiusOnTop ? 20 : 5),
        topLeft: Radius.circular(shouldRadiusOnTop ? 20 : 5),
        bottomLeft: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
        bottomRight: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight <= 0 ? 0 : minHeight,
          minWidth: double.infinity,
        ),
        // width: double.infinity,
        // height: (height <= 0) ? null : height,
        child: InkWell(
          onTap: listGroupItem.onClick,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                listGroupItem.leading != null
                    ? listGroupItem.leading!
                    : listGroupItem.spaceForEmptyLeading
                        ? Icon(
                            Icons.yard_outlined,
                            color: Colors.white.withAlpha(0),
                          )
                        : Container(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: (listGroupItem.leading != null || listGroupItem.spaceForEmptyLeading) ? 15 : 0,
                      right: listGroupItem.leading != null ? 15 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listGroupItem.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: wrapTextWhenOverflow ? null : TextOverflow.ellipsis,
                          maxLines: wrapTextWhenOverflow ? null : 2,
                        ),
                        if (listGroupItem.description != null)
                          Text(
                            listGroupItem.description!,
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 2,
                          ),
                        // description != null ? Text(description!) : Container(),
                      ],
                    ),
                  ),
                ),
                listGroupItem.trailing != null ? listGroupItem.trailing! : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

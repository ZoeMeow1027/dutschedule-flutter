import 'package:flutter/material.dart';

class ExpandableChoice<T> extends StatelessWidget {
  const ExpandableChoice({
    super.key,
    required this.title,
    required this.valueList,
    required this.currentValue,
    this.hideCurrentValueIfExpanded = true,
    this.isExpanded = false,
    this.onExpandChanged,
    this.onClick,
  });

  final String title;
  final List<ExpandableChoiceItem<T>> valueList;
  final T currentValue;
  final bool hideCurrentValueIfExpanded;
  final bool isExpanded;
  final Function(bool)? onExpandChanged;
  final Function(T)? onClick;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            onTap: () => onExpandChanged?.call(!isExpanded),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            if (!hideCurrentValueIfExpanded || (hideCurrentValueIfExpanded && !isExpanded))
                              Text(
                                valueList.where((p) => p.isEqual(currentValue)).firstOrNull?.text ?? "(unknown)",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 30,
                        ),
                        onPressed: () => onExpandChanged?.call(!isExpanded),
                      ),
                    ],
                  ),
                  if (isExpanded) SizedBox(height: 10),
                  if (isExpanded)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3,
                      children: List.generate(
                        valueList.length,
                        (index) {
                          return _ExpandableChoiceOption(
                            item: valueList.elementAt(index),
                            shouldRadiusOnTop: index == 0,
                            shouldRadiusOnBottom: index == (valueList.length - 1),
                            onClick: () {
                              onClick?.call(valueList.elementAt(index).value);
                            },
                          );
                        },
                      ),
                    ),
                  if (isExpanded) SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableChoiceItem<T> {
  final T value;
  final String text;

  ExpandableChoiceItem({
    required this.text,
    required this.value,
  });

  bool isEqual(T data) {
    return value == data;
  }
}

class _ExpandableChoiceOption<T> extends StatelessWidget {
  const _ExpandableChoiceOption({
    required this.item,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.onClick,
  });

  final ExpandableChoiceItem<T> item;
  final bool shouldRadiusOnTop;
  final bool shouldRadiusOnBottom;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: 50,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(shouldRadiusOnTop ? 20 : 5),
          topLeft: Radius.circular(shouldRadiusOnTop ? 20 : 5),
          bottomLeft: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
          bottomRight: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
        ),
        borderOnForeground: false,
        child: InkWell(
          onTap: () => onClick?.call(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Center(
              child: Text(item.text),
            ),
          ),
        ),
      ),
    );
  }
}

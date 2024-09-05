import 'package:chatuni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

SizedBox vSpacer(double height) => SizedBox(height: height);
SizedBox hSpacer(double width) => SizedBox(width: width);

EdgeInsets vEdge(double size) => EdgeInsets.symmetric(vertical: size);
EdgeInsets hEdge(double size) => EdgeInsets.symmetric(horizontal: size);
EdgeInsets tEdge(double size) => EdgeInsets.only(top: size);
EdgeInsets rEdge(double size) => EdgeInsets.only(right: size);
EdgeInsets bEdge(double size) => EdgeInsets.only(bottom: size);
EdgeInsets lEdge(double size) => EdgeInsets.only(left: size);
EdgeInsets aEdge(double size) => EdgeInsets.all(size);
EdgeInsets edge(double left, double top, double right, double bottom) =>
    EdgeInsets.fromLTRB(left, top, right, bottom);

Container Function(Widget) pcBox(EdgeInsets padding, Color color) =>
    (Widget child) => Container(padding: padding, color: color, child: child);
Container Function(Widget) pBox(EdgeInsets padding) =>
    (Widget child) => Container(padding: padding, child: child);
Container Function(Widget) cBox(Color color) =>
    (Widget child) => Container(color: color, child: child);

Align left(Widget child) =>
    Align(alignment: Alignment.centerLeft, child: child);
Align center(Widget child) => Align(alignment: Alignment.center, child: child);
Align right(Widget child) =>
    Align(alignment: Alignment.centerRight, child: child);
Align top(Widget child) => Align(alignment: Alignment.topCenter, child: child);
Align bottom(Widget child) =>
    Align(alignment: Alignment.bottomCenter, child: child);

Row Function(List<Widget>) _row(
  MainAxisAlignment hAligh,
  CrossAxisAlignment vAligh,
) =>
    (List<Widget> children) => Row(
          mainAxisAlignment: hAligh,
          crossAxisAlignment: vAligh,
          children: children,
        );

Column Function(List<Widget>) _col(
  MainAxisAlignment vAligh,
  CrossAxisAlignment hAligh,
) =>
    (List<Widget> children) => Column(
          mainAxisAlignment: vAligh,
          crossAxisAlignment: hAligh,
          children: children,
        );

Row Function(List<Widget>) ssRow =
    _row(MainAxisAlignment.start, CrossAxisAlignment.start);

Row Function(List<Widget>) scRow =
    _row(MainAxisAlignment.start, CrossAxisAlignment.center);

Row Function(List<Widget>) seRow =
    _row(MainAxisAlignment.start, CrossAxisAlignment.end);

Row Function(List<Widget>) csRow =
    _row(MainAxisAlignment.center, CrossAxisAlignment.start);

Row Function(List<Widget>) ccRow =
    _row(MainAxisAlignment.center, CrossAxisAlignment.center);

Row Function(List<Widget>) ceRow =
    _row(MainAxisAlignment.center, CrossAxisAlignment.end);

Row Function(List<Widget>) cfRow =
    _row(MainAxisAlignment.center, CrossAxisAlignment.stretch);

Row Function(List<Widget>) esRow =
    _row(MainAxisAlignment.end, CrossAxisAlignment.start);

Row Function(List<Widget>) ecRow =
    _row(MainAxisAlignment.end, CrossAxisAlignment.center);

Row Function(List<Widget>) eeRow =
    _row(MainAxisAlignment.end, CrossAxisAlignment.end);

Column Function(List<Widget>) ssCol =
    _col(MainAxisAlignment.start, CrossAxisAlignment.start);

Column Function(List<Widget>) scCol =
    _col(MainAxisAlignment.start, CrossAxisAlignment.center);

Column Function(List<Widget>) seCol =
    _col(MainAxisAlignment.start, CrossAxisAlignment.end);

Column Function(List<Widget>) csCol =
    _col(MainAxisAlignment.center, CrossAxisAlignment.start);

Column Function(List<Widget>) ccCol =
    _col(MainAxisAlignment.center, CrossAxisAlignment.center);

Column Function(List<Widget>) ceCol =
    _col(MainAxisAlignment.center, CrossAxisAlignment.end);

Column Function(List<Widget>) esCol =
    _col(MainAxisAlignment.end, CrossAxisAlignment.start);

Column Function(List<Widget>) ecCol =
    _col(MainAxisAlignment.end, CrossAxisAlignment.center);

Column Function(List<Widget>) eeCol =
    _col(MainAxisAlignment.end, CrossAxisAlignment.end);

Container vContainer(
  List<Widget> children, {
  double padding = 10,
  MainAxisAlignment vAlign = MainAxisAlignment.start,
  CrossAxisAlignment hAlign = CrossAxisAlignment.center,
  bool scroll = false,
}) {
  final col = Column(
    mainAxisAlignment: vAlign,
    crossAxisAlignment: hAlign,
    children: children,
  );

  return pBox(hEdge(padding))(
    center(
      scroll ? SingleChildScrollView(child: col) : col,
    ),
  );
}

Container fContainer(
  Widget child, {
  double padding = 0,
  Color color = Colors.white,
}) =>
    Container(
      color: color,
      constraints: const BoxConstraints.expand(),
      child: Center(
        child: child,
      ),
    );

Card vCard(List<Widget> children) => Card(
      child: Column(
        children: children,
      ),
    );

Card v2Card(
  Widget child1,
  Widget child2, {
  double radius = 10,
  Color color1 = Colors.white,
  Color color2 = Colors.white,
  double padding = 10,
}) =>
    Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _clipTop(pcBox(aEdge(padding), color1)(center(child1)), radius),
          _clipBottom(pcBox(aEdge(padding), color2)(center(child2)), radius),
        ],
      ),
    );

Card tCard(
  Widget header,
  List<Widget> children, {
  Color color = Colors.white,
  double padding = 10,
  double radius = 10,
}) =>
    Card(
      child: Column(
        children: [
          _clipTop(
            pcBox(aEdge(padding), color)(
              Center(child: header),
            ),
            radius,
          ),
          ...children.map(
            (child) => pBox(aEdge(padding))(child),
          ),
        ],
      ),
    );

Container grid(
  int cols,
  List<Widget> children, {
  double spacing = 8,
  double left = 8,
  double top = 8,
  double right = 8,
  double bottom = 8,
}) =>
    pBox(edge(left, top, right, bottom))(
      SingleChildScrollView(
        child: LayoutGrid(
          columnSizes: range(1, cols).map((_) => 1.fr).toList(),
          rowSizes: range(1, (children.length / cols).ceil())
              .map((_) => auto)
              .toList(),
          columnGap: spacing,
          rowGap: spacing,
          children: children,
        ),
      ),
    );

GridView vGrid(
  int cols,
  List<Widget> children, {
  double spacing = 8,
}) =>
    GridView.count(
      crossAxisCount: cols,
      children: children,
    );

ListView Function(
  List<Widget>, {
  double left,
  double top,
  double right,
  double bottom,
}) _list(bool isVertical) => (
      List<Widget> children, {
      double left = 8,
      double top = 8,
      double right = 8,
      double bottom = 8,
    }) =>
        ListView.separated(
          padding: edge(left, top, right, bottom),
          scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: children.length,
          separatorBuilder: (c, i) => vSpacer(8),
          itemBuilder: (c, i) => children[i],
        );

final hList = _list(false);

final vList = _list(true);

SizedBox box(double width, double height, Widget child) =>
    SizedBox(width: width, height: height, child: child);

Expanded grow(int cols, Widget child) => Expanded(flex: cols, child: child);

InkWell tap(void Function() onTap, Widget child) =>
    InkWell(onTap: onTap, child: child);

ClipRRect _clipTop(Widget child, double radius) => ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      child: child,
    );

ClipRRect _clipBottom(Widget child, double radius) => ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
      child: child,
    );

import 'package:flutter/material.dart';


const double kToolbarLeadingWidth = kToolbarHeight;

class PageTitle extends StatelessWidget implements PreferredSizeWidget
{
  final Widget leading;
  final bool automaticallyImplyLeading;
  final bool unfocusOnTap;
  final Widget title;
  final bool centerTitle;
  final double titleSpacing;
  final List<Widget> actions;

  @override
  final Size preferredSize;

  const PageTitle({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.unfocusOnTap = false,
    this.title,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.actions,
  })
  : assert(automaticallyImplyLeading != null)
  , assert(unfocusOnTap != null)
  , assert(titleSpacing != null)
  , preferredSize = const Size.fromHeight(kToolbarHeight)
  , super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final theme = Theme.of(context);
    final appBarTheme = AppBarTheme.of(context);
    final actionsIconTheme = appBarTheme.actionsIconTheme
      ?? appBarTheme.iconTheme
      ?? theme.primaryIconTheme;

    Widget leading = this.leading;
    if (leading == null && automaticallyImplyLeading) {
      final parentRoute = ModalRoute.of(context);
      final canPop = parentRoute?.canPop ?? false;
      final useCloseButton = parentRoute is PageRoute<dynamic>
        && parentRoute.fullscreenDialog;
      if (canPop) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      }
    }
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: kToolbarLeadingWidth),
        child: leading,
      );
    }

    Widget title = this.title;
    if (title != null) {
      bool namesRoute;
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          namesRoute = true;
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          break;
      }
      title = Semantics(
        namesRoute: namesRoute,
        child: title,
        header: true,
      );
      title = DefaultTextStyle(
        style: appBarTheme.textTheme?.headline6
          ?? theme.primaryTextTheme.headline6,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );
    }

    Widget actions;
    if (this.actions != null && this.actions.isNotEmpty) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: this.actions,
      );
    }
    if (actions != null && actionsIconTheme != null) {
      actions = IconTheme.merge(
        data: actionsIconTheme,
        child: actions,
      );
    }

    final toolBar = NavigationToolbar(
      leading: leading,
      middle: title,
      trailing: actions,
      centerMiddle: theme.appBarTheme.centerTitle ?? centerTitle ?? true,
      middleSpacing: titleSpacing,
    );
    Widget appBar = Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        bottom: false,
        top: true,
        child: toolBar,
      ),
    );
    if (unfocusOnTap) {
      appBar = GestureDetector(
        child: Material(color: Colors.transparent, child: appBar),
        onTap: () => FocusScope.of(context)?.unfocus(),
      );
    }

    return appBar;
  }
}

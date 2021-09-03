import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_demo/ui/widgets/about.dart';
import 'package:theme_demo/ui/widgets/app_drawer.dart';
import 'package:theme_demo/ui/widgets/page_body.dart';
import 'package:theme_demo/ui/widgets/theme/dark_app_bar_style_switch.dart';
import 'package:theme_demo/ui/widgets/theme/light_app_bar_style_switch.dart';
import 'package:theme_demo/ui/widgets/theme/show_theme_colors.dart';
import 'package:theme_demo/ui/widgets/theme/surface_style_switch.dart';
import 'package:theme_demo/ui/widgets/theme/theme_mode_switch.dart';
import 'package:theme_demo/ui/widgets/theme/theme_selector.dart';
import 'package:theme_demo/utils/app_icons.dart';
import 'package:theme_demo/utils/app_insets.dart';

/// This is basically a demo of the default Flutter counter page, with
/// a theme mode switch on it using a Riverpod provider.
///
/// The counter is using just local state in a StatefulWidget, to
/// demonstrate the usage of ConsumerStatefulWidget instead of
/// StatefulWidget and ConsumerState<T> instead of State<T>.
///
/// NOTE: This local counter state is no kept when switching between pages.
/// As an exercise you can make it to an <int> StateProvider and use it
/// instead, then it will be kept when changing pages. If you do soe you
/// can also change this page Widget to a ConsumerWidget.
class CounterPage extends ConsumerStatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  static const String route = '/counter';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final TextTheme textTheme = theme.textTheme;
    final TextStyle headline4 = textTheme.headline4!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThemeDemo & Counter'),
        actions: const <Widget>[AboutIconButton()],
      ),
      drawer: const AppDrawer(),
      // This annotated region will change the Android system navigation bar to
      // a theme color, matching active theme mode and FlexColorScheme theme.
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: FlexColorScheme.themedSystemNavigationBar(context),
        child: PageBody(
          child: ListView(
            padding: const EdgeInsets.all(AppInsets.edge),
            children: <Widget>[
              Text('Info', style: headline4),
              const Text(
                'This page shows resulting FlexColorScheme theme based colors '
                'and the other settings. I shows how simple Riverpod based '
                'widgets can be used here, as well as in Drawer and a '
                'BottomSheet to control theme settings.',
              ),
              const Divider(),
              const ThemeSelector(
                contentPadding: EdgeInsets.zero,
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Theme mode'),
                trailing: ThemeModeSwitch(),
              ),
              const Divider(),
              const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Surface branding'),
                  trailing: SurfaceStyleSwitch()),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('AppBar style'),
                trailing: isLight
                    ? const LightAppBarStyleSwitch()
                    : const DarkAppBarStyleSwitch(),
              ),
              const Divider(),
              Text('Counter', style: headline4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'You pushed the (+) button this many times',
                ),
                trailing: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Divider(),
              Text('Theme colors', style: headline4),
              const ShowThemeColors(),
              const Divider(),
              const SizedBox(height: AppInsets.xl),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(AppIcons.add),
      ),
    );
  }
}

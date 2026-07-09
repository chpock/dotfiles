//@ pragma AppId org.quickdashboard

pragma ComponentBehavior: Bound

import Quickshell
import qs.qd

import QtQuick

QuickDashboard {
    id: root

    theme: 'theme.json'
    widget: 'widget.json'
    defaults: 'defaults.json'

    DashboardDefault {
        // screen: Quickshell.screens[0]
        screen: Quickshell.screens[0]
        align: Dashboard.AlignRight
    }

}

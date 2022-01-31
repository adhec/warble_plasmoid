/*
 * SPDX-FileCopyrightText: 2012 Reza Fatahilah Shah <rshah0385@kireihana.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.12
import QtQuick.Layouts 1.1

import QtQuick.Controls 2.4


import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents // PC3 TabBar+TabButton need work first
import org.kde.plasma.components 3.0 as PlasmaComponents3
//import org.kde.kquickcontrolsaddons 2.0



Item {
    id: root

    //readonly property int implicitWidth:  PlasmaCore.Units.gridUnit
    //readonly property int implicitHeight: PlasmaCore.Units.gridUnit
    //readonly property int minimumWidth: PlasmaCore.Units.gridUnit
    //readonly property int minimumHeight: PlasmaCore.Units.gridUnit

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground
    Plasmoid.icon: "face-laughing"

    width: PlasmaCore.Units.gridUnit ? PlasmaCore.Units.gridUnit : units.gridUnit
    height: PlasmaCore.Units.gridUnit ? PlasmaCore.Units.gridUnit : units.gridUnit

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: Item{

        property int gridUnit: PlasmaCore.Units.gridUnit ? PlasmaCore.Units.gridUnit : units.gridUnit

        Layout.fillHeight: false
        Layout.fillWidth: false
        Layout.minimumWidth: gridUnit
        Layout.maximumWidth: Layout.minimumWidth
        Layout.minimumHeight: gridUnit
        Layout.maximumHeight: Layout.minimumHeight

        Rectangle{

            width:  gridUnit
            height: gridUnit
            anchors.centerIn: parent
            anchors.margins: 2

            color: 'transparent'
            border.width: 1
            border.color: theme.textColor
            radius: 2
        }
        Label{
            anchors.centerIn: parent
            text: 'W'
            font.bold: true
            color: theme.textColor

        }
        MouseArea{
            anchors.fill: parent
            onClicked: plasmoid.expanded = !plasmoid.expanded
        }

    }

    Plasmoid.fullRepresentation: fullRepresentation

    Component {
        id: fullRepresentation
        FullRepresentation {}
    }
}

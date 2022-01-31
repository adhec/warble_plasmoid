/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.12
import QtQuick.Layouts 1.0 as QtLayouts
import QtQuick.Controls 2.3 as QtControls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.5 as Kirigami

Kirigami.FormLayout {
    id: root
    anchors.left: parent.left
    anchors.right: parent.right

    signal configurationChanged

    property int cfg_level: 5

    QtLayouts.RowLayout {
        Kirigami.FormData.label: i18n("Level:")

        QtControls.ComboBox {
            id: level
            textRole: "label"
            model: [
                {
                    'label': i18n("Easy"),
                    'value': 5

                },
                {
                    'label': i18n("Medium"),
                    'value': 6
                },
                {
                    'label': i18n("Hard"),
                    'value': 7
                }
            ]
            onCurrentIndexChanged: cfg_level = model[currentIndex]["value"]

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]["value"] === plasmoid.configuration.level) {
                        level.currentIndex = i;
                    }
                }
            }
        }
    }

}

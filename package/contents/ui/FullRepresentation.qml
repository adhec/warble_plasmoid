/*
 * SPDX-FileCopyrightText: 2012 Reza Fatahilah Shah <rshah0385@kireihana.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.12
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4


import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents // PC3 TabBar+TabButton need work first
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras


Item{
    property var currentUiLabel
    property string word_key

    property string _green : '#9bdb4d'
    property string _white : colorWithAlpha(theme.backgroundColor,0.3)
    property string _yellow :'#ffe16b'
    property string _error : '#8d8d8d'
    property string _baseColorKeys: colorWithAlpha(theme.backgroundColor,0.3)

    property bool winner: false
    property bool endGame: false

    property int level: plasmoid.configuration.level

    property int gridUnit: PlasmaCore.Units.gridUnit ? PlasmaCore.Units.gridUnit : units.gridUnit
    property int smallSpacing: PlasmaCore.Units.smallSpacing ? PlasmaCore.Units.smallSpacing : units.smallSpacing
    property int largeSpacing: PlasmaCore.Units.largeSpacing ? PlasmaCore.Units.largeSpacing : units.largeSpacing


    property int _minimumWidth:  mainColumn.implicitWidth + smallSpacing
    property int _minimumHeight: mainColumn.implicitHeight + largeSpacing


    focus: true
    Layout.minimumWidth: _minimumWidth
    Layout.minimumHeight: _minimumHeight
    Layout.preferredWidth: _minimumWidth
    Layout.preferredHeight: _minimumHeight
    Layout.maximumWidth: _minimumWidth
    Layout.maximumHeight: _minimumHeight

    onLevelChanged: {
        clickNewWord()
    }

    onFocusChanged: { currentUiLabel.inFocus = true }
    onEndGameChanged: {
        if(endGame){
            messagesEndGame.text = winner ? 'YOU WIN' : 'GAME OVER'
            buttonNewWord.focus = true
        }
    }


    PlasmaExtras.Heading {
        id: dummyHeading
        visible: false
        width: 0
        level: 5
    }

    TextMetrics {
        id: headingMetrics
        font: dummyHeading.font
        text: "M"
    }

    function readTextFile(fileUrl,word){
        var xhr = new XMLHttpRequest;
        xhr.open("GET", fileUrl); // set Method and File
        xhr.onreadystatechange = function () {
            if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
                var response = xhr.responseText;
                let position = response.search(word);
                if(position === -1){
                    messagesLabel.text = 'Word does not exist in the list'
                }
                else{
                    currentUiLabel.evaluateWord(word_key)
                }
            }
        }
        xhr.send(); // begin the request
    }

    function colorizeKeyboard(list){
        keyboardLine1.colorize(list)
        keyboardLine2.colorize(list)
        keyboardLine3.colorize(list)
    }

    function getRandomInt(max) {
        return Math.floor(Math.random() * max);
    }


    function readTextFile2(fileUrl){
        var xhr = new XMLHttpRequest;
        xhr.open("GET", fileUrl); // set Method and File
        xhr.onreadystatechange = function () {
            if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
                var response = xhr.responseText;
                var lines = response.split("\n");
                word_key = lines[getRandomInt(lines.length)]
            }
        }
        xhr.send(); // begin the request
    }

    function getNewWord(level){
        readTextFile2("words/en_"+level+".txt")
    }

    function clickNewWord(){
        getNewWord(level)
        word_1.reset(level)
        word_2.reset(level)
        word_3.reset(level)
        word_4.reset(level)
        word_5.reset(level)
        word_6.reset(level)
        keyboardLine1.reset()
        keyboardLine2.reset()
        keyboardLine3.reset()
        endGame = false
        winner = false
        currentUiLabel = word_1
        word_1.inFocus = true
        messagesLabel.text = ''

    }

    function colorWithAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    ColumnLayout{
        id: mainColumn
        anchors.fill: parent
        spacing: 10

        RowLayout{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: gridUnit * 1.5
            height: gridUnit * 1.5
            PlasmaComponents3.ToolButton {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                icon.name:  'edit-delete'
                text:  ''
                flat: false
                onClicked:  {
                    if(!endGame) {
                        endGame = true
                        winner = false
                    }
                }
                ToolTip{
                    text: 'Surrender'
                }
            }
            Item { Layout.fillWidth: true}
            Text {
                text: 'W A R B L E'
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: theme.textColor
                font.pointSize : dummyHeading.font.pointSize + 3
                font.bold: true
            }
            Item { Layout.fillWidth: true}
            PlasmaComponents3.ToolButton {
                id: buttonNewWord
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                icon.name:  'view-refresh'
                text:  ''
                flat: false
                onClicked:  clickNewWord()
                ToolTip{
                    text: 'New word'
                }
            }
        }
        Rectangle{
            Layout.minimumWidth: parent.width*0.9
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            height: 1
            color: theme.textColor
            opacity: 0.5
        }
        Item {
            Layout.minimumHeight: smallSpacing
            Layout.minimumWidth:  smallSpacing
        }

        Word{
            id: word_1
            onPressKeyReturn: readTextFile("words/en_"+level+".txt",word)
            onEvaluateFinish: {
                colorizeKeyboard(model);
                if( word_key === word_1.labelText.toLowerCase()){
                    winner = true; word_1.focus = false; endGame = true;
                }else{
                    word_2.inFocus = true; currentUiLabel = word_2;
                }
            }
        }
        Word{
            id: word_2
            onPressKeyReturn: readTextFile("words/en_"+level+".txt",word)
            onEvaluateFinish: {
                colorizeKeyboard(model);
                if( word_key === word_2.labelText.toLowerCase()){
                    winner = true; word_2.focus = false; endGame = true;
                }else{
                    word_3.inFocus = true; currentUiLabel = word_3;
                }
            }
        }
        Word{
            id: word_3
            onPressKeyReturn: readTextFile("words/en_"+level+".txt",word)
            onEvaluateFinish: {
                colorizeKeyboard(model);
                if( word_key === word_3.labelText.toLowerCase()){
                    winner = true; word_3.focus = false; endGame = true;
                }else{
                    word_4.inFocus = true; currentUiLabel = word_4;
                }
            }
        }
        Word{
            id: word_4
            onPressKeyReturn: readTextFile("words/en_"+level+".txt",word)
            onEvaluateFinish: {
                colorizeKeyboard(model);
                if( word_key === word_4.labelText.toLowerCase()){
                    winner = true; word_4.focus = false; endGame = true;
                }else{
                    word_5.inFocus = true; currentUiLabel = word_5;
                }
            }
        }
        Word{
            id: word_5
            onPressKeyReturn: readTextFile("words/en_"+level+".txt",word)
            onEvaluateFinish: {
                colorizeKeyboard(model);
                if( word_key === word_5.labelText.toLowerCase()){
                    winner = true; word_5.focus = false; endGame = true;
                }else{
                    word_6.inFocus = true; currentUiLabel = word_6;
                }
            }
        }
        Word{
            id: word_6
            onPressKeyReturn: readTextFile("words/en_"+level+".txt",word)
            onEvaluateFinish: {
                colorizeKeyboard(model);
                if( word_key === word_6.labelText.toLowerCase()){
                    winner = true; word_6.focus = false; endGame = true;
                }else{
                    endGame = true
                }
            }
        }

        Item {
            Layout.minimumHeight: largeSpacing
            Layout.minimumWidth:  largeSpacing
        }

        KeyboardKey{
            id: keyboardLine1
            listLetters: ['Q','W','E','R','T','Y','U','I','O','P']
            onClick: if(!endGame)currentUiLabel.receive(aKey)
        }
        KeyboardKey{
            id: keyboardLine2
            listLetters: ['A','S','D','F','G','H','J','K','L']
            onClick: if(!endGame)currentUiLabel.receive(aKey)
        }
        KeyboardKey{
            id: keyboardLine3
            listLetters: ['Enter','Z','X','C','V','B','N','M','Back']
            onClick: if(!endGame)currentUiLabel.receive(aKey)
        }

        Item {
            Layout.fillHeight: true
        }
    }

    Rectangle{
        id: banner
        anchors.centerIn: parent
        width: parent.width - largeSpacing * 4
        height: gridUnit  * 5
        color:  colorWithAlpha(theme.highlightColor,0.9)
        border.color: theme.highlightColor
        border.width: 2
        opacity: 0
        radius: 6
        visible: messagesLabel.text !== ''

        Label{
            id: messagesLabel
            anchors.centerIn: parent
            text: ''
            color: theme.backgroundColor
            font.pointSize : dummyHeading.font.pointSize + 3
            font.bold: true
            onTextChanged: {if(text !== '') bannerAnimation.start()}
        }

        SequentialAnimation{
            id: bannerAnimation
            OpacityAnimator{
                target: banner
                from: 0
                to: 1
                duration: 500

            }
            PauseAnimation {
                duration: 1000
            }
            OpacityAnimator{
                target: banner
                from: 1
                to: 0
                duration: 500
            }
            onFinished: messagesLabel.text = ''
        }
    }


    Rectangle{
        id: bannerEndGame
        anchors.centerIn: parent
        width: parent.width - largeSpacing * 4
        height: gridUnit  * 5
        color: colorWithAlpha(theme.highlightColor,0.9)
        border.color: theme.highlightColor
        border.width: 2
        radius: 6
        visible: endGame

        Label{
            id: messagesEndGame
            anchors.centerIn: parent
            anchors.verticalCenterOffset: - gridUnit
            text: ''
            color: theme.backgroundColor
            font.pointSize : dummyHeading.font.pointSize + 3
            font.bold: true
        }

        Label {
            text: word_key
            color: theme.backgroundColor
            anchors.centerIn: parent
            anchors.verticalCenterOffset: + gridUnit
            font.pointSize : dummyHeading.font.pointSize + 5
            font.capitalization: Font.AllUppercase
            font.bold: true
        }
    }
    Component.onCompleted: {
        clickNewWord()
    }
}


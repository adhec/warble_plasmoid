import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1


Item {
    id: word
    signal pressKeyReturn(string word)
    signal evaluateFinish(var model)
    signal clickRect()

    height: label.contentHeight + largeSpacing
    width: parent.width

    property alias inFocus: label.focus
    property alias labelText: label.text
    property int currentLevel


    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    function evaluateWord(word_key){
        word_key = word_key.toUpperCase()
        labelText = labelText.toUpperCase()
        for(var i= 0 ; i < labelText.length; i++){
            if(word_key[i] === labelText[i])
                letter_1_model.set(i,{letter: labelText[i].toUpperCase(), colorState: 'G'})
            else if(word_key.indexOf(labelText[i]) > -1)
                letter_1_model.set(i,{letter: labelText[i].toUpperCase(), colorState: 'Y'})
            else
                letter_1_model.set(i,{letter: labelText[i].toUpperCase(), colorState: 'E'})
        }
        word.evaluateFinish(letter_1_model)
    }

    function receive( aKey){
        if(aKey.length === 1)
            labelText += aKey.toUpperCase()
        else{
            if(aKey === 'Enter'){
                if (labelText.length === currentLevel){
                    word.pressKeyReturn(labelText.toLowerCase())
                }
            }
            else if(aKey === 'Back'){
                labelText = labelText.slice(0, -1);
            }
        }
    }

    function reset(level){
        label.text = ''
        currentLevel = level
        letter_1_model.clear()
        for(var i = 0 ; i < level ; i++)
            letter_1_model.append({letter: '' , colorState: 'W'})
    }

    TextInput{
        id: label
        visible: false
        text: ''
        font.pointSize : dummyHeading.font.pointSize + 3
        font.capitalization: Font.AllUppercase
        validator: RegExpValidator{regExp: /^[a-zA-Z/]+$/}
        maximumLength: currentLevel
        Keys.onPressed: {
            if (event.key === Qt.Key_Space || event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab ){
                event.accepted = true;
            } else if (event.key == Qt.Key_Right || event.key == Qt.Key_Left) {
                event.accepted = true;
            } else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                if (text.length === currentLevel){
                    word.pressKeyReturn(text.toLowerCase())
                }
            }
        }
        onTextChanged: {
            var i = 0
            while(i < text.length){
                letter_1_model.set(i,{letter: text[i].toUpperCase(), colorState: 'W'})
                i++
            }
            while(i < currentLevel){
                letter_1_model.set(i,{letter: '', colorState: 'W'})
                i++
            }
        }
    }

    ListModel {  id: letter_1_model }

    Row{
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: smallSpacing
        Repeater{
            id: _repeater
            model: letter_1_model

            Rectangle{
                width: character.contentHeight + largeSpacing
                height: width
                border.width: 1
                border.color: {
                    if(colorState === 'W') return '#aaaaaa'
                    else if (colorState === 'Y') return '#d5ba59'
                    else if (colorState === 'G') return '#689334'
                    else return '#78797a'
                }
                color: {
                    if(colorState === 'W') return _white
                    else if (colorState === 'Y') return _yellow
                    else if (colorState === 'G') return _green
                    else return _error

                }
                radius: 3

                Label{
                    id: character
                    anchors.centerIn: parent
                    font.pointSize : dummyHeading.font.pointSize + 3
                    font.bold: true
                    color: colorState !== 'W' ? '#000000' : theme.textColor
                    text: letter
                    onTextChanged:{
                        animationRect.start()
                    }
                }
                ScaleAnimator{
                    id: animationRect
                    target: character
                    from: 0
                    to: 1
                }
                TapHandler {
                    onTapped: word.clickRect()
                }
            }
        }
    }



}


import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1
import QtGraphicalEffects 1.12


Item {
    id: lineKeys

    width: (headingMetrics.width + 2 * largeSpacing) * listLetters.length
    height: headingMetrics.height +    smallSpacing*2

    property var listLetters

    signal click( string aKey)

    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

    ListModel {
        id: letters_model

    }

    onListLettersChanged: {
        for(var i = 0 ; i<listLetters.length; i++){
            letters_model.append({letter: listLetters[i], colorState: 'W'})
        }
    }

    function reset(){
        for(var i = 0 ; i<listLetters.length; i++){
            letters_model.set(i,{letter: listLetters[i], colorState: 'W'})
        }
    }

    function colorize(list){
        var letter
        for(var i= 0 ; i < list.count; i++){
            letter = list.get(i).letter
            for( var j = 0 ; j < listLetters.length ; j++){
                if(letter  === listLetters[j]){
                    switch(letters_model.get(j).colorState){
                    case  'W' : letters_model.set(j,{letter: letter, colorState: list.get(i).colorState}); break;
                    case  'E' : letters_model.set(j,{letter: letter, colorState: list.get(i).colorState}); break;
                    case  'Y' : if(list.get(i).colorState === 'G') letters_model.set(j,{letter: letter, colorState: 'G'}); break;
                    }
                }
            }
        }

    }

    Row{
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5
        Repeater{
            id: _repeater
            model: letters_model

            Rectangle{
                id: delegate
                width:  headingMetrics.width * character.text.length + largeSpacing
                height: headingMetrics.height + smallSpacing*2
                color: colorWithAlpha(theme.textColor,0.3)
                radius: 3
                border.color: "#dcdcdc"
                border.width: 1

                TapHandler {
                    onTapped: lineKeys.click(letter)
                }

                Rectangle{

                    width: parent.width
                    height: parent.height-2
                    anchors.top: parent.top
                    border.color: "#88222222"
                    border.width: 1
                    radius: 3

                    color: {
                        if(colorState === 'W') return _white
                        else if (colorState === 'Y') return _yellow
                        else if (colorState === 'G') return _green
                        else return _error
                    }

                    onColorChanged: {
                        animationRect.start()

                    }
                    Label{
                        id: character
                        anchors.centerIn: parent
                        text: letter
                        color: colorState !== 'W' ? '#000000' : theme.textColor

                    }
                }
                ScaleAnimator{
                    id: animationRect
                    target: delegate
                    from: 1.2
                    to: 1
                    duration: 500
                }

            }
        }
    }
}


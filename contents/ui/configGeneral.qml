import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

ScrollView {
    id: scrollView
    
    property alias cfg_use24Hour: use24Hour.checked
    property alias cfg_showDate: showDate.checked
    property string cfg_timeFontFamily
    property alias cfg_timeFontSize: timeFontSize.value
    property alias cfg_timeFontItalic: timeFontItalic.checked
    property string cfg_dateFontFamily
    property alias cfg_dateFontSize: dateFontSize.value
    property alias cfg_dateFontItalic: dateFontItalic.checked
    property alias cfg_uppercaseDate: uppercaseDate.checked
    property alias cfg_useShortDate: useShortDate.checked
    property alias cfg_textAlignment: textAlignment.currentIndex
    property alias cfg_dropShadow: dropShadow.checked
    property string cfg_timeColor
    property string cfg_dateColor
    property string cfg_shadowColor
    
    Kirigami.FormLayout {
        id: configRoot
    
    CheckBox {
        id: use24Hour
        Kirigami.FormData.label: "Time Format:"
        text: "Use 24-hour format"
    }
    
    CheckBox {
        id: showDate
        text: "Show date"
    }
    
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Time Font"
    }
    
    ComboBox {
        id: timeFontFamily
        Kirigami.FormData.label: "Font Family:"
        Layout.fillWidth: true
        model: Qt.fontFamilies()
        editable: true
        
        onModelChanged: {
            currentIndex = find(cfg_timeFontFamily)
        }
        
        onCurrentTextChanged: {
            cfg_timeFontFamily = currentText
        }
        
        Component.onCompleted: {
            currentIndex = find(cfg_timeFontFamily)
        }
    }
    
    SpinBox {
        id: timeFontSize
        Kirigami.FormData.label: "Font Size:"
        from: 12
        to: 200
        stepSize: 1
    }
    
    CheckBox {
        id: timeFontItalic
        Kirigami.FormData.label: "Font Style:"
        text: "Italic"
    }
    
    RowLayout {
        Kirigami.FormData.label: "Time Color:"
        
        Rectangle {
            width: 40
            height: 25
            color: cfg_timeColor
            border.color: "gray"
            border.width: 1
            
            MouseArea {
                anchors.fill: parent
                onClicked: timeColorDialog.open()
            }
        }
        
        Label {
            text: cfg_timeColor
        }
    }
    
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Date Font"
    }
    
    ComboBox {
        id: dateFontFamily
        Kirigami.FormData.label: "Font Family:"
        enabled: showDate.checked
        Layout.fillWidth: true
        model: Qt.fontFamilies()
        editable: true
        
        onModelChanged: {
            currentIndex = find(cfg_dateFontFamily)
        }
        
        onCurrentTextChanged: {
            cfg_dateFontFamily = currentText
        }
        
        Component.onCompleted: {
            currentIndex = find(cfg_dateFontFamily)
        }
    }
    
    SpinBox {
        id: dateFontSize
        Kirigami.FormData.label: "Font Size:"
        enabled: showDate.checked
        from: 12
        to: 200
        stepSize: 1
    }
    
    CheckBox {
        id: dateFontItalic
        Kirigami.FormData.label: "Font Style:"
        enabled: showDate.checked
        text: "Italic"
    }
    
    CheckBox {
        id: uppercaseDate
        enabled: showDate.checked
        text: "Uppercase date"
    }
    
    CheckBox {
        id: useShortDate
        enabled: showDate.checked
        text: "Use short date"
    }
    
    RowLayout {
        Kirigami.FormData.label: "Date Color:"
        enabled: showDate.checked
        
        Rectangle {
            width: 40
            height: 25
            color: cfg_dateColor
            border.color: "gray"
            border.width: 1
            
            MouseArea {
                anchors.fill: parent
                onClicked: dateColorDialog.open()
            }
        }
        
        Label {
            text: cfg_dateColor
        }
    }
    
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "General"
    }
    
    ComboBox {
        id: textAlignment
        Kirigami.FormData.label: "Text Alignment:"
        model: ["Left", "Center", "Right"]
    }
    
    CheckBox {
        id: dropShadow
        Kirigami.FormData.label: "Drop Shadow:"
        text: "Enable drop shadow"
    }
    
    RowLayout {
        Kirigami.FormData.label: "Shadow Color:"
        enabled: dropShadow.checked
        
        Rectangle {
            width: 40
            height: 25
            color: cfg_shadowColor
            border.color: "gray"
            border.width: 1
            
            MouseArea {
                anchors.fill: parent
                onClicked: shadowColorDialog.open()
            }
        }
        
        Label {
            text: cfg_shadowColor
        }
    }
    
    ColorDialog {
        id: timeColorDialog
        title: "Choose Time Color"
        selectedColor: cfg_timeColor
        onAccepted: {
            cfg_timeColor = timeColorDialog.selectedColor
        }
    }
    
    ColorDialog {
        id: dateColorDialog
        title: "Choose Date Color"
        selectedColor: cfg_dateColor
        onAccepted: {
            cfg_dateColor = dateColorDialog.selectedColor
        }
    }
    
    ColorDialog {
        id: shadowColorDialog
        title: "Choose Shadow Color"
        selectedColor: cfg_shadowColor
        onAccepted: {
            cfg_shadowColor = shadowColorDialog.selectedColor
        }
    }
    }
}

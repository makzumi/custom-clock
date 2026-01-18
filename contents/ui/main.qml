import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    
    property string timeFormat: plasmoid.configuration.use24Hour ? "H:mm" : (plasmoid.configuration.uppercaseTime ? "h:mm AP" : "h:mm ap")
    property string dateFormat: plasmoid.configuration.useShortDate ? "M/d/yyyy" : "dddd, MMMM d, yyyy"
    
    width: Kirigami.Units.gridUnit * 10
    height: Kirigami.Units.gridUnit * 6
    
    property string currentTime: ""
    property string currentDate: ""
    
    fullRepresentation: Item {
        anchors.fill: parent
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            
            Text {
                id: timeText
                Layout.fillHeight: true
                Layout.alignment: {
                    var align = plasmoid.configuration.textAlignment
                    if (align === 0) return Qt.AlignLeft | Qt.AlignVCenter
                    if (align === 2) return Qt.AlignRight | Qt.AlignVCenter
                    return Qt.AlignHCenter | Qt.AlignVCenter
                }
                text: root.currentTime
                
                font.family: plasmoid.configuration.timeFontFamily || "Sans Serif"
                font.pixelSize: plasmoid.configuration.timeFontSize || 48
                font.italic: plasmoid.configuration.timeFontItalic || false
                
                color: plasmoid.configuration.timeColor || Kirigami.Theme.textColor
                
                layer.enabled: plasmoid.configuration.dropShadow || false
                layer.effect: DropShadow {
                    color: plasmoid.configuration.shadowColor || "#000000"
                    radius: 8
                    samples: 17
                }
            }
            
            Text {
                id: dateText
                visible: plasmoid.configuration.showDate !== false
                Layout.fillHeight: true
                Layout.alignment: {
                    var align = plasmoid.configuration.textAlignment
                    if (align === 0) return Qt.AlignLeft | Qt.AlignVCenter
                    if (align === 2) return Qt.AlignRight | Qt.AlignVCenter
                    return Qt.AlignHCenter | Qt.AlignVCenter
                }
                text: root.currentDate
                
                font.family: plasmoid.configuration.dateFontFamily || "Sans Serif"
                font.pixelSize: plasmoid.configuration.dateFontSize || 20
                font.italic: plasmoid.configuration.dateFontItalic || false
                
                color: plasmoid.configuration.dateColor || Kirigami.Theme.textColor
                
                layer.enabled: plasmoid.configuration.dropShadow || false
                layer.effect: DropShadow {
                    color: plasmoid.configuration.shadowColor || "#000000"
                    radius: 8
                    samples: 17
                }
            }
        }
    }
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: updateTime()
    }
    
    function updateTime() {
        var now = new Date()
        root.currentTime = Qt.formatDateTime(now, root.timeFormat)
        var formattedDate = Qt.formatDateTime(now, root.dateFormat)
        root.currentDate = plasmoid.configuration.uppercaseDate ? formattedDate.toUpperCase() : formattedDate
    }
    
    Component.onCompleted: updateTime()
}

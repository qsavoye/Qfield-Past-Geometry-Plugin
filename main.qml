import QtQuick
import QtQuick.Controls

import org.qfield
import org.qgis
import Theme

import "qrc:/qml" as QFieldItems

Item {
  id: plugin

  property var mainWindow: iface.mainWindow()
  property var dashBoard: iface.findItemByObjectName('dashBoard')
  property var overlayFeatureFormDrawer: iface.findItemByObjectName('overlayFeatureFormDrawer')

  Component.onCompleted: {
    iface.findItemByObjectName('canvasMenu').addItem(pastButton)
  }

  MenuItem {
    id: pastButton
    text: qsTr( "Past Feature Into Current Layer" )
    icon.source: Theme.getThemeVectorIcon('ic_paste_black_24dp')
    enabled: dashBoard.activeLayer.type == 0 && clipboardManager && clipboardManager.holdsFeature
    height: 48
    leftPadding: 10
    font: Theme.defaultFont

    onTriggered: {
      past()
    }
  }

  function past()
  {
    let featureFromPastFeature = clipboardManager.pasteFeatureFromClipboard()
    let feature = FeatureUtils.createFeature(dashBoard.activeLayer, featureFromPastFeature.geometry)
    overlayFeatureFormDrawer.featureModel.feature = feature
    overlayFeatureFormDrawer.featureModel.resetAttributes(true)
    overlayFeatureFormDrawer.state = 'Add'
    overlayFeatureFormDrawer.open()
  }
}
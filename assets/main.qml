/* Copyright (c) 2012, 2013  BlackBerry Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import bb.cascades 1.3
import bb.platform 1.0
import bb.system 1.0
import CustomTimer 1.0
import bb.device 1.3

Page {
    
    id: rootPage
    property string tname : ""
    Menu.definition: MenuDefinition {
  //      settingsAction: SettingsActionItem {
 //          onTriggered: {
 //               
 //           }
//        }
        helpAction: HelpActionItem {
            onTriggered: {
               helpDiag.show()
            } }
        // Specify the actions that should be included in the menu
        actions: [
            ActionItem {
                title: "Task Name"
                imageSource: "images/setTn.png"
                onTriggered: {
                    //root.taskName = "Action 1 selected!"
                    tnSetDiag.show()
                    //root.taskName = tasknamelbl.text.split(" - ", 2)[0];
                }
            }
        ] // end of actions list
    } // end of MenuDefinition    
    Container {
        id: root
        layout: DockLayout {}
        
        property int workTimeLen: 25*60
        property int workTimeCnt: workTimeLen
        
        property int stage : 1 
        property int state : 1 // 0 stop; 1 work; 2 shortbreak; 3 long break
        
        property int shortBreakLen : 5*60
        property int shortBreakCnt : shortBreakLen
        
        property int longBreakLen : 20*60
        property int longBreakCnt : longBreakLen
        
        property string taskName : "Tomato"
        
        property int cycleCnt : 0
        Timer {
            id: tomatoTimer
            // Specify a timeout interval of 1 second
            interval: 1000
            visible: false
            onTimeout: {
                root.cycleCnt = root.cycleCnt + 1;
                progressbar.value = root.cycleCnt / (root.workTimeLen * 4 + root.shortBreakLen * 3 + root.longBreakLen)
                if (root.state == 1){
                    root.workTimeCnt = root.workTimeCnt - 1;
                    if (root.workTimeCnt == 0){
                        if (root.stage == 3){
                            root.state = 3;
                            root.longBreakCnt = root.longBreakLen;
                            tasknamelbl.text = tasknamelbl.text.split(" - ", 2)[0] + " - Long Break "
                            notificationDialog.title = "Long Break"
                            notificationDialog.show()
                        }
                        else {
                            root.state = 2;
                            root.shortBreakCnt = root.shortBreakLen;
                            tasknamelbl.text = tasknamelbl.text.split(" - ", 2)[0] + " - Short Break "
                            notificationDialog.title = "Short Break"
                            notificationDialog.body = "Short Break at " + Qt.formatDateTime (new Date(), "dd/MM/yyyy  hh : mm : ss a");
                            notificationDialog.show()
                        }
                    }
                    lefttime.text = "" + parseInt(root.workTimeCnt / 60, 10) + " : " + root.workTimeCnt % 60;
                }
                else if (root.state == 2){
                    root.shortBreakCnt = root.shortBreakCnt - 1;
                    if (root.shortBreakCnt == 0){
                        root.workTimeCnt = root.workTimeLen;
                        root.state = 1;
                        root.stage = root.stage + 1;
                        tasknamelbl.text = tasknamelbl.text.split(" - ", 2)[0] + " - Stage " + root.stage
                        notificationDialog.title = "Time to Work Now"
                        notificationDialog.body = "Start Stage " + root.stage + " at " + Qt.formatDateTime (new Date(), "dd/MM/yyyy  hh : mm : ss a");
                        notificationDialog.show()                        
                    }
                    lefttime.text = "" + parseInt(root.shortBreakCnt / 60, 10) + " : " + root.shortBreakCnt % 60;
                }
                else{
                    root.longBreakCnt = root.longBreakCnt - 1;
                    if (root.longBreakCnt == 0){
                        root.workTimeCnt = root.workTimeLen;
                        root.state = 1;
                        root.stage = 1;
                        tasknamelbl.text = tasknamelbl.text.split(" - ", 2)[0] + " - Stage " + root.stage
                        notificationDialog.title = "Time to Work Now"
                        notificationDialog.body = "Start a new cycle at " + Qt.formatDateTime (new Date(), "dd/MM/yyyy  hh : mm : ss a");
                        notificationDialog.show()                 
                        progressbar.value = 0         
                        root.cycleCnt = 0;  
                    }   
                    lefttime.text = "" + parseInt(root.longBreakCnt / 60, 10) + " : " + root.longBreakCnt % 60;                 
                }
            } // end of onTimeout signal handler
        } // end of Timer

        Label {
            // Localized text with the dynamic translation and locale updates support
            id: tasknamelbl
            text: root.taskName + ""
            //text: displayInfo.pixelSize.height + "x" + displayInfo.pixelSize.width
            textStyle.base: SystemDefaults.TextStyles.BigText
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Center
            multiline: true
        }
        Label {
            // Localized text with the dynamic translation and locale updates support
            id: lefttime
            text: "" + parseInt(root.workTimeCnt / 60, 10) + " : " + root.workTimeCnt % 60
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.color: Color.Blue
            textStyle.fontWeight: FontWeight.Bold
            
            textFit.minFontSizeValue: displayInfo.pixelSize.width / 44.8 + 22.85
            textFit.maxFontSizeValue: 80.0

        }

        Container {
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: horizontalAlignment.Center
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Button {
                text: "Start"
                id: btnStart
                horizontalAlignment: HorizontalAlignment.Left
                color: Color.Green
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                onClicked: {
                    //root.background = Color.Red
                    //notificationDialog.show()
                    tomatoTimer.start();
                    tasknamelbl.text = tasknamelbl.text.split(" - ", 2)[0] + " - Stage " + root.stage
                }

            }
            Button {
                text: "Stop"
                id: btnStop
                horizontalAlignment: HorizontalAlignment.Center
                color: Color.Red
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                onClicked: {
                    tomatoTimer.stop();
                }
            }

            Button {
                text: "Reset"
                id: btnReset
                horizontalAlignment: HorizontalAlignment.Right
                color: Color.Gray
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                onClicked: {
                    root.workTimeCnt = root.workTimeLen;
                    root.stage = 1;
                    root.state = 1;
                    lefttime.text = "" + parseInt(root.workTimeCnt / 60, 10) + " : " + root.workTimeCnt % 60;
                    tomatoTimer.stop();
                    progressbar.value = 0
                    root.cycleCnt = 0
                }
                scaleX: 1.0
            }
        }

        //! [3]
        attachedObjects: [
            Notification {
                id: notification
                title: qsTr("TITLE")
                body: qsTr("BODY")
                //                soundUrl: _publicDir + "system_battery_low.wav"
            },
            NotificationDialog {
                id: notificationDialog
                title: qsTr("TITLE")
                body: qsTr("BODY")
                //              repeat : true
                //              soundUrl: _publicDir + "system_battery_low.wav"
                buttons: [
                    SystemUiButton {
                        label: qsTr("Okay")
                    }
                ]
                onFinished: {
                    console.log("Result: " + result);
                    console.log("Error: " + error);
                }
            },
            DisplayInfo {
                id: displayInfo
            },
            SystemPrompt {
                title: "Set Task Name"
                id: tnSetDiag
                onFinished: {
                    switch (value) {
                        case (SystemUiResult.ConfirmButtonSelection):
                            var tempTn = tnSetDiag.inputFieldTextEntry();
                            var oldLb = tasknamelbl.text;
                            tasknamelbl.text = oldLb.replace(tasknamelbl.text.split(" - ", 2)[0], tempTn);
                            break;
                        case (SystemUiResult.CancelButtonSelection):
                            break;
                        default:
                            break;
                    }
                }
            },
            SystemDialog {
                title: "Help"
                id: helpDiag
                body: "1. Decide on the task to be done (set task name);\n \
                2. Set the pomodoro timer to n minutes (default set as 25), \
                set short break time (4 minutes by default) and long break time \
                (20 minutes by default) length.\n3. Work on the task until the timer rings;\n \
                4. Take a short break (3–5 minutes) and return to step 3 when timer rings;\n \
                5. After four pomodori, take a longer break (15–30 minutes), returned step 3 when times rings.\n\n \
                In one word, just click start and start to work!"
            }
        ]

        background: Color.Black
        ProgressIndicator {
            id: progressbar
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            state: ProgressIndicatorState.Progress
            toValue: 1.0
            scaleX: 1.0
        }
        //! [3]
    }
}

pragma ComponentBehavior: Bound

import qs.qd.Widgets as W
import qs.qd
import QtQuick
import Quickshell.Io

Dashboard {

    name: 'main'

    W.Calendar {
        // variant: W.Base.VariantCompact
    }

    W.Memory {
    }

    W.CPU {
    }

    W.Network {
    }

    W.Disk {
    }

    W.AIUsageLimits {
    }

    W.Media {
    }

    W.Separator {
    }

    W.Buttons {
        id: b

        buttons: [
            {
                icon: 'frame_inspect',
                command: 'T="$(mktemp)"; hyprprop >"$T" && alacritty -e fx "$T" || true; rm -f "$T"',
                detached: true,
            },
            {
                icon: 'draw_abstract',
                command: 'wayscriber --active',
            },
            {
                icon: 'preview',
                action: 'switch_demo_mode',
            },
            {
                icon: 'screen_record',
                action: 'switch_screen_recording',
            },
        ]

        onActionRequested: (button) => {
            if (button.action === 'switch_demo_mode') {
                Settings.isDemo = !Settings.isDemo
                button.isActive = Settings.isDemo
            } else if (button.action === 'switch_screen_recording') {
                if (screenRecorderProc.running) {
                    screenRecorderProc.running = false
                } else {
                    const currentDate = new Date()
                    const formattedDate = Qt.formatDateTime(currentDate, 'yyyy-MM-dd_hh-mm-ss')
                    screenRecorderProc.filename = 'screencast_' + formattedDate + '.mp4'
                    screenRecorderProc.recordButton = button
                    screenRecorderProc.running = true
                }
                button.isActive = screenRecorderProc.running
            }
        }

        Process {
            id: screenRecorderProc

            property var recordButton
            property string filename: 'screencast-tmp'

            running: false
            command: ["sh", "-c", `wf-recorder -f ~/ScreenRecordings/"${filename}" -c libx264 -p pix_fmt=yuv420p -p profile=main -p preset=fast --output "eDP-1"`]
            // qmllint disable signal-handler-parameters
            onExited: (exitCode, _) => {
            // qmllint enable signal-handler-parameters
                if (exitCode !== 0) {
                    console.warn('[screenRecorderProc]', 'command exited with code:', exitCode,
                        '; command:', command)
                }
                recordButton.isActive = false
            }
        }

    }

    W.AudioVolume {
    }

    W.Clock {
    }

}

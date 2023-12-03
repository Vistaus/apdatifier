import QtQuick 2.5
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmaCore.DataSource {
	id: executable
	engine: "executable"
	connectedSources: []
	onNewData: (sourceName, data) => {
		var cmd = sourceName
		var stdout = data["stdout"]
		var stderr = data["stderr"]
		var exitCode = data["exit code"]
		var listener = listeners[cmd]

		if (listener) {
			listener(cmd, stdout, stderr, exitCode)
		}

		exited(cmd, stdout, stderr, exitCode)
		disconnectSource(sourceName)
	}

	signal exited(string cmd, string stdout, string stderr, int exitCode)

	function exec(cmd, callback) {
		listeners[cmd] = execCallback.bind(executable, callback)
		connectSource(cmd)
	}

	function execCallback(callback, cmd, stdout, stderr, exitCode) {
		delete listeners[cmd]
		callback(cmd, stdout, stderr, exitCode)
	}
}

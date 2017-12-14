from appJar import gui
from pathlib import Path
import json
import re

"""
Choose the directory
"""
def getDirectory(button):
	directorySelected = app.directoryBox()

	if button == "button_path_install":
		app.setEntry("path_install", directorySelected)
	else:
		app.setEntry("path_copy", directorySelected)

"""
Generate the config file
"""
def generateFile(button):
	if(validateData()):
		file = open("config","w")
		file.write(createJSONStructure())
		file.close()

		app.infoBox("Información", "Archivo generado.")
	else:
		app.errorBox("Validación", "Todos los datos son requeridos.")


"""
"""
def validateData():
	validated = True

	if (app.getEntry("path_install") == "" or app.getEntry("path_copy") == "" or app.getEntry("upload_path") == "" or app.getEntry("path_folder_base") == ""):
		validated = False

	return validated


"""
Create the json structure to the file
return json
"""
def createJSONStructure():
	jsonObject = {}

	jsonObject["path_install"] = re.escape(app.getEntry("path_install"))
	jsonObject["path_copy"] = re.escape(app.getEntry("path_copy"))
	jsonObject["upload_path"] = re.escape(app.getEntry("upload_path"))
	jsonObject["data_base_folder"] = re.escape(app.getEntry("path_folder_base"))

	return json.dumps(jsonObject)

"""
Load json config file to text control
"""
def loadDataFromJSONFile():
	jsonString = readFile()

	if(jsonString != ""):
		jsonObject = json.loads(jsonString)

		app.setEntry("path_install", jsonObject["path_install"])
		app.setEntry("path_copy", jsonObject["path_copy"])
		app.setEntry("upload_path", jsonObject["upload_path"])
		app.setEntry("path_folder_base", jsonObject["data_base_folder"])

"""
Read json config file
"""
def readFile():
	jsonString = ""

	if(Path("config").is_file()):
		file  = open("config", "r")
		jsonString = file.read()
		file.close()

	return jsonString

"""
GUI
"""

TYPE_FONT = "Times"

app = gui()

# Configuration of the window
app.setTitle("SystemBackup")
app.setResizable(canResize=False)
app.setFont(11, font = TYPE_FONT)

app.setPadding([3,3])

# path_install controls
app.addLabel("label_path_install", "Directorio instalación Bu$inessPro")
app.setLabelAlign("label_path_install", "left")

currentRow = app.getRow()
app.addEntry("path_install", currentRow, 0)
app.addNamedButton("...", "button_path_install", getDirectory, currentRow, 1)

# path_copy controls
app.addLabel("label_path_copy", "Directorio de copia")
app.setLabelAlign("label_path_copy", "left")

currentRow = app.getRow()
app.addEntry("path_copy", currentRow, 0)
app.addNamedButton("...", "button_path_copy", getDirectory, currentRow, 1)

# upload_path controls
app.addLabel("label_upload_path", "Directorio de carga")
app.setLabelAlign("label_upload_path", "left")
app.addEntry("upload_path", 5, 0, 2, 0)

# folder_base controls
app.addLabel("label_folder_base", "Nombre directorio de datos Bu$inessPro")
app.setLabelAlign("label_folder_base", "left")
app.addEntry("path_folder_base", 7, 0, 2, 0)

# generate button
app.addNamedButton("Generar configuración", "button_generate", generateFile, 8, 0, 2, 0)

# Load data from json config
loadDataFromJSONFile()

app.go()
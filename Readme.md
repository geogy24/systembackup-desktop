# Requerimientos
- ruby 2.3.3
- python 3.6.2
- RAR versión gratuita o superior

## Gemas
- ocra
- net-sftp
- rest-client

## Package
- pip
- dbf
- pyinstaller 3.3 [pip install --upgrade pyinstaller]

# Compilación Ruby
ocra Index.rb --verbose --add-all-core

# Compilación python
En usuario administrador
pyinstaller -F reminder.py

## Instalación
Debe agregarse en una variable de entorno de WINDOWS el PATH donde se encuentre el archivo rar.exe quien es el encargado de comprimir los archivos.

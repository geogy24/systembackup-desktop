"""
This file insert a message at the table recordat.dbf
for reminders
"""
import sys
import time
import datetime

from dbf import VfpTable, RecordVaporWare, Date, DateTime, IndexFile

"""
Get a user of the database
"""
def get_user(routeFile, folder):
	user = ''
	name = routeFile + '\\' + folder + '\\datos\\usuarios.DBF'

	table = VfpTable(name)
	table.use_deleted = False
	table.open()

	if not table.eof:
		user = table.last_record[1]

	table.close()

	return user

"""
Execute app
"""
if sys.argv[1] and sys.argv[2] and sys.argv[3]:
	routeFile = sys.argv[1]
	folder = sys.argv[2]
	message = sys.argv[3]

	if isinstance(routeFile, str) and isinstance(folder, str) and isinstance(message, str):
		user = get_user(routeFile, folder)

		if user:
			name = routeFile + '\\RECORDAT.DBF'
			code = 1

			table = VfpTable(name)
			table.use_deleted = False
			table.open()

			if not table.eof:
				code = int(table.last_record[0]) + 1

			table.append((	code,
							Date().today(),
							message,
							0, 
							'',
							'',
							0, 
							user,
							DateTime().now()))

			table.close()

			print('!Completado¡')
		else:
			print('Error: No se ha encontrado un usuario en la base de datos.')
	else:
		print('Error: Los datos recibidos no son del tipo requerido [cadena].')
else:
	print('Error: Faltan parametros para ejecutar el programa.')
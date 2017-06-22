require 'rest-client'
require 'json'
require_relative '../config/Config'

class Log

	attr_accessor :businessName

	def initialize (pathBusiness)
		arrayPathBusiness = pathBusiness.split('/')
		@businessName = arrayPathBusiness[arrayPathBusiness.length - 1]
	end

	################################################
	# Send log to the server where I can administrate
	# and known if the copy is ok
	################################################
	def sendLog (title, description, typeLog = 'information', counter = 0)
		if (counter < 3)
			response = RestClient.get 'https://#{Config::HOST}/api/log/create', {params: {'businessName' => @businessName, 'typeLog' => typeLog, 'title' => title, 'description' => description}}

			if (response.code == 200)
				json = JSON.parse(response.body)

				if (json['created'] == false)
					counter+=1
					sendLog(title, description, typeLog, counter)
				else
					print "#{title} - #{description} \n\n"
				end
			else
				counter+=1
				sendLog(title, description, typeLog, counter)
			end
		end
	end
end
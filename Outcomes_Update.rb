require 'csv'
require 'typhoeus'
require 'json'
#------------------Replace these values-----------------------------#

access_token = ''
url = '' #Enter the full URL to the domain you want to merge files.


#-------------------Do not edit below this line---------------------#
# First column is user account that will be merged into second column. #
unless Typhoeus.get(url).code == 200 || 302
	raise 'Unable to run script, please check token, and/or URL.'
end


	hydra = Typhoeus::Hydra.new(max_concurrency: 20)

for i in 1..3384 do # you may need to change this depending on if there are pre-existing outcomes in Canvas before you did the outcomes import. This script is pretty basic and has no logic to detect which outcomes are what. 

	api_call = "#{url}/api/v1/outcomes/#{i}?ratings[][description]=A&ratings[][points]=5&ratings[][description]=B&ratings[][points]=4&ratings[][description]=C&ratings[][points]=3&ratings[][description]=D&ratings[][points]=2&ratings[][description]=E&ratings[][points]=1"

		outcomes_api = Typhoeus::Request.new(api_call, 
										method: :put,  
										headers: { "Authorization" => "Bearer #{access_token}" })
		outcomes_api.on_complete do |response|
			if response.code == 200
					puts "Outcome #{i} has been fixed with an A - E scale" 
			else
					puts "Unable to update outcome #{i}. Check to verify this outcome exists with correct ID."
			end
			
		end
		
		hydra.queue(outcomes_api)
		hydra.run
end



puts 'Successfully updated all outcomes.'

require 'rubygems'
require 'date'
require 'csv'


inputFile = "originalData.csv"
outputFile = "dataWithTemp.csv"

headerIn = ["Date","CPU"]

datapoints = []
csv = CSV.parse(File.read(inputFile).force_encoding("ISO-8859-1").encode("UTF-8"))
csv.each do |data|
   row = Hash[headerIn.zip data]
   row.each {|i, j| row[i] = j }
   datapoints << row
end

output = File.open(outputFile, "w")
output << "Date,Temperature,Humidity,CPU\n"

#result = File.open("result.txt")

datapoints.each do |data|

	#/(?<month>\d+)\/(?<day>\d+)\/(?<year>\d+)/.match(data["Date"])	
	date = data["Date"].match(/(\d{4})(\d{2})(\d{2})/)
   `curl -s -O http://www.wunderground.com/history/airport/KBDU/#{date[1]}/#{date[2]}/#{date[3]}/DailyHistory.html?req_city=Boulder&req_state=CO`
	`tr -d "\n" < DailyHistory.html?req_city=Boulder | tee results.txt`
   info = File.read("results.txt").force_encoding("ISO-8859-1").encode("UTF-8")
   weather = info.match(/Mean Temperature<\/span><\/td>\s+<td>\s+<span\s+class="nobr"><span\s+class="b">(\d+).+Average Humidity<\/span><\/td>\s+<td>(\d+)/)
	output << "#{date[1]}-#{date[2]}-#{date[3]},#{weather[1]},#{weather[2]},#{data["CPU"]}\n"
	#file.close

end

output.close

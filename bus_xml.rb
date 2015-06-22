require "nokogiri"
require 'roo'


puts "//
//  CoreDataModel.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/27/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import CoreData

class CoreDataModel
{
    static var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static var context: NSManagedObjectContext = appDel.managedObjectContext!

    class func massAssign()
    {
    var "


xlsx = Roo::Excelx.new("Book1.xlsx")


dict  = { 
	"Brookes Uni stop B5" =>[51.755474, -1.226263], "Headington Shops" => [51.759688, -1.212619],
	"Harcourt Hill" => [51.7404539,-1.2914457], "Wheatley campus" => [51.7488942, -1.1265288], 
	"Wheatley church" => [51.747191, -1.135268], "Castle Street" => [51.751495,-1.260925], 
	"Speedwell Street" => [51.748428,-1.258112], "OXFORD High St Carfax" => [51.751985,-1.2580974],
	"Frideswide Sq R9" => [51.7526129,-1.2680492], "Sandhills A40" => [51.7631259,-1.1808569],
	"Brookes Uni stop B2" => [51.7558266,-1.2253118], "High St Turl St" => [51.7521907,-1.2563702], 
	
}

sheets = xlsx.sheets.each_with_index do |sheet, ind|
	xls = xlsx.sheet(sheet)

	#  Days: 0 = M-F, 1 = Saturday, 2 = Sunday, 3 = WF Only
	#
	#

	first = xls.first_column + 1
	last = xls.last_column

	names = xls.column(1).map(&:strip) # names are always stored in the first row

	(first..last).each do |num|
		col = xls.column(num)
	#	stop = row[0].strip
		times = col[1..-1]
		a = times.each_with_index.map do |x,i|
				[x, i + 2]

		end.select { |x| x[0] }  # remove nil statements

	#	puts a.to_s

		name = col[0].strip
		destination = xls.cell(a[-1][1],1).strip
		start_time = a[0][0].to_i
		end_time = a[-1][0].to_i
		direction = true

		if ind % 2 == 1
			direction = false # going down
		end
		
		schedule = ind / 2
		puts %Q(		bus = BusRoute.createBusRoute("#{name}", destination: "#{destination}", startTime: #{start_time}, endTime: #{end_time}, schedule: #{schedule}, direction: #{direction} ))
		
		a.each_with_index do |elem, index|
			stop_time = elem[0].to_i
			stop_number = elem[1]
			stop_name = xls.cell(elem[1],1).strip

			longitude = 3.00
			latitude = 2.00

			if dict[stop_name]
				longitude = dict[stop_name][1] 
				latitude = dict[stop_name][0] 
			end


			
			puts %Q(		Stop.createStop(#{stop_time}, name: "#{stop_name}", stop_number: #{stop_number}, latitude: #{latitude}, longitude: #{longitude}, parent: bus))
		end

	    # stop_times = row[1..-1].compact.map(&:to_i)  # from second to last element
	    # puts "array.append(BusStop(name: \"#{stop}\", stop_times: #{stop_times.to_s}, day: 0, bus_type: \"U1\", direction: 1))"
	end  


end

puts "	}
}"


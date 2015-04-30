//
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

    // TODO: add paramenters
    class func addData(name: String, stop_num: Int = 0){
      
        let stop = Stop.createInManagedObjectContext(name, stop_number: stop_num)
        
        let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
        time.time = 2300 % 2000
        time.direction = 1 // 0 for end, 1 for down, 2 for up
        time.day = 0       // 0 for M-F, 1 for Saturday, 2 for Sunday
        time.bus_type = "U1"
        
        // set time as a parent of stop
        time.parent = stop
        
       // context.save(nil)
    }
    
    class func addTimesData(name: String, stop_num: Int = 0, times: [Time]){
        
        let stop = Stop.createInManagedObjectContext(name, stop_number: stop_num)
        
        for t in times
        {
            let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
            time.time = t.time
            time.direction = 1 // 0 for end, 1 for down, 2 for up
            time.day = 0       // 0 for M-F, 1 for Saturday, 2 for Sunday
            time.bus_type = "U1"
        
        // set time as a parent of stop
            time.parent = stop
        }
        
        // context.save(nil)
    }
    
    
    class func massAssign()
    {
        var array = [BusStop]()
        array.append(BusStop(name: "Wheatley campus", stop_times: [650, 710, 725, 745, 800, 815, 835, 900, 850, 900, 910, 925, 940, 955, 1010, 1025, 1040, 1055, 1110, 1125, 1140, 1155, 1210, 1225, 1240, 1255, 1310, 1315, 1325, 1340, 1355, 1410, 1425, 1440, 1455, 1508, 1510, 1525, 1540, 1555, 1610, 1625, 1640, 1655, 1710, 1725, 1740, 1755, 1805, 1820, 1835, 1905, 1915, 1935, 2005, 2035, 2105, 2135, 2205, 2235, 2235, 2305, 2305, 2335], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Wheatley church", stop_times: [653, 713, 730, 750, 820, 840, 855, 904, 914, 929, 944, 959, 1014, 1029, 1044, 1059, 1114, 1129, 1144, 1159, 1214, 1229, 1244, 1259, 1314, 1329, 1344, 1359, 1414, 1429, 1444, 1459, 1514, 1529, 1544, 1559, 1614, 1629, 1644, 1659, 1714, 1729, 1744, 1759, 1809, 1824, 1839, 1908, 1918, 1938, 2008, 2038, 2108, 2138, 2208, 2238, 2238, 2308, 2308, 2338], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Sandhills A40", stop_times: [658, 718, 736, 756, 826, 846, 901, 909, 919, 934, 949, 1004, 1019, 1034, 1049, 1104, 1119, 1134, 1149, 1204, 1219, 1234, 1249, 1304, 1319, 1334, 1349, 1404, 1419, 1434, 1449, 1504, 1518, 1519, 1534, 1549, 1604, 1619, 1634, 1649, 1704, 1719, 1734, 1749, 1804, 1814, 1829, 1844, 1913, 1923, 1943, 2013, 2043, 2113, 2143, 2213, 2243, 2243, 2313, 2313, 2343], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Headington Shops", stop_times: [605, 705, 712, 725, 747, 807, 812, 837, 857, 912, 912, 917, 927, 942, 957, 1012, 1027, 1042, 1057, 1112, 1127, 1142, 1157, 1212, 1227, 1242, 1257, 1312, 1327, 1327, 1342, 1357, 1412, 1427, 1442, 1457, 1512, 1528, 1527, 1542, 1557, 1612, 1627, 1642, 1657, 1712, 1727, 1742, 1757, 1812, 1822, 1837, 1852, 1920, 1930, 1950, 2020, 2050, 2120, 2150, 2220, 2250, 2250, 2320, 2320, 2350], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Brookes Uni stop B5", stop_times: [613, 713, 718, 733, 755, 815, 818, 845, 905, 918, 920, 925, 935, 950, 1005, 1020, 1035, 1050, 1105, 1120, 1135, 1150, 1205, 1220, 1235, 1250, 1305, 1320, 1335, 1333, 1350, 1405, 1420, 1435, 1450, 1505, 1520, 1535, 1535, 1550, 1605, 1620, 1635, 1650, 1705, 1720, 1735, 1750, 1805, 1820, 1830, 1845, 1900, 1928, 1938, 1958, 2028, 2058, 2128, 2158, 2228, 2258, 2258, 2328, 2328, 2358], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "OXFORD High St Carfax", stop_times: [619, 719, 725, 739, 803, 823, 825, 853, 912, 925, 928, 933, 942, 958, 1012, 1028, 1042, 1058, 1112, 1128, 1142, 1158, 1212, 1228, 1242, 1258, 1312, 1328, 1342, 1340, 1358, 1412, 1428, 1442, 1458, 1512, 1528, 1543, 1542, 1558, 1612, 1628, 1642, 1658, 1712, 1728, 1742, 1758, 1812, 1828, 1837, 1853, 1908, 1934, 1944, 2004, 2034, 2104, 2134, 2204, 2234, 2304, 2304, 2334, 2334, 4], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Speedwell Street", stop_times: [621, 721, 741, 805, 825, 855, 915, 930, 935, 945, 1000, 1015, 1030, 1045, 1100, 1115, 1130, 1145, 1200, 1215, 1230, 1245, 1300, 1315, 1330, 1345, 1400, 1415, 1430, 1445, 1500, 1515, 1530, 1545, 1545, 1600, 1615, 1630, 1645, 1700, 1715, 1730, 1745, 1800, 1815, 1830, 1840, 1855, 1910, 1936, 1946, 2006, 2036, 2106, 2136, 2206, 2236, 2306, 2306, 2336, 2336, 6], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Castle Street", stop_times: [627, 727, 747, 811, 831, 901, 936, 1006, 1036, 1106, 1136, 1206, 1236, 1306, 1336, 1406, 1436, 1506, 1536, 1606, 1636, 1706, 1736, 1806, 1836, 1901, 1916, 1942, 2012, 2042, 2112, 2142, 2212, 2242, 2312, 2312, 2342, 2342, 12], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Frideswide Sq R9", stop_times: [630, 730, 735, 750, 815, 835, 835, 905, 935, 940, 1010, 1040, 1110, 1140, 1210, 1240, 1310, 1340, 1410, 1440, 1510, 1540, 1610, 1640, 1710, 1740, 1810, 1840, 1905, 1920, 1945, 2015, 2045, 2115, 2145, 2215, 2245, 2315, 2315, 2345, 2345, 15], day: 0, bus_type: "U1", direction: 1))
        array.append(BusStop(name: "Harcourt Hill", stop_times: [638, 738, 745, 758, 827, 847, 845, 917, 945, 952, 1022, 1052, 1122, 1152, 1222, 1252, 1322, 1352, 1422, 1452, 1522, 1552, 1622, 1652, 1722, 1752, 1822, 1852, 1917, 1932, 1953, 2023, 2053, 2123, 2153, 2223, 2253, 2323, 2323, 2353, 2353, 23], day: 0, bus_type: "U1", direction: 1))
        massAssignBusStops(array)
    }
    

    class func massAssignBusStops(busStop: [BusStop])
    {
        for (index, t) in enumerate(busStop)
        {
            let stop = Stop.createInManagedObjectContext(t.name, stop_number: index, bus_route: t.bus_type)
            
            for s in t.stop_times
            {
                let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
                time.time = s
                time.direction = t.direction // 0 for end, 1 for down, 2 for up
                time.day = t.day       // 0 for M-F, 1 for Saturday, 2 for Sunday
                time.bus_type = t.bus_type
                
                // set time as a parent of stop
                time.parent = stop
            }
            
        }
        
        
        
        
        /**for t in times
        {
            let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
            time.time = t.time
            time.direction = 1 // 0 for end, 1 for down, 2 for up
            time.day = 0       // 0 for M-F, 1 for Saturday, 2 for Sunday
            time.bus_type = "U1"
            
            // set time as a parent of stop
            time.parent = stop
        }
*/
        
    }
}





﻿using System.Collections.Generic;
using System.Management;
using Zal.Constants.Models;

namespace Zal.HelperFunctions.SpecificFunctions
{
    internal class ramPieceDataGetter
    {
         public static List<ramPieceData> GetRamPiecesData()
        {
            var data = new List<ramPieceData>();
            var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_PhysicalMemory");
            foreach (ManagementObject obj in searcher.Get())
            {
                var ramData = new ramPieceData();
                ramData.capacity = (ulong)obj["Capacity"];
                ramData.manufacturer = (string)obj["Manufacturer"];
                ramData.partNumber = (string)obj["PartNumber"];
                ramData.speed = (uint)obj["Speed"];
                data.Add(ramData);
            }
            return data;
        }
    }
}

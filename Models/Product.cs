using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Data;
using db_connectivity.Models;


namespace db_connectivity.Models
{
    public class Product
    {
        public int productID { get; set; }
        public string productCategory { get; set; }
        public string productCompanyName { get; set; }
        public string productName { get; set; }
        public int productPrice { get; set; }
        public int productAmount { get; set; }
        public int productAvgRating { get; set; }
    }
}
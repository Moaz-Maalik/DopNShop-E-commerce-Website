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
    public class currentUser
    {
        public int customerID { get; set; }
        public string customerName { get; set; }
        public string customerEmail { get; set; }
        public string customerPassword { get; set; }
        public string customerNumber { get; set; }
        public string customerAddress { get; set; }
        public int customerBalance { get; set; }
    }
}
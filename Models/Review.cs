using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace db_connectivity.Models
{
    public class Review
    {
        public int reviewID { get; set; }
        public int reviewCustomerID { get; set; }

        public int reviewProductID { get; set; }

        public string reviewProductName { get; set; }

        public string reviewDescription { get; set; }

        public int reviewStars { get; set; }
    }
}
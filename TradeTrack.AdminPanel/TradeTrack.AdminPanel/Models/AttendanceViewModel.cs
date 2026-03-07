namespace TradeTrack.AdminPanel.Models
{
    public class AttendanceViewModel
    {
        public int Id { get; set; }
        public int SalesRepId { get; set; }
        public string SalesRepName { get; set; } = string.Empty;
        public DateTime CheckIn { get; set; }
        public DateTime? CheckOut { get; set; }
        public double? HoursWorked { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public string LocationAddress { get; set; } = string.Empty;
    }

    public class AttendanceListViewModel
    {
        public List<AttendanceViewModel> Attendances { get; set; } = new();
        public DateTime? DateFilter { get; set; }
        public int? SalesRepIdFilter { get; set; }
        public int Page { get; set; } = 1;
        public int PageSize { get; set; } = 50;
        public int TotalCount { get; set; }
    }
}
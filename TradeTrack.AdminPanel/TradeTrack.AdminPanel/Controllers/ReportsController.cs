using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
    [Authorize(Roles = "Admin")]
    public class ReportsController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        public ReportsController(IApiService apiService, IAuthService authService)
        {
            _apiService = apiService;
            _authService = authService;
        }

        public async Task<IActionResult> Dashboard()
        {
            var token = _authService.GetToken(HttpContext);
            var dashboardData = await _apiService.GetAsync<DashboardViewModel>("reports/summary", token);

            if (dashboardData == null)
            {
                dashboardData = new DashboardViewModel();
            }

            return View(dashboardData);
        }

        public async Task<IActionResult> SalesRepPerformance(DateTime? startDate, DateTime? endDate)
        {
            var token = _authService.GetToken(HttpContext);

            var query = "reports/salesrep-performance";
            if (startDate.HasValue || endDate.HasValue)
            {
                query += "?";
                if (startDate.HasValue)
                    query += $"startDate={startDate.Value:yyyy-MM-dd}&";
                if (endDate.HasValue)
                    query += $"endDate={endDate.Value:yyyy-MM-dd}";
            }

            var performance = await _apiService.GetAsync<List<SalesRepPerformance>>(query, token);

            ViewBag.StartDate = startDate?.ToString("yyyy-MM-dd");
            ViewBag.EndDate = endDate?.ToString("yyyy-MM-dd");

            return View(performance ?? new List<SalesRepPerformance>());
        }

        public async Task<IActionResult> StockStatus()
        {
            var token = _authService.GetToken(HttpContext);
            var stockReport = await _apiService.GetAsync<List<StockReport>>("reports/stock-status", token);

            return View(stockReport ?? new List<StockReport>());
        }

        public async Task<IActionResult> MonthlyReport()
        {
            var token = _authService.GetToken(HttpContext);
            var startDate = new DateTime(DateTime.Now.Year, 1, 1);
            var endDate = DateTime.Now;

            var monthlyReport = await _apiService.GetAsync<List<MonthlyReport>>(
                $"reports/monthly?startDate={startDate:yyyy-MM-dd}&endDate={endDate:yyyy-MM-dd}",
                token);

            return View(monthlyReport ?? new List<MonthlyReport>());
        }

        public async Task<IActionResult> AttendanceReport(DateTime? date)
        {
            date ??= DateTime.Today;

            var token = _authService.GetToken(HttpContext);
            var attendanceReport = await _apiService.GetAsync<List<AttendanceReport>>(
                $"reports/attendance?date={date.Value:yyyy-MM-dd}",
                token);

            ViewBag.SelectedDate = date.Value.ToString("yyyy-MM-dd");

            return View(attendanceReport ?? new List<AttendanceReport>());
        }
    }
}
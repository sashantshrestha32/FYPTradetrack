using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
    [Authorize(Roles = "Admin")]
    public class DashboardController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        public DashboardController(IApiService apiService, IAuthService authService)
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

        // AJAX endpoint for refreshing stats
        public async Task<IActionResult> GetDashboardStats()
        {
            var token = _authService.GetToken(HttpContext);
            try
            {
                var dashboardData = await _apiService.GetAsync<DashboardViewModel>("reports/summary", token);
                if (dashboardData == null)
                {
                    dashboardData = new DashboardViewModel();
                }

                var totalOrders = dashboardData.MonthlyReports.Sum(m => m.Orders);
                var avgOrderValue = totalOrders > 0 ? dashboardData.TotalSalesMonth / totalOrders : 0;
                var avgActiveDays = dashboardData.TopPerformers.Any()
                    ? dashboardData.TopPerformers.Average(p => p.AttendanceDays)
                    : 0;

                return Json(new
                {
                    totalSalesReps = dashboardData.TotalSalesReps,
                    activeSalesReps = dashboardData.ActiveSalesReps,
                    todayCheckins = dashboardData.TodayCheckins,
                    totalSalesToday = dashboardData.TotalSalesToday,
                    totalSalesMonth = dashboardData.TotalSalesMonth,
                    totalOrders = totalOrders,
                    totalProducts = dashboardData.TotalProducts,
                    lowStockProducts = dashboardData.LowStockProducts,
                    avgActiveDays = avgActiveDays,
                    avgOrderValue = avgOrderValue
                });
            }
            catch (Exception)
            {
                return Json(new
                {
                    totalSalesReps = 0,
                    activeSalesReps = 0,
                    todayCheckins = 0,
                    totalSalesToday = 0,
                    totalSalesMonth = 0,
                    totalOrders = 0,
                    totalProducts = 0,
                    lowStockProducts = 0,
                    avgActiveDays = 0,
                    avgOrderValue = 0
                });
            }
        }

        // AJAX endpoint for live activity
        public async Task<IActionResult> GetLiveActivity()
        {
            var token = _authService.GetToken(HttpContext);
            try
            {
                // Get recent check-ins
                var todayAttendance = await _apiService.GetAsync<List<AttendanceViewModel>>(
                    $"attendance/byrep/all?date={DateTime.Today:yyyy-MM-dd}", token)
                    ?? new List<AttendanceViewModel>();

                var recentCheckins = todayAttendance
                    .Where(a => a.CheckIn > DateTime.Now.AddHours(-1))
                    .OrderByDescending(a => a.CheckIn)
                    .Take(5)
                    .Select(a => new
                    {
                        type = "checkin",
                        message = $"{a.SalesRepName} checked in",
                        timestamp = a.CheckIn
                    })
                    .ToList();

                // Get recent orders (assuming you have an orders API)
                var recentOrders = new List<object>(); // Implement order fetching

                // Combine activities
                var activities = recentCheckins.Cast<object>().ToList();

                return Json(activities);
            }
            catch (Exception)
            {
                return Json(new List<object>());
            }
        }

        // AJAX endpoint for today's attendance
        public async Task<IActionResult> GetTodayAttendance()
        {
            var token = _authService.GetToken(HttpContext);
            try
            {
                var attendance = await _apiService.GetAsync<List<AttendanceViewModel>>(
                    $"attendance/byrep/all?date={DateTime.Today:yyyy-MM-dd}", token)
                    ?? new List<AttendanceViewModel>();

                var result = attendance
                    .OrderByDescending(a => a.CheckIn)
                    .Take(5)
                    .Select(a => new
                    {
                        salesRepName = a.SalesRepName,
                        checkInTime = a.CheckIn.ToString("hh:mm tt"),
                        checkedOut = a.CheckOut.HasValue
                    })
                    .ToList();

                return Json(result);
            }
            catch (Exception)
            {
                return Json(new List<object>());
            }
        }

        // AJAX endpoint for top performers
        public async Task<IActionResult> GetTopPerformers()
        {
            var token = _authService.GetToken(HttpContext);
            try
            {
                var dashboardData = await _apiService.GetAsync<DashboardViewModel>("reports/summary", token);
                if (dashboardData == null || !dashboardData.TopPerformers.Any())
                {
                    return PartialView("_TopPerformersPartial", new List<SalesRepPerformance>());
                }

                return PartialView("_TopPerformersPartial", dashboardData.TopPerformers);
            }
            catch (Exception)
            {
                return PartialView("_TopPerformersPartial", new List<SalesRepPerformance>());
            }
        }
    }
}
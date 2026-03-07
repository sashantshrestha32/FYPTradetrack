using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
    [Authorize(Roles ="Admin")]
    public class AttendanceController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        public AttendanceController(IApiService apiService, IAuthService authService)
        {
            _apiService = apiService;
            _authService = authService;
        }

        public async Task<IActionResult> Index(DateTime? date, int? salesRepId, int page = 1, int pageSize = 50)
        {
            var token = _authService.GetToken(HttpContext);

            // Build query string
            var query = $"attendance/byrep/all?page={page}&pageSize={pageSize}";
            if (date.HasValue)
            {
                query += $"&date={date.Value:yyyy-MM-dd}";
            }
            if (salesRepId.HasValue)
            {
                query = $"attendance/byrep/{salesRepId}?page={page}&pageSize={pageSize}";
                if (date.HasValue)
                {
                    query += $"&date={date.Value:yyyy-MM-dd}";
                }
            }

            var attendances = await _apiService.GetAsync<List<AttendanceViewModel>>(query, token);

            var viewModel = new AttendanceListViewModel
            {
                Attendances = attendances ?? new List<AttendanceViewModel>(),
                DateFilter = date,
                SalesRepIdFilter = salesRepId,
                Page = page,
                PageSize = pageSize,
                TotalCount = attendances?.Count ?? 0
            };

            return View(viewModel);
        }

        public async Task<IActionResult> Details(int id)
        {
            var token = _authService.GetToken(HttpContext);
            var attendance = await _apiService.GetAsync<AttendanceViewModel>($"attendance/{id}", token);

            if (attendance == null)
            {
                return NotFound();
            }

            return View(attendance);
        }
        public async Task<IActionResult> GetSalesRepsForFilter()
        {
            var token = _authService.GetToken(HttpContext);
            try
            {
                // Assuming you have an API endpoint to get active sales reps
                var salesReps = await _apiService.GetAsync<List<SalesRepViewModel>>("salesreps/active", token);

                if (salesReps == null || !salesReps.Any())
                {
                    // Fallback to all sales reps
                    salesReps = await _apiService.GetAsync<List<SalesRepViewModel>>("salesreps", token);
                }

                // Handle null salesReps
                if (salesReps == null || !salesReps.Any())
                {
                    return Json(new List<object>());
                }

                // Process and order the sales reps
                var result = salesReps
                    .Where(rep => rep.IsActive) // Only include active sales reps
                    .Select(rep => new
                    {
                        id = rep.Id,
                        name = rep.FullName
                    })
                    .OrderBy(rep => rep.name)
                    .ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                // Log error (you should use ILogger in production)
                Console.WriteLine($"Error getting sales reps: {ex.Message}");
                return Json(new List<object>());
            }
        }
        // NEW ACTION: Get attendance statistics
        public async Task<IActionResult> GetAttendanceStats(DateTime? date)
        {
            var token = _authService.GetToken(HttpContext);

            try
            {
                // Build query based on date filter
                var query = "attendance/byrep/all";
                if (date.HasValue)
                {
                    query += $"?date={date.Value:yyyy-MM-dd}";
                }

                var attendances = await _apiService.GetAsync<List<AttendanceViewModel>>(query, token)
                    ?? new List<AttendanceViewModel>();

                var targetDate = date?.Date ?? DateTime.Today;
                var dateAttendances = attendances.Where(a => a.CheckIn.Date == targetDate).ToList();

                // Calculate statistics
                var completedAttendances = dateAttendances.Where(a => a.CheckOut.HasValue).ToList();
                var avgHours = completedAttendances.Any()
                    ? completedAttendances.Average(a => a.HoursWorked ?? 0)
                    : 0;

                var stats = new
                {
                    todayCheckins = dateAttendances.Count,
                    activeNow = dateAttendances.Count(a => !a.CheckOut.HasValue),
                    avgHours = avgHours,
                    pendingCheckouts = dateAttendances.Count(a => !a.CheckOut.HasValue)
                };

                return Json(stats);
            }
            catch (Exception ex)
            {
                // Log error (add logging if needed)
                Console.WriteLine($"Error getting attendance stats: {ex.Message}");

                // Return default stats on error
                return Json(new
                {
                    todayCheckins = 0,
                    activeNow = 0,
                    avgHours = 0.0,
                    pendingCheckouts = 0
                });
            }
        }

        // NEW ACTION: Get live attendance (active sessions from today)
        public async Task<IActionResult> GetLiveAttendance()
        {
            var token = _authService.GetToken(HttpContext);

            try
            {
                // Get today's attendance
                var attendances = await _apiService.GetAsync<List<AttendanceViewModel>>(
                    $"attendance/byrep/all?date={DateTime.Today:yyyy-MM-dd}", token)
                    ?? new List<AttendanceViewModel>();

                // Filter for active sessions (no check-out)
                var activeSessions = attendances.Where(a => !a.CheckOut.HasValue).ToList();

                var result = activeSessions.Select(a => new
                {
                    id = a.Id,
                    salesRepName = a.SalesRepName,
                    salesRepId = a.SalesRepId,
                    checkInTime = a.CheckIn.ToString("dd MMM yyyy HH:mm"),
                    checkOutTime = (string)null,
                    checkOut = false,
                    hoursWorked = (double?)null,
                    location = string.IsNullOrEmpty(a.LocationAddress) ? "No location data" : a.LocationAddress,
                    checkInTimeFull = a.CheckIn.ToString("yyyy-MM-ddTHH:mm:ss"),
                    duration = (DateTime.Now - a.CheckIn).TotalHours.ToString("F1")
                }).OrderByDescending(a => a.checkInTimeFull).ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                // Log error
                Console.WriteLine($"Error getting live attendance: {ex.Message}");
                return Json(new List<object>());
            }
        }
    }
}
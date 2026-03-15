using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
    [Authorize(Roles = "Admin")]
    public class HomeController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        public HomeController(IApiService apiService, IAuthService authService)
        {
            _apiService = apiService;
            _authService = authService;
        }

        public async Task<IActionResult> Index()
        {
            var token = _authService.GetToken(HttpContext);
            var dashboardData = await _apiService.GetAsync<DashboardViewModel>("reports/summary", token);

            if (dashboardData == null)
            {
                dashboardData = new DashboardViewModel();
            }

            return View(dashboardData);
        }

        public IActionResult About()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = System.Diagnostics.Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }

    public class ErrorViewModel
    {
        public string? RequestId { get; set; }
        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
    }
}
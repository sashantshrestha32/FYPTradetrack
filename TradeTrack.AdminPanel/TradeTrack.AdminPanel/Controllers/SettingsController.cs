using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
     [Authorize(Roles ="Admin")]
    public class SettingsController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        private readonly IConfiguration _configuration;

        public SettingsController(IApiService apiService, IAuthService authService, IConfiguration configuration)
        {
            _apiService = apiService;
            _authService = authService;
            _configuration = configuration;
        }


        [HttpGet]
        public IActionResult GetApiInfo()
        {
            var baseUrl = _configuration["ApiSettings:BaseUrl"] ?? "Not configured";
            return Json(new { endpoint = baseUrl });
        }

        [HttpGet]
        public async Task<IActionResult> CheckSystemHealth()
        {
            try
            {
                var token = _authService.GetToken(HttpContext);
                var settings = await _apiService.GetAsync<List<SettingViewModel>>("settings", token);

                // Try to ping the API
                var dashboard = await _apiService.GetAsync<object>("reports/summary", token);

                return Json(new
                {
                    apiConnected = dashboard != null,
                    databaseConnected = true,
                    totalSettings = settings?.Count ?? 0
                });
            }
            catch
            {
                return Json(new
                {
                    apiConnected = false,
                    databaseConnected = false,
                    totalSettings = 0
                });
            }
        }

        [HttpPost]
        public async Task<IActionResult> LoadDefaultSettings()
        {
            try
            {
                var defaultSettings = new List<SettingViewModel>
        {
            new SettingViewModel { Key = "CompanyName", Value = "TradeTrack Inc.", Description = "Company Name" },
            new SettingViewModel { Key = "MaxCheckInDistance", Value = "100", Description = "Maximum distance for check-in (meters)" },
            new SettingViewModel { Key = "DefaultCurrency", Value = "₹", Description = "Default currency symbol" },
            new SettingViewModel { Key = "TaxRate", Value = "18", Description = "Tax rate percentage" },
            new SettingViewModel { Key = "SupportEmail", Value = "support@tradetrack.com", Description = "Support email address" },
            new SettingViewModel { Key = "WorkingHoursStart", Value = "09:00", Description = "Working hours start time" },
            new SettingViewModel { Key = "WorkingHoursEnd", Value = "18:00", Description = "Working hours end time" },
            new SettingViewModel { Key = "AutoLogoutMinutes", Value = "30", Description = "Auto logout after inactivity (minutes)" }
        };

                var token = _authService.GetToken(HttpContext);

                // Delete existing settings
                var existingSettings = await _apiService.GetAsync<List<SettingViewModel>>("settings", token);
                if (existingSettings != null)
                {
                    foreach (var setting in existingSettings)
                    {
                        await _apiService.DeleteAsync($"settings/{setting.Id}", token);
                    }
                }

                // Create default settings
                foreach (var setting in defaultSettings)
                {
                    await _apiService.PostAsync<SettingViewModel>("settings", setting, token);
                }

                return Json(new { success = true });
            }
            catch
            {
                return Json(new { success = false });
            }
        }

        public async Task<IActionResult> Index()
        {
            var token = _authService.GetToken(HttpContext);
            var settings = await _apiService.GetAsync<List<SettingViewModel>>("settings", token);

            return View(settings ?? new List<SettingViewModel>());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateSettings(List<SettingViewModel> settings)
        {
            if (!ModelState.IsValid)
            {
                return View("Index", settings);
            }

            var token = _authService.GetToken(HttpContext);
            var success = true;

            foreach (var setting in settings)
            {
                var result = await _apiService.PutAsync<SettingViewModel>($"settings/{setting.Id}", setting, token);
                if (result == null)
                {
                    success = false;
                }
            }

            if (success)
            {
                TempData["SuccessMessage"] = "Settings updated successfully!";
            }
            else
            {
                TempData["ErrorMessage"] = "Failed to update some settings.";
            }

            return RedirectToAction("Index");
        }


    }

    public class SettingViewModel
    {
        public int Id { get; set; }
        public string Key { get; set; } = string.Empty;
        public string Value { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }
}
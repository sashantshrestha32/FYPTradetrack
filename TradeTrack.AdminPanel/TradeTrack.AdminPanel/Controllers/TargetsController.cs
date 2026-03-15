using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
    [Authorize(Roles = "Admin,Manager")]
    public class TargetsController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        public TargetsController(IApiService apiService, IAuthService authService)
        {
            _apiService = apiService;
            _authService = authService;
        }

        // Main Targets Page
        public async Task<IActionResult> Index()
        
        {
            var token = _authService.GetToken(HttpContext);

            // Get all sales reps for dropdown-----
            var salesRepsResponse = await _apiService.GetApiResponseAsync<List<SalesRepViewModel>>("salesreps", token);
            ViewBag.SalesReps = salesRepsResponse?.Data ?? new List<SalesRepViewModel>();
            // Get current month targets
            var targetsResponse = await _apiService.GetApiResponseAsync<List<TargetViewModel>>($"targets/month/{DateTime.Now.Year}/{DateTime.Now.Month}", token);

            var targets = targetsResponse?.Data ?? new List<TargetViewModel>();

            // Calculate ProgressPercentage and Status
            foreach (var target in targets)
            {
                target.ProgressPercentage = target.TargetAmount == 0
                    ? 0
                    : Math.Min((target.AchievedAmount / target.TargetAmount) * 100, 100);

                target.Status = target.ProgressPercentage >= 100 ? "Achieved" :
                                target.ProgressPercentage > 0 ? "In Progress" :
                                "Not Achieved";
            }

            return View(targets);

        }

        // Create Target View
        public async Task<IActionResult> Create()
        {
            var token = _authService.GetToken(HttpContext);
            var salesRepsResponse = await _apiService.GetApiResponseAsync<List<SalesRepViewModel>>("salesreps", token);
            ViewBag.SalesReps = salesRepsResponse?.Data ?? new List<SalesRepViewModel>();

            return View();
        }

        // Create Target (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(TargetCreateViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var token = _authService.GetToken(HttpContext);
                var salesRepsResponse = await _apiService.GetApiResponseAsync<List<SalesRepViewModel>>("salesreps", token);
                ViewBag.SalesReps = salesRepsResponse?.Data ?? new List<SalesRepViewModel>();
                return View(model);
            }

            var token2 = _authService.GetToken(HttpContext);
            try
            {
                var response = await _apiService.PostAsync<ApiResponse<TargetViewModel>>("targets", model, token2);

                if (response?.Success == true && response.Data != null)
                {
                    TempData["SuccessMessage"] = "Target created successfully!";
                    return RedirectToAction(nameof(Index));
                }

                TempData["ErrorMessage"] = response?.Message ?? "Failed to create target.";
                return View(model);
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Error: {ex.Message}";
                return View(model);
            }
        }

        // Edit Target View
        public async Task<IActionResult> Edit(int id)
        {
            var token = _authService.GetToken(HttpContext);

            // Get target details
            var targetResponse = await _apiService.GetApiResponseAsync<TargetViewModel>($"targets/{id}", token);
            if (targetResponse?.Data == null)
            {
                TempData["ErrorMessage"] = targetResponse?.Message ?? "Target not found.";
                return RedirectToAction(nameof(Index));
            }

            var target = targetResponse.Data;

            // Get sales reps for dropdown
            var salesRepsResponse = await _apiService.GetApiResponseAsync<List<SalesRepViewModel>>("salesreps", token);
            ViewBag.SalesReps = salesRepsResponse?.Data ?? new List<SalesRepViewModel>();

            var editModel = new TargetEditViewModel
            {
                Id = target.Id,
                SalesRepId = target.SalesRepId,
                TargetMonth = target.TargetMonth,
                TargetAmount = target.TargetAmount
            };

            return View(editModel);
        }

        // Edit Target (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, TargetEditViewModel model)
        {
            if (id != model.Id)
            {
                TempData["ErrorMessage"] = "Target ID mismatch.";
                return RedirectToAction(nameof(Index));
            }

            if (!ModelState.IsValid)
            {
                var token = _authService.GetToken(HttpContext);
                var salesRepsResponse = await _apiService.GetApiResponseAsync<List<SalesRepViewModel>>("salesreps", token);
                ViewBag.SalesReps = salesRepsResponse?.Data ?? new List<SalesRepViewModel>();
                return View(model);
            }

            var token2 = _authService.GetToken(HttpContext);
            try
            {
                var response = await _apiService.PutAsync<ApiResponse<TargetViewModel>>($"targets/{id}", model, token2);

                if (response?.Success == true && response.Data != null)
                {
                    TempData["SuccessMessage"] = "Target updated successfully!";
                    return RedirectToAction(nameof(Index));
                }

                TempData["ErrorMessage"] = response?.Message ?? "Failed to update target.";
                return View(model);
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Error: {ex.Message}";
                return View(model);
            }
        }

        // Delete Target
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var token = _authService.GetToken(HttpContext);
            try
            {
                var response = await _apiService.DeleteAsync($"targets/{id}", token);

                if (response)
                {
                    TempData["SuccessMessage"] = "Target deleted successfully!";
                }
                else
                {
                    TempData["ErrorMessage"] = "Failed to delete target.";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Error: {ex.Message}";
            }

            return RedirectToAction(nameof(Index));
        }

        // AJAX: Get Targets by Filters
        [HttpGet]
        public async Task<IActionResult> GetTargetsByFilters(int? salesRepId, int? month, int? year, string? status)
        {
            var token = _authService.GetToken(HttpContext);

            try
            {
                var queryParams = new List<string>();
                if (salesRepId.HasValue)
                    queryParams.Add($"salesRepId={salesRepId.Value}");
                if (month.HasValue)
                    queryParams.Add($"month={month.Value}");
                if (year.HasValue)
                    queryParams.Add($"year={year.Value}");
                if (!string.IsNullOrEmpty(status))
                    queryParams.Add($"status={status}");

                var queryString = queryParams.Any() ? "?" + string.Join("&", queryParams) : "";
                var response = await _apiService.GetApiResponseAsync<List<TargetViewModel>>($"targets/filter{queryString}", token);

                return PartialView("_TargetsTablePartial", response?.Data ?? new List<TargetViewModel>());
            }
            catch (Exception)
            {
                return PartialView("_TargetsTablePartial", new List<TargetViewModel>());
            }
        }

        // AJAX: Get Target Progress
        [HttpGet]
        public async Task<IActionResult> GetTargetProgress(int salesRepId, int year, int month)
        {
            var token = _authService.GetToken(HttpContext);

            try
            {
                var response = await _apiService.GetApiResponseAsync<TargetProgressViewModel>(
                    $"targets/{salesRepId}/progress/{year}/{month}", token);

                if (response?.Success == true && response.Data != null)
                {
                    return Json(new
                    {
                        success = true,
                        data = response.Data
                    });
                }

                // If no target found, return empty data
                return Json(new
                {
                    success = true,
                    data = new TargetProgressViewModel
                    {
                        SalesRepId = salesRepId,
                        TargetMonth = new DateTime(year, month, 1),
                        TargetAmount = 0,
                        AchievedAmount = 0,
                        ProgressPercentage = 0,
                        Status = "No Target Set"
                    }
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = ex.Message
                });
            }
        }

        // AJAX: Update Achievement
        [HttpPost]
        public async Task<IActionResult> UpdateAchievement(int id, [FromBody] decimal amount)
        {
            var token = _authService.GetToken(HttpContext);

            try
            {
                var response = await _apiService.PostAsync<ApiResponse<bool>>(
                    $"targets/{id}/achievement", new { amount }, token);

                return Json(new
                {
                    success = response?.Success ?? false,
                    message = response?.Message ?? "Failed to update achievement"
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = ex.Message
                });
            }
        }

        // AJAX: Get Monthly Target Summary
        [HttpGet]
        public async Task<IActionResult> GetMonthlySummary(int year)
        {
            var token = _authService.GetToken(HttpContext);

            try
            {
                var response = await _apiService.GetApiResponseAsync<List<MonthlyTargetSummary>>(
                    $"targets/summary/{year}", token);

                if (response?.Success == true)
                {
                    return Json(new
                    {
                        success = true,
                        data = response.Data ?? new List<MonthlyTargetSummary>()
                    });
                }

                return Json(new
                {
                    success = false,
                    message = response?.Message ?? "Failed to load summary"
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = ex.Message
                });
            }
        }

        // Export to Excel
        [HttpGet]
        public async Task<IActionResult> ExportToExcel(int? salesRepId, int? month, int? year)
        {
            var token = _authService.GetToken(HttpContext);

            try
            {
                var queryParams = new List<string>();
                if (salesRepId.HasValue)
                    queryParams.Add($"salesRepId={salesRepId.Value}");
                if (month.HasValue)
                    queryParams.Add($"month={month.Value}");
                if (year.HasValue)
                    queryParams.Add($"year={year.Value}");

                var queryString = queryParams.Any() ? "?" + string.Join("&", queryParams) : "";
                var response = await _apiService.GetApiResponseAsync<List<TargetViewModel>>(
                    $"targets/export/excel{queryString}", token);

                if (response?.Success == true)
                {
                    return Json(new
                    {
                        success = true,
                        message = $"Export ready for {response.Data?.Count ?? 0} records",
                        count = response.Data?.Count ?? 0
                    });
                }

                return Json(new
                {
                    success = false,
                    message = response?.Message ?? "Failed to prepare export"
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    success = false,
                    message = ex.Message
                });
            }
        }
    }
}
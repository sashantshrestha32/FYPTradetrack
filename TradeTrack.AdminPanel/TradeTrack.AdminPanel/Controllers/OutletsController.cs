using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
    [Authorize(Roles = "Admin")]
    public class OutletsController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        public OutletsController(IApiService apiService, IAuthService authService)
        {
            _apiService = apiService;
            _authService = authService;
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 10)
        {
            var token = _authService.GetToken(HttpContext);
            var outlets = await _apiService.GetAsync<List<OutletViewModel>>($"outlets?page={page}&pageSize={pageSize}", token);

            var viewModel = new OutletListViewModel
            {
                Outlets = outlets ?? new List<OutletViewModel>(),
                Page = page,
                PageSize = pageSize,
                TotalCount = outlets?.Count ?? 0
            };

            return View(viewModel);
        }

        public IActionResult Create()
        {
            return View(new OutletViewModel());
        }


        [HttpGet]
        public async Task<IActionResult> GetOutletStats()
        {
            try
            {
                var token = _authService.GetToken(HttpContext);
                var outlets = await _apiService.GetAsync<List<OutletViewModel>>("outlets", token);

                var dashboard = await _apiService.GetAsync<DashboardViewModel>("reports/summary", token);

                return Json(new
                {
                    totalOutlets = dashboard?.TotalOutlets ?? 0,
                    activeOutlets = outlets?.Count(o => o.IsActive) ?? 0,
                    totalVisits = outlets?.Sum(o => o.VisitCount) ?? 0
                });
            }
            catch
            {
                return Json(new
                {
                    totalOutlets = 0,
                    activeOutlets = 0,
                    totalVisits = 0
                });
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetOutletsForMap()
        {
            try
            {
                var token = _authService.GetToken(HttpContext);
                var outlets = await _apiService.GetAsync<List<OutletViewModel>>("outlets", token);

                var mapOutlets = outlets?
                    .Where(o => o.Latitude != 0 && o.Longitude != 0)
                    .Select(o => new
                    {
                        outletName = o.OutletName,
                        location = o.Location,
                        latitude = o.Latitude,
                        longitude = o.Longitude,
                        isActive = o.IsActive
                    })
                    .ToList();
             //   return Json(lowStockProducts ?? Enumerable.Empty<object>());


                return Json(mapOutlets ?? Enumerable.Empty<object>());
            }
            catch
            {
                return Json(new List<object>());
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(OutletViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var token = _authService.GetToken(HttpContext);
            var result = await _apiService.PostAsync<OutletViewModel>("outlets", model, token);

            if (result != null)
            {
                TempData["SuccessMessage"] = "Outlet created successfully!";
                return RedirectToAction("Index");
            }

            ModelState.AddModelError(string.Empty, "Failed to create outlet.");
            return View(model);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var token = _authService.GetToken(HttpContext);
            var outlet = await _apiService.GetAsync<OutletViewModel>($"outlets/{id}", token);

            if (outlet == null)
            {
                return NotFound();
            }

            return View(outlet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, OutletViewModel model)
        {
            if (id != model.Id)
            {
                return BadRequest();
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var token = _authService.GetToken(HttpContext);
            var result = await _apiService.PutAsync<OutletViewModel>($"outlets/{id}", model, token);

            if (result != null)
            {
                TempData["SuccessMessage"] = "Outlet updated successfully!";
                return RedirectToAction("Index");
            }

            ModelState.AddModelError(string.Empty, "Failed to update outlet.");
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var token = _authService.GetToken(HttpContext);
            var success = await _apiService.DeleteAsync($"outlets/{id}", token);

            if (success)
            {
                TempData["SuccessMessage"] = "Outlet deleted successfully!";
            }
            else
            {
                TempData["ErrorMessage"] = "Failed to delete outlet.";
            }

            return RedirectToAction("Index");
        }

        public async Task<IActionResult> Details(int id)
        {
            var token = _authService.GetToken(HttpContext);
            var outlet = await _apiService.GetAsync<OutletViewModel>($"outlets/{id}", token);

            if (outlet == null)
            {
                return NotFound();
            }

            return View(outlet);
        }
    }
}
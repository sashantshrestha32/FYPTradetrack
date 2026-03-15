using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TradeTrack.AdminPanel.Models;
using TradeTrack.AdminPanel.Services;

namespace TradeTrack.AdminPanel.Controllers
{
    [Authorize(Roles = "Admin")]
    public class ProductsController : Controller
    {
        private readonly IApiService _apiService;
        private readonly IAuthService _authService;

        public ProductsController(IApiService apiService, IAuthService authService)
        {
            _apiService = apiService;
            _authService = authService;
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 10)
        {
            var token = _authService.GetToken(HttpContext);
            var products = await _apiService.GetAsync<List<ProductViewModel>>($"products?page={page}&pageSize={pageSize}", token);

            var viewModel = new ProductListViewModel
            {
                Products = products ?? new List<ProductViewModel>(),
                Page = page,
                PageSize = pageSize,
                TotalCount = products?.Count ?? 0
            };

            return View(viewModel);
        }

        public IActionResult Create()
        {
            return View(new ProductViewModel());
        }


        [HttpGet]
        public async Task<IActionResult> GetLowStockProducts()
        {
            try
            {
                var token = _authService.GetToken(HttpContext);
                var products = await _apiService.GetAsync<List<ProductViewModel>>("products", token);

                var lowStockProducts = products?
                    .Where(p => p.CurrentStock < 10 && p.IsActive)
                    .Select(p => new
                    {
                        id = p.Id,
                        name = p.Name,
                        code = p.Code,
                        currentStock = p.CurrentStock
                    })
                    .ToList();

                return Json(lowStockProducts ?? Enumerable.Empty<object>());

            }
            catch
            {
                return Json(new List<object>());
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ProductViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var token = _authService.GetToken(HttpContext);
            var result = await _apiService.PostAsync<ProductViewModel>("products", model, token);

            if (result != null)
            {
                TempData["SuccessMessage"] = "Product created successfully!";
                return RedirectToAction("Index");
            }

            ModelState.AddModelError(string.Empty, "Failed to create product.");
            return View(model);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var token = _authService.GetToken(HttpContext);
            var product = await _apiService.GetAsync<ProductViewModel>($"products/{id}", token);

            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, ProductViewModel model)
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
            var result = await _apiService.PutAsync<ProductViewModel>($"products/{id}", model, token);

            if (result != null)
            {
                TempData["SuccessMessage"] = "Product updated successfully!";
                return RedirectToAction("Index");
            }

            ModelState.AddModelError(string.Empty, "Failed to update product.");
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var token = _authService.GetToken(HttpContext);
            var success = await _apiService.DeleteAsync($"products/{id}", token);

            if (success)
            {
                TempData["SuccessMessage"] = "Product deleted successfully!";
            }
            else
            {
                TempData["ErrorMessage"] = "Failed to delete product.";
            }

            return RedirectToAction("Index");
        }

        public async Task<IActionResult> Details(int id)
        {
            var token = _authService.GetToken(HttpContext);
            var product = await _apiService.GetAsync<ProductViewModel>($"products/{id}", token);

            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }
    }
}
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using TradeTrack.AdminPanel.Models;

namespace TradeTrack.AdminPanel.Services
{
    public class AuthService : IAuthService
    {
        private readonly IApiService _apiService;
        private readonly IConfiguration _configuration;
        private readonly ILogger<AuthService> _logger;

        public AuthService(IApiService apiService, IConfiguration configuration, ILogger<AuthService> logger)
        {
            _apiService = apiService;
            _configuration = configuration;
            _logger = logger;
        }

        public async Task<bool> LoginAsync(LoginModel model, HttpContext httpContext)
        {
            try
            {
                var loginData = new
                {
                    Email = model.Email,
                    Password = model.Password
                };

                var response = await _apiService.PostAsync<object>("auth/login", loginData);

                if (response != null)
                {
                    httpContext.Session.SetString("AuthToken", GetTokenFromResponse(response));

                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Name, model.Email),
                        new Claim(ClaimTypes.Role, "Admin"),
                        new Claim("Email", model.Email)
                    };

                    var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    var authProperties = new AuthenticationProperties
                    {
                        IsPersistent = model.RememberMe,
                        ExpiresUtc = DateTimeOffset.UtcNow.AddHours(8)
                    };

                    await httpContext.SignInAsync(
                        CookieAuthenticationDefaults.AuthenticationScheme,
                        new ClaimsPrincipal(claimsIdentity),
                        authProperties);

                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during login");
                return false;
            }
        }

        public async Task LogoutAsync(HttpContext httpContext)
        {
            await httpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            httpContext.Session.Clear();
        }

        public string GetToken(HttpContext httpContext)
        {
            return httpContext.Session.GetString("AuthToken") ?? string.Empty;
        }

        public bool IsAuthenticated(HttpContext httpContext)
        {
            return httpContext.User.Identity?.IsAuthenticated ?? false;
        }

        private string GetTokenFromResponse(object response)
        {
            try
            {
                var json = Newtonsoft.Json.JsonConvert.SerializeObject(response);
                dynamic data = Newtonsoft.Json.JsonConvert.DeserializeObject(json)!;
                return data?.token ?? string.Empty;
            }
            catch
            {
                return string.Empty;
            }
        }
    }
}
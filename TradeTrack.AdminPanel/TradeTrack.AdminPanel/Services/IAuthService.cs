using TradeTrack.AdminPanel.Models;

namespace TradeTrack.AdminPanel.Services
{
    public interface IAuthService
    {
        Task<bool> LoginAsync(LoginModel model, HttpContext httpContext);
        Task LogoutAsync(HttpContext httpContext);
        string GetToken(HttpContext httpContext);
        bool IsAuthenticated(HttpContext httpContext);
    }
}
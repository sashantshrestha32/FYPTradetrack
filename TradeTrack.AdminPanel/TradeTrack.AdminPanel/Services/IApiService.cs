using TradeTrack.AdminPanel.Models;

namespace TradeTrack.AdminPanel.Services
{
    public interface IApiService
    {
        Task<T?> GetAsync<T>(string endpoint, string? token = null);
        Task<T?> PostAsync<T>(string endpoint, object data, string? token = null);
        Task<T?> PutAsync<T>(string endpoint, object data, string? token = null);
        Task<bool> DeleteAsync(string endpoint, string? token = null);
        Task<ApiResponse<T>> GetApiResponseAsync<T>(string endpoint, string? token = null);
    }
}
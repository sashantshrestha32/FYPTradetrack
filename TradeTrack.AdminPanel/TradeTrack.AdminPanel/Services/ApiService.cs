using System.Text;
using Newtonsoft.Json;
using TradeTrack.AdminPanel.Models;

namespace TradeTrack.AdminPanel.Services
{
    public class ApiService : IApiService
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IConfiguration _configuration;
        private readonly ILogger<ApiService> _logger;

        public ApiService(IHttpClientFactory httpClientFactory, IConfiguration configuration, ILogger<ApiService> logger)
        {
            _httpClientFactory = httpClientFactory;
            _configuration = configuration;
            _logger = logger;
        }

        private HttpClient CreateClient(string? token = null)
        {
            var client = _httpClientFactory.CreateClient();
            client.BaseAddress = new Uri(_configuration["ApiSettings:BaseUrl"]!);
            client.Timeout = TimeSpan.FromSeconds(_configuration.GetValue<int>("ApiSettings:TimeoutSeconds", 30));

            if (!string.IsNullOrEmpty(token))
            {
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}");
            }

            return client;
        }

        public async Task<T?> GetAsync<T>(string endpoint, string? token = null)
        {
            try
            {
                using var client = CreateClient(token);
                var response = await client.GetAsync(endpoint);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<T>>(content);
                    return apiResponse != null ? apiResponse.Data : default;

                }

                _logger.LogError($"API GET failed: {response.StatusCode} - {endpoint}");
                return default;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error in GetAsync for endpoint: {endpoint}");
                return default;
            }
        }

        public async Task<T?> PostAsync<T>(string endpoint, object data, string? token = null)
        {
            try
            {
                using var client = CreateClient(token);
                var json = JsonConvert.SerializeObject(data);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync(endpoint, content);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<T>>(responseContent);
                    return apiResponse != null ? apiResponse.Data : default;
                }

                _logger.LogError($"API POST failed: {response.StatusCode} - {endpoint}");
                return default;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error in PostAsync for endpoint: {endpoint}");
                return default;
            }
        }

        public async Task<T?> PutAsync<T>(string endpoint, object data, string? token = null)
        {
            try
            {
                using var client = CreateClient(token);
                var json = JsonConvert.SerializeObject(data);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PutAsync(endpoint, content);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<T>>(responseContent);
                    return apiResponse != null ? apiResponse.Data : default;
                }

                _logger.LogError($"API PUT failed: {response.StatusCode} - {endpoint}");
                return default;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error in PutAsync for endpoint: {endpoint}");
                return default;
            }
        }

        public async Task<bool> DeleteAsync(string endpoint, string? token = null)
        {
            try
            {
                using var client = CreateClient(token);
                var response = await client.DeleteAsync(endpoint);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error in DeleteAsync for endpoint: {endpoint}");
                return false;
            }
        }

        public async Task<ApiResponse<T>> GetApiResponseAsync<T>(string endpoint, string? token = null)
        {
            try
            {
                using var client = CreateClient(token);
                var response = await client.GetAsync(endpoint);

                var content = await response.Content.ReadAsStringAsync();
                var apiResponse = JsonConvert.DeserializeObject<ApiResponse<T>>(content);

                return apiResponse ?? new ApiResponse<T> { Success = false, Message = "Invalid response format" };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error in GetApiResponseAsync for endpoint: {endpoint}");
                return new ApiResponse<T> { Success = false, Message = ex.Message };
            }
        }
    }
}
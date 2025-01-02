using Amazon.S3;
using Microsoft.AspNetCore.Mvc;

namespace S3TestApi.Controllers;

[ApiController]
[Route("[controller]")]
public class S3Controller : ControllerBase
{
    private readonly IAmazonS3 _s3Client;
    private readonly ILogger<S3Controller> _logger;

    public S3Controller(IAmazonS3 s3Client, ILogger<S3Controller> logger)
    {
        _s3Client = s3Client;
        _logger = logger;
    }

    [HttpGet("file")]
    public async Task<IActionResult> GetFile(string bucketName, string fileName)
    {
        try
        {
            var response = await _s3Client.GetObjectAsync(bucketName, fileName);
            
            // Registrar información sobre las credenciales actuales (útil para debugging)
            _logger.LogInformation("Successfully accessed S3");
            
            return File(response.ResponseStream, response.Headers.ContentType);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error accessing S3");
            return StatusCode(500, ex.Message);
        }
    }
}
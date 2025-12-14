var builder = WebApplication.CreateBuilder(args);

// 1️⃣ Forzar logging a consola (stdout)
builder.Logging.ClearProviders();
builder.Logging.AddConsole();

var app = builder.Build();

// 2️⃣ Endpoints con logging explícito
app.MapGet("/", (ILogger<Program> logger) =>
{
    logger.LogInformation("GET / called");
    return "OK - Dynatrace PoC (.NET 9)";
});

app.MapGet("/slow", async (ILogger<Program> logger) =>
{
    logger.LogInformation("GET /slow started");
    await Task.Delay(800);
    logger.LogInformation("GET /slow finished");
    return Results.Ok("slow ok");
});

app.MapGet("/error", (ILogger<Program> logger) =>
{
    logger.LogError("GET /error simulated failure");
    return Results.Problem("boom");
});

app.Run();

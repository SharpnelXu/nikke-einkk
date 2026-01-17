using Microsoft.AspNetCore.Localization;
using NikkeEinkk.Components;
using NikkeEinkk.Components.Models;

var builder = WebApplication.CreateBuilder(args);

// Configure NikkeDatabase options from appsettings.json
builder.Services.Configure<NikkeDatabaseOptions>(
    builder.Configuration.GetSection(NikkeDatabaseOptions.SectionName));

// Register NikkeDatabaseProvider as a singleton service
builder.Services.AddSingleton<NikkeDatabaseProvider>();

// Add HttpContextAccessor for accessing HttpContext in components
builder.Services.AddHttpContextAccessor();

// Add localization services
builder.Services.AddLocalization(options => options.ResourcesPath = "Resources");
builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    var supportedCultures = new[] { "en", "zh" };
    options.SetDefaultCulture(supportedCultures[0])
        .AddSupportedCultures(supportedCultures)
        .AddSupportedUICultures(supportedCultures);
});

// Add Blazor services
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// Add controllers for API endpoints
builder.Services.AddControllers();

var app = builder.Build();

// Load the Nikke databases at startup
var dbProvider = app.Services.GetRequiredService<NikkeDatabaseProvider>();
dbProvider.LoadAll();

// Configure the HTTP request pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRequestLocalization();
app.UseAntiforgery();

// Endpoint to set culture cookie
app.MapGet("/api/set-culture", (string culture, string redirectUri, HttpContext context) =>
{
    context.Response.Cookies.Append(
        CookieRequestCultureProvider.DefaultCookieName,
        CookieRequestCultureProvider.MakeCookieValue(new RequestCulture(culture)),
        new CookieOptions { Expires = DateTimeOffset.UtcNow.AddYears(1) }
    );
    return Results.LocalRedirect(redirectUri);
});

// Map controllers
app.MapControllers();

// Map Blazor components
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();


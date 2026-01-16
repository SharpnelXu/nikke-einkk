using NikkeEinkk.Components;
using NikkeEinkk.Components.Models;

var builder = WebApplication.CreateBuilder(args);

// Configure NikkeDatabase options from appsettings.json
builder.Services.Configure<NikkeDatabaseOptions>(
    builder.Configuration.GetSection(NikkeDatabaseOptions.SectionName));

// Register NikkeDatabaseProvider as a singleton service
builder.Services.AddSingleton<NikkeDatabaseProvider>();

// Add Blazor services
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

var app = builder.Build();

// Configure the HTTP request pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAntiforgery();

// Map Blazor components
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();


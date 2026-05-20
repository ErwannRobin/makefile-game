# 🌤️ Meteo

Weather forecast tool powered by [wttr.in](https://wttr.in), implemented in GNU Make.

## How to Use

```bash
make play              # 3-day forecast (default: Paris)
make play CITY=London  # Specify city
make current           # One-line current conditions
make compact           # Compact format
make week              # 7-day extended forecast
make moon              # Current moon phase
```

## Screenshot

```
  ┌─────────────────────────────────┐
  │      ☁️  M E T E O  ☀️           │
  │      Weather Forecast           │
  └─────────────────────────────────┘

  Fetching weather for Paris…

  Weather report: Paris

      \   /     Sunny
       .-.      22 °C
    ― (   ) ―   ↗ 12 km/h
       `-'      10 km
      /   \     0.0 mm
```

## Options

| Variable | Default | Description |
|----------|---------|-------------|
| `CITY`   | Paris   | City name   |
| `DAYS`   | 3       | Forecast days (1-3) |
| `WLANG`  | en      | Language code |

```bash
make play CITY=Tokyo DAYS=1 WLANG=ja
```

## Requirements

- `curl` — for fetching weather data
- Internet connection

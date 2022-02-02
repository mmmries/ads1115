defmodule Ads1115.MixProject do
  use Mix.Project

  def project do
    [
      app: :ads1115,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:circuits_i2c, "~> 0.3"},
      {:dialyxir, "1.0.0-rc.6", only: :dev},
      {:ex_doc, "~> 0.20", only: :dev}
    ]
  end

  defp package do
    [
      description: "Interact with ADS1115 Analog-to-Digital Chips",
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/mmmries/ads1115"
      },
      maintainers: [
        "Michael Ries"
      ]
    ]
  end
end

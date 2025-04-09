defmodule Ads1115.MixProject do
  use Mix.Project

  def project do
    [
      app: :ads1115,
      version: "0.2.2",
      elixir: "~> 1.13",
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
      {:circuits_i2c, "~> 2.1"},
      {:dialyxir, "1.4.5", only: :dev},
      {:ex_doc, "~> 0.37", only: :dev}
    ]
  end

  defp package do
    [
      description: "Interact with ADS1115 or ADS1015 Analog-to-Digital Chips",
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

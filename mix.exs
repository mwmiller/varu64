defmodule Varu64.MixProject do
  use Mix.Project

  def project do
    [
      app: :varu64,
      version: "1.0.2",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      name: "Varu64",
      source_url: "https://github.com/mwmiller/varu64",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Varu64 - a pure Elixir variable length unsigned 64-bit integer encoding
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Matt Miller"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/mwmiller/varu64",
        "Encoding description" => "https://github.com/AljoschaMeyer/varu64"
      }
    ]
  end
end

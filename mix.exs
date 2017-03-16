defmodule NervesStartNetwork.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :nerves_start_network,
     version: "0.1.0",
     elixir: "~> 1.4.0",
     archives: [nerves_bootstrap: "~> 0.3.0"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     target: @target,
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  def application do
    [mod: {StartNetwork, []},
     applications: [:logger,
                    :nerves_networking,
                    :nerves_ssdp_server,
                    :nerves_lib]]
  end

  defp deps do
    [{:nerves, "~> 0.5.0"},
     {:nerves_lib, github: "nerves-project/nerves_lib"},
     {:nerves_networking, github: "nerves-project/nerves_networking"},
     {:nerves_ssdp_server, github: "nerves-project/nerves_ssdp_server"}]
  end

  def system(target) do
    [
     {:"nerves_system_#{target}", "~> 0.11.0"}
    ]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end

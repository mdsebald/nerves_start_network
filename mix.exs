defmodule NervesStartNetwork.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  Mix.shell.info([:green, """
  Env
    MIX_TARGET:   #{@target}
    MIX_ENV:      #{Mix.env}
  """, :reset])
  
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
     aliases: aliases(@target),
     deps: deps()]
  end


  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: application(@target)
  
  # Specify target specific application configurations
  # It is common that the application start function will start and supervise
  # applications which could cause the host to fail. Because of this, we only
  # invoke StartNetwork.start/2 when running on a target.
  def application("host") do
    [extra_applications: [:logger,
                          :nerves_networking,
                          :nerves_ssdp_server,
                          :nerves_lib]]
  end
  def application(_target) do
    [mod: {StartNetwork, []},
     extra_applications: [:logger,
                          :nerves_networking,
                          :nerves_ssdp_server,
                          :nerves_lib]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
   def deps do
    [{:nerves, "~> 0.5.0", runtime: false}] ++
    deps(@target)
  end
  
  # Specify target specific dependencies
  def deps("host"), do: []
  def deps(target) do
    [
     {:"nerves_system_#{target}", "~> 0.11.0"},
     {:nerves_lib, github: "nerves-project/nerves_lib"},
     {:nerves_networking, github: "nerves-project/nerves_networking"},
     {:nerves_ssdp_server, github: "nerves-project/nerves_ssdp_server"}]
  end
  
  # We do not invoke the Nerves Env when running on the Host
  def aliases("host"), do: []
  def aliases(_target) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end

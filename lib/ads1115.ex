defmodule ADS1115 do
  alias Circuits.I2C
  alias ADS1115.Config

  @config_register <<1>>
  @sensor_register <<0>>

  @spec config(reference(), byte()) :: {:ok, Config.t} | {:error, term()}
  def config(bus, addr) do
    case I2C.write_read(bus, addr, @config_register, 2) do
      {:ok, bytes} -> {:ok, Config.decode(bytes)}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec single_shot_read(reference(), byte(), Config.comparison, Config.gain) :: {:ok, integer()} | {:error, term()}
  def single_shot_read(bus, addr, comparison, gain \\ 2048) do
    config = %Config{performing_conversion: false, mode: :single_shot, mux: comparison, gain: gain}
    data = @config_register <> Config.encode(config)
    with :ok <- I2C.write(bus, addr, data),
         :ok <- wait_for_reading(bus, addr),
         {:ok, <<val::signed-size(16)>>} <- I2C.write_read(bus, addr, @sensor_register, 2)
         do
          {:ok, val}
         end
  end

  defp wait_for_reading(bus, addr), do: wait_for_reading(bus, addr, config(bus, addr))
  defp wait_for_reading(_bus, _addr, {:error, reason}), do: {:error, reason}
  defp wait_for_reading(_bus, _addr, {:ok, %Config{performing_conversion: false}}), do: :ok
  defp wait_for_reading(bus, addr, _config) do
    wait_for_reading(bus, addr, config(bus, addr))
  end
end

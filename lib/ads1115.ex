defmodule ADS1115 do
  alias Circuits.I2C
  alias ADS1115.Config

  @spec config(reference(), byte()) :: Config.t
  def config(bus, addr) do
    {:ok, bytes} = I2C.write_read(bus, addr, <<1>>, 2)
    Config.decode(bytes)
  end

  def read(bus, addr, config) do
    I2C.write(bus, addr, <<1>> <> Config.encode(config))
    wait_for_reading(bus, addr)
    {:ok, <<val::signed-size(16)>>} = I2C.write_read(bus, addr, <<0>>, 2)
    val
  end

  defp wait_for_reading(bus, addr), do: wait_for_reading(bus, addr, config(bus, addr))
  defp wait_for_reading(_bus, _addr, %Config{performing_conversion: false}), do: :ok
  defp wait_for_reading(bus, addr, _config) do
    :timer.sleep(2)
    wait_for_reading(bus, addr, config(bus, addr))
  end
end

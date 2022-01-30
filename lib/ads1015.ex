defmodule ADS1015 do
  @moduledoc """
  Functions to interact with an ADS1015 analog-to-digital chip
  """

  alias Circuits.I2C
  alias ADS1015.Config

  @config_register <<1>>
  @sensor_register <<0>>

  @doc "Read the current configuration from the device"
  @spec config(reference(), byte()) :: {:ok, Config.t()} | {:error, term()}
  def config(bus, addr) do
    case I2C.write_read(bus, addr, @config_register, 2) do
      {:ok, bytes} -> {:ok, Config.decode(bytes)}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc "Set the configuration on the device"
  @spec set_config(reference(), I2C.address(), Config.t()) :: :ok | {:error, term()}
  def set_config(bus, addr, %Config{}=config) do
    bytes = @config_register <> Config.encode(config)
    I2C.write(bus, addr, bytes)
  end

  @doc "Ask for a reading for one of the analog signals with default settings"
  @spec read(reference(), byte(), Config.comparison(), Config.gain()) ::
          {:ok, integer()} | {:error, term()}
  def read(bus, addr, comparison, gain \\ 2048) do
    config = %Config{
      performing_conversion: false,
      mode: :single_shot,
      mux: comparison,
      gain: gain
    }

    custom_read(bus, addr, config)
  end

 @doc """
  Ask for a reading of an analog signal with customizable comparison parameters.

  This will write the configuration register, then wait for the reading to be ready and read it back.
  Make sure to set `performing_conversion: false` and `mode: :single_shot` so that the chip will know
  we are waiting for a reading.

  ADS1015 uses 16bit register but it has a 12bit value.
  """
  @spec custom_read(reference(), I2C.address(), Config.t()) :: {:ok, integer()} | {:error, term()}
  def custom_read(bus, addr, %Config{}=config) do
    with :ok <- set_config(bus, addr, config),
         :ok <- wait_for_reading(bus, addr),
         {:ok, <<val::signed-size(16)>>} <- I2C.write_read(bus, addr, @sensor_register, 2) do

           val = val / 16 # equivalent to val >> 4
           if val > 2047 do   # 0x7FF
             {:ok, val - 4096}  # double 2048
           else
             {:ok, val}
           end
    end
  end

  defp wait_for_reading(bus, addr), do: wait_for_reading(bus, addr, config(bus, addr))
  defp wait_for_reading(_bus, _addr, {:error, reason}), do: {:error, reason}
  defp wait_for_reading(_bus, _addr, {:ok, %Config{performing_conversion: false}}), do: :ok

  defp wait_for_reading(bus, addr, _config) do
    wait_for_reading(bus, addr, config(bus, addr))
  end
end

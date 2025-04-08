defmodule ADS1015.Config do
  @moduledoc """
  A struct representing the configuration of an ADS1015 chip.

  This module handles decoding the 2-byte binary representation of the register
  into a struct and also encoding a struct back into the 2-byte binary representation.
  For details about what the various configuration options mean, please see
  [the datasheet](http://www.ti.com/lit/gpn/ads1015).
  """

  @type comp_mode :: :traditional | :window
  @type comp_polarity :: :active_low | :active_high
  @type comp_queue :: 1 | 2 | 3 | :disabled
  @type comparison ::
          {:ain0, :ain1 | :ain3 | :gnd}
          | {:ain1, :ain3 | :gnd}
          | {:ain2, :ain3 | :gnd}
          | {:ain3, :gnd}
  @type data_rate :: 128 | 250 | 490 | 920 | 1600 | 2400 | 3300 | 3300
  @type gain :: 256 | 512 | 1024 | 2048 | 4096 | 6144
  @type mode :: :continuous | :single_shot
  @type t :: %__MODULE__{
          performing_conversion: true | false,
          mux: comparison,
          gain: gain,
          mode: mode,
          data_rate: data_rate,
          comp_mode: comp_mode,
          comp_polarity: comp_polarity,
          comp_latch: true | false,
          comp_queue: comp_queue
        }
  defstruct performing_conversion: false,
            # default
            mux: {:ain0, :ain1},
            # default
            gain: 2048,
            mode: :single_shot,
            # default
            data_rate: 1600,
            comp_mode: :traditional,
            comp_polarity: :active_low,
            comp_latch: false,
            comp_queue: :disabled

  @spec encode(ADS1015.Config.t()) :: <<_::16>>
  def encode(%__MODULE__{} = config) do
    <<
      encode_performing_conversion(config.performing_conversion)::size(1),
      encode_mux(config.mux)::size(3),
      encode_gain(config.gain)::size(3),
      encode_mode(config.mode)::size(1),
      encode_data_rate(config.data_rate)::size(3),
      encode_comp_mode(config.comp_mode)::size(1),
      encode_comp_polarity(config.comp_polarity)::size(1),
      encode_comp_latch(config.comp_latch)::size(1),
      encode_comp_queue(config.comp_queue)::size(2)
    >>
  end

  @spec decode(<<_::16>>) :: ADS1015.Config.t()
  def decode(bytes) when is_binary(bytes) do
    <<performing_conversion::size(1), mux::size(3), gain::size(3), mode::size(1),
      data_rate::size(3), comp_mode::size(1), comp_polarity::size(1), comp_latch::size(1),
      comp_queue::size(2)>> = bytes

    %__MODULE__{
      performing_conversion: performing_conversion(performing_conversion),
      mux: mux(mux),
      gain: gain(gain),
      mode: mode(mode),
      data_rate: data_rate(data_rate),
      comp_mode: comp_mode(comp_mode),
      comp_polarity: comp_polarity(comp_polarity),
      comp_latch: comp_latch(comp_latch),
      comp_queue: comp_queue(comp_queue)
    }
  end

  defp encode_performing_conversion(true), do: 0
  defp encode_performing_conversion(false), do: 1

  # default
  defp encode_mux({:ain0, :ain1}), do: 0
  defp encode_mux({:ain0, :ain3}), do: 1
  defp encode_mux({:ain1, :ain3}), do: 2
  defp encode_mux({:ain2, :ain3}), do: 3
  defp encode_mux({:ain0, :gnd}), do: 4
  defp encode_mux({:ain1, :gnd}), do: 5
  defp encode_mux({:ain2, :gnd}), do: 6
  defp encode_mux({:ain3, :gnd}), do: 7
  defp encode_gain(6144), do: 0
  defp encode_gain(4096), do: 1

  # default
  defp encode_gain(2048), do: 2
  defp encode_gain(1024), do: 3
  defp encode_gain(512), do: 4

  # 6 and 7 map to same gain
  defp encode_gain(256), do: 5
  defp encode_mode(:continuous), do: 0
  defp encode_mode(:single_shot), do: 1
  defp encode_data_rate(128), do: 0
  defp encode_data_rate(250), do: 1
  defp encode_data_rate(490), do: 2
  defp encode_data_rate(920), do: 3

  # default
  defp encode_data_rate(1600), do: 4
  defp encode_data_rate(2400), do: 5

  # 7 maps to same data rate
  defp encode_data_rate(3300), do: 6
  defp encode_comp_mode(:traditional), do: 0
  defp encode_comp_mode(:window), do: 1
  defp encode_comp_polarity(:active_low), do: 0
  defp encode_comp_polarity(:active_high), do: 1
  defp encode_comp_latch(false), do: 0
  defp encode_comp_latch(true), do: 1
  defp encode_comp_queue(1), do: 0
  defp encode_comp_queue(2), do: 1
  defp encode_comp_queue(3), do: 2
  defp encode_comp_queue(:disabled), do: 3

  defp performing_conversion(bit), do: bit == 0
  defp mux(0), do: {:ain0, :ain1}
  defp mux(1), do: {:ain0, :ain3}
  defp mux(2), do: {:ain1, :ain3}
  defp mux(3), do: {:ain2, :ain3}
  defp mux(4), do: {:ain0, :gnd}
  defp mux(5), do: {:ain1, :gnd}
  defp mux(6), do: {:ain2, :gnd}
  defp mux(7), do: {:ain3, :gnd}
  defp gain(0), do: 6144
  defp gain(1), do: 4096
  defp gain(2), do: 2048
  defp gain(3), do: 1024
  defp gain(4), do: 512
  defp gain(5), do: 256
  defp gain(6), do: 256
  defp gain(7), do: 256
  defp mode(0), do: :continuous
  defp mode(1), do: :single_shot
  defp data_rate(0), do: 128
  defp data_rate(1), do: 250
  defp data_rate(2), do: 490
  defp data_rate(3), do: 920
  defp data_rate(4), do: 1600
  defp data_rate(5), do: 2400
  defp data_rate(6), do: 3300
  defp data_rate(7), do: 3300
  defp comp_mode(0), do: :traditional
  defp comp_mode(1), do: :window
  defp comp_polarity(0), do: :active_low
  defp comp_polarity(1), do: :active_high
  defp comp_latch(0), do: false
  defp comp_latch(1), do: true
  defp comp_queue(0), do: 1
  defp comp_queue(1), do: 2
  defp comp_queue(2), do: 3
  defp comp_queue(3), do: :disabled
end

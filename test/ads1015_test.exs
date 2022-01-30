defmodule ADS1015Test do
  use ExUnit.Case, async: true

  describe "config register decoding" do
    test "default config state" do
      assert %ADS1015.Config{} = config = ADS1015.Config.decode(<<133, 131>>)
      assert config.performing_conversion == false
      assert config.mux == {:ain0, :ain1}
      assert config.gain == 2048
      assert config.mode == :single_shot
      assert config.data_rate == 1600
      assert config.comp_mode == :traditional
      assert config.comp_polarity == :active_low
      assert config.comp_latch == false
      assert config.comp_queue == :disabled
    end

    test "comparing AIN0 vs GND" do
      assert %ADS1015.Config{} = config = ADS1015.Config.decode(<<197, 131>>)
      assert config.performing_conversion == false
      assert config.mux == {:ain0, :gnd}
      assert config.gain == 2048
      assert config.mode == :single_shot
      assert config.data_rate == 1600
      assert config.comp_mode == :traditional
      assert config.comp_polarity == :active_low
      assert config.comp_latch == false
      assert config.comp_queue == :disabled
    end
  end

  describe "config register encoding" do
    test "default config" do
      config = %ADS1015.Config{}
      assert ADS1015.Config.encode(config) == <<133, 131>>
    end

    test "custom config" do
      config = %ADS1015.Config{
        performing_conversion: false,
        mux: {:ain0, :gnd},
        gain: 2048,
        mode: :single_shot,
        data_rate: 1600,
        comp_mode: :traditional,
        comp_polarity: :active_low,
        comp_latch: false,
        comp_queue: :disabled
      }

      assert ADS1015.Config.encode(config) == <<197, 131>>
    end
  end
end

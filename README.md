# ADS1115

An Elixir library for interacting with ADS1115 and ADS1015 analog-to-digital chips.
Please see [the datasheet](http://www.ti.com/lit/gpn/ads1115) for details.

## Usage

I'm using these chips to read [moisture sensors](https://www.amazon.com/dp/B07H3P1NRM/ref=cm_sw_r_tw_dp_U_x_tvd4CbBE5DJS2).
I wired the analog signal to `AIN0` and I want to compare that to `GND`.
For this use-case I can do the following:

```elixir
{:ok, ref} = I2C.open("i2c-1")
addr = 72 # the default i2c address for my sensor
{:ok, reading} = ADS1115.single_shot_read(ref, addr, {:ain0, :gnd})
# reading will be between -32,768 and 32,767
```

You can similarly use this library to interact with ADS1015 chips like this:

```elixir
{:ok, ref} = I2C.open("i2c-1")
addr = 72 # the default i2c address for my sensor
{:ok, reading} = ADS1015.single_shot_read(ref, addr, {:ain0, :gnd})
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ads1115` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ads1115, "~> 0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ads1115](https://hexdocs.pm/ads1115).


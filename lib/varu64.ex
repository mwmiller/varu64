defmodule Varu64 do
  @moduledoc """
  Simple variable-length encoding of U64
  """

  @doc """
  Encode to Varu64 format
  ## Examples

      iex> Varu64.encode(0)
      <<0>>
      iex> Varu64.encode(18446744073709551615)
      <<255, 255, 255, 255, 255, 255, 255, 255, 255>>
  """
  @spec encode(non_neg_integer) :: binary | :error
  def encode(n) when not (is_integer(n) or n < 0), do: :error
  def encode(n) when n < 248, do: <<n>>
  def encode(n) when n < 256, do: <<248, n>>

  for bytes <- 2..8 do
    size = :math.pow(2, bytes * 8) |> trunc
    marker = 247 + bytes

    def encode(n) when n < unquote(size), do: <<unquote(marker)>> <> :binary.encode_unsigned(n)
  end

  def encode(_), do: :error

  @doc """
  Decode a Varu64 at the head of a binary

  Returns a {u64, rest_of_binary} tuple on success
  :error on failure.  Will fail on noncanonical representations

  ## Examples

      iex> Varu64.decode(<<0>>)
      {0, ""}
      iex> Varu64.decode(<<248, 255, 72, 105>>)
      {255, "Hi"}
  """
  @spec decode(binary) :: {non_neg_integer, binary} | :error
  def decode(b) when not is_binary(b), do: :error

  for bytes <- 8..2//-1 do
    bits = bytes * 8
    marker = 247 + bytes
    def decode(<<unquote(marker), 0::8, _::binary>>), do: :error
    def decode(<<unquote(marker), val::big-size(unquote(bits)), rest::binary>>), do: {val, rest}
  end

  def decode(<<248, val::big-size(8), rest::binary>>) do
    case val < 248 do
      false -> {val, rest}
      true -> :error
    end
  end

  # Guard against too short sizes, via val check
  def decode(<<val::big-size(8), rest::binary>>) when val < 248, do: {val, rest}

  def decode(_), do: :error
end

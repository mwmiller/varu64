defmodule Varu64Test do
  use ExUnit.Case
  doctest Varu64

  # Vectors sourced from https://github.com/AljoschaMeyer/varu64-rs/blob/master/src/lib.rs
  # 2022-02-20
  test "encode tests from lib.rs" do
    assert Varu64.encode(0) == <<0>>
    assert Varu64.encode(1) == <<1>>
    assert Varu64.encode(247) == <<247>>
    assert Varu64.encode(248) == <<248, 248>>
    assert Varu64.encode(255) == <<248, 255>>
    assert Varu64.encode(256) == <<249, 1, 0>>
    assert Varu64.encode(65535) == <<249, 255, 255>>
    assert Varu64.encode(65536) == <<250, 1, 0, 0>>
    assert Varu64.encode(72_057_594_037_927_935) == <<254, 255, 255, 255, 255, 255, 255, 255>>
    assert Varu64.encode(72_057_594_037_927_936) == <<255, 1, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "decode tests from lib.rs" do
    assert Varu64.decode(<<>>) == :error
    assert Varu64.decode(<<248>>) == :error
    assert Varu64.decode(<<255, 0, 1, 2, 3, 4, 5>>) == :error
    assert Varu64.decode(<<255, 0, 1, 2, 3, 4, 5, 6>>) == :error
    assert Varu64.decode(<<248, 42>>) == :error
    assert Varu64.decode(<<249, 0, 42>>) == :error
  end

  test "encode" do
    assert Varu64.encode(765) == <<249, 2, 253>>
    assert Varu64.encode(511) == <<249, 1, 255>>
  end

  test "decode" do
    assert Varu64.decode(<<249, 2, 253>>) == {765, ""}
    assert Varu64.decode(<<249, 1, 255>> <> "more data") == {511, "more data"}
  end
end

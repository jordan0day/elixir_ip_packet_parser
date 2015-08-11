defmodule IpParserTest do
  use ExUnit.Case

  setup do
    bits = File.read!("./sample_packet.bits")

    # Get a struct from the binary
    packet = IPPacket.from_bits(bits)
    {:ok, packet: packet}
  end

  test "getting protocol version", context do
    assert context[:packet].protocol_version == 4
  end

  test "getting header length in bytes", context do
    assert context[:packet].header_length_in_bytes == 20
  end

  test "getting type of service", context do
    assert context[:packet].type_of_service == :unspecified
  end

  test "getting total length in bytes", context do
    assert context[:packet].total_length_in_bytes == 44
  end

  test "getting protocol as TCP", context do
    assert context[:packet].protocol == 6
  end

  test "getting source IP", context do
    assert context[:packet].source_ip == "172.16.0.9"
  end

  test "getting destination IP", context do
    assert context[:packet].dest_ip == "172.16.0.1"
  end
end

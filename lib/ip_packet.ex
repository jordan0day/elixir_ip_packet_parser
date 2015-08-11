defmodule IPPacket do
  # Reference for structure of an IP packet:
  # http://mike.passwall.com/networking/ippacket.html
  defstruct protocol_version: nil,
            header_length_in_bytes: nil,
            type_of_service: nil,
            total_length_in_bytes: nil,
            identification: nil,
            flags: nil,
            fragment_offset: nil,
            ttl: nil,
            protocol: nil,
            header_checksum: nil,
            source_ip: nil,
            dest_ip: nil,
            options: nil,
            data: nil

  def from_bits(bits) do
    << protocol_version :: size(4),
       header_length_in_words :: size(4),
       _type_of_service_legacy :: size(4),
       type_of_service_int :: size(4),
       total_length_in_bytes :: size(16),
       identification :: size(16),
       flags :: size(3),
       fragment_offset :: size(13),
       ttl :: size(8),
       protocol :: size(8),
       header_checksum :: size(16),
       source_ip_a :: size(8),
       source_ip_b :: size(8),
       source_ip_c :: size(8),
       source_ip_d :: size(8),
       dest_ip_a :: size(8),
       dest_ip_b :: size(8),
       dest_ip_c :: size(8),
       dest_ip_d :: size(8),
       rest :: bitstring >> = bits

    header_length_in_bytes = header_length_in_words * (32 / 8)   

    options_size = trunc((20 - header_length_in_bytes) * 8)
    data_size = trunc((total_length_in_bytes - header_length_in_bytes) * 8)

    << options :: size(options_size),
       data :: size(data_size) >> = rest

    %IPPacket{
      protocol_version: protocol_version,
      header_length_in_bytes: header_length_in_bytes,
      type_of_service: type_of_service_for(type_of_service_int),
      total_length_in_bytes: total_length_in_bytes,
      identification: identification,
      flags: flags,
      fragment_offset: fragment_offset,
      ttl: ttl,
      protocol: protocol,
      header_checksum: header_checksum,
      source_ip: "#{source_ip_a}.#{source_ip_b}.#{source_ip_c}.#{source_ip_d}",
      dest_ip: "#{dest_ip_a}.#{dest_ip_b}.#{dest_ip_c}.#{dest_ip_d}",
      options: options,
      data: data
    }
  end

  defp type_of_service_for(type_of_service_int) do
    case type_of_service_int do
      8 -> :minimize_delay
      4 -> :maximize_throughput
      2 -> :maximize_reliability
      1 -> :minimize_monetary_cost
      0 -> :unspecified
    end
  end
end
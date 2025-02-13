defmodule DNA do
  @space 32

  def encode_nucleotide(code_point) do
    case code_point do
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
      _ -> 0b0000
    end
  end

  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0b0001 -> ?A
      0b0010 -> ?C
      0b0100 -> ?G
      0b1000 -> ?T
      _ -> @space
    end
  end

  def encode([], acc) do
    acc
  end

  def encode(dna, acc) do
    [head | rest] = dna
    head = encode_nucleotide(head)
    encode(rest, <<acc::bitstring, head::4>>)
  end

  def encode(dna) do
    [head | rest] = dna

    encode(rest, <<encode_nucleotide(head)::4>>)
  end

  def decode(dna), do: do_decode(dna, '')
  defp do_decode(<<>>, acc), do: acc

  defp do_decode(<<first::4, rest::bitstring>>, acc),
    do: do_decode(rest, acc ++ [decode_nucleotide(first)])
end

defmodule Id3V1 do

  def dir(dir) do
    Path.join(dir, "*.mp3")
    |> Path.wildcard()
    |> Enum.map(&read_id3_tag/1)
    |> Enum.filter(fn x -> x != :error end)
    |> dump("mp3data")
  end

  def read_id3_tag(file) do
    case File.read(file) do
      {:ok, binary} ->
        mp3_byte_size = byte_size(binary) - 128
        <<_ :: binary-size(mp3_byte_size), id3_tag :: binary>> = binary
        result = parse_v1_tag(id3_tag)
        result
      _error ->
        :error
    end
  end

  def parse_v1_tag(<<"TAG",
    title :: binary-size(30),
    artist :: binary-size(30),
    album :: binary-size(30),
    _year :: binary-size(4),
    _comment :: binary-size(28),
    0 :: 1,
    track :: binary-size(1),
    _genre :: binary-size(1)>>) do
      {"ID3v1.1",
        [{:track, track}, {:title, String.trim(title)},
         {:artist, String.trim(artist)}, {:album, String.trim(album)}]}
  end

  def parse_v1_tag(<<"TAG",
    title :: binary-size(30),
    artist :: binary-size(30),
    album :: binary-size(30),
    _year :: binary-size(4),
    _comment :: binary-size(30),
    _genre :: binary-size(1)>>) do
      {"ID3v1",
        [{:title, String.trim(title)},
         {:artist, String.trim(artist)}, {:album, String.trim(album)}]}
  end

  def parse_v1_tag(_), do: :error

  def dump(term, file) do
    out = file <> ".tmp"
    IO.puts("** dumping to #{out}")
    File.write!(out, :erlang.term_to_binary(term))
    IO.inspect(term)
  end

end

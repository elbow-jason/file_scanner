defmodule FileScanner do
  @moduledoc """
  Documentation for FileScanner.
  """

  defstruct [
    :path,
    :position,
    :delimiter,
    :chunk_size,
    :file,
  ]

  def new(path, options \\ []) when is_binary(path) and is_list(options) do
    with \
      {:ok, file} <- File.open(path)
    do
      %FileScanner{
        path: path,
        file: file,
        position:   Keyword.get(options, :position, 0),
        delimiter:  Keyword.get(options, :delimiter, "\n"),
        chunk_size: Keyword.get(options, :chunk_size, 1024),
      }
    else
      {:error, _} = err ->
        err
    end
  end

  def next(%FileScanner{} = fs) do
    read_to_next_delimiter(fs, [])
    |> case do
      {:ok, new_position, data} ->
        {:ok, %{ fs | position: new_position }, data}
      {:error, _} = err ->
        err
      :eof ->
        {:ok, :eof, nil}
    end
  end

  defp split_on_delimiter(chunk, delimiter) do
    String.split(chunk, delimiter)
    |> List.first
  end
  
  defp read_to_next_delimiter(%FileScanner{} = fs, chunks) do
    with \
      {:ok, chunk}  <- :file.pread(fs.file, fs.position, fs.chunk_size),
      chunk         <- split_on_delimiter(chunk, fs.delimiter),
      chunk_length  <- chunk |> String.length,
      # position (current position)
      # len (length of data up to the newline)
      # + length of delimiter (skip the position of the delimiter)
      new_position  <- fs.position + chunk_length + String.length(fs.delimiter)
    do
      case done_or_continue(chunk_length, fs.chunk_size) do
        :done -> 
          {:ok, new_position, join_chunks([ chunk | chunks ])}
        :continue ->
          read_to_next_delimiter(%{ fs | position: fs.position + chunk_length}, [ chunk | chunks ])
      end
    else
      {:error, _} = err ->
        err
      :eof ->
        :eof
    end
  end

  defp done_or_continue(found_size, chunk_size) when found_size == chunk_size do
    :continue
  end
  defp done_or_continue(found_size, chunk_size) when found_size < chunk_size do
    :done
  end
  
  defp join_chunks(all_chunks) do
    all_chunks
    |> Enum.reverse
    |> List.flatten
    |> Enum.join
  end

end

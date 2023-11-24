defmodule ISN.Validator do
  @moduledoc """
  Definitions for validating the different types of serial numbers in the `isn`
  module without taking a trip to the database.
  """

  @doc """
  Validate some isn value.
  """
  def validate(ISN.ISBN, isbn), do: validate_isbn10(isbn)
  def validate(ISN.ISBN13, isbn), do: validate_isbn13(isbn)
  def validate(ISN.ISMN, ismn), do: validate_ismn(ismn)
  def validate(ISN.ISMN13, ismn), do: validate_ismn13(ismn)
  def validate(ISN.ISSN, issn), do: validate_issn(issn)
  def validate(ISN.ISSN13, issn), do: validate_issn13(issn)
  def validate(ISN.UPC, upc), do: validate_upc(upc)
  def valudate(ISN.EAN13, ean), do: validate_ean13(ean)

  @doc """
  Validate an ISBN10 number

  ## Examples

      iex> ISN.Validator.validate_isbn10("1680502999")
      true
      iex> ISN.Validator.validate_isbn10("1-68050-299-9")
      true
      iex> ISN.Validator.validate_isbn10("1680502990")
      false
      iex> ISN.Validator.validate_isbn10("168050299")
      false
      iex> ISN.Validator.validate_isbn10("1-55404-295-X")
      true
  """
  def validate_isbn10(isbn) when not is_binary(isbn), do: false

  def validate_isbn10(isbn) do
    isbn
    |> strip_spaces_and_dashes()
    |> do_validate_isbn10()
  end

  defp do_validate_isbn10(codepoints) when length(codepoints) != 10, do: false

  defp do_validate_isbn10(codepoints) do
    [digits, [checksum]] = Enum.chunk_every(codepoints, 9, 9, [])

    checksum = if checksum == "X", do: 10, else: String.to_integer(checksum)
    result = calculate_digit_sum(digits, 10..2)

    11 - rem(result, 11) == checksum
  end

  @doc """
  Validate an ISBN13 number

  ## Examples

      iex> ISN.Validator.validate_isbn13("9781680502992")
      true
      iex> ISN.Validator.validate_isbn13("978-1-68050-299-2")
      true
      iex> ISN.Validator.validate_isbn13("9781680502991")
      false
      iex> ISN.Validator.validate_isbn13("978168050299")
      false
  """
  def validate_isbn13(isbn), do: validate_ean13(isbn)

  @doc """
  Validate an old ISMN number

  This is for the old format, used before 1 January 2008, that starts with an "M".

  ## Examples

      iex> ISN.Validator.validate_ismn("M-2600-0043-8")
      true
      iex> ISN.Validator.validate_ismn("M-2600-0043-0")
      false
      iex> ISN.Validator.validate_ismn("M-9016791-7-7")
      true
      iex> ISN.Validator.validate_ismn("M-9016791-7-0")
      false
  """
  def validate_ismn(ismn) when not is_binary(ismn), do: false
  def validate_ismn("M" <> rest), do: validate_ismn13("9790" <> rest)
  def validate_ismn(_ismn), do: false

  @doc """
  Validate an ISMN13 number

  ## Examples

      iex> ISN.Validator.validate_ismn13("979-0-2600-0043-8")
      true
      iex> ISN.Validator.validate_ismn13("979-0-2600-0043-0")
      false
      iex> ISN.Validator.validate_ismn13("979-0-9016791-7-7")
      true
      iex> ISN.Validator.validate_ismn13("979-0-9016791-7-0")
      false
  """
  def validate_ismn13(ismn), do: validate_ean13(ismn)

  @doc """
  Validate an ISSN number

  ## Examples

      iex> ISN.Validator.validate_issn("0317-8471")
      true
      iex> ISN.Validator.validate_issn("2434-561X")
      true
      iex> ISN.Validator.validate_issn("2434-5610")
      false
  """
  def validate_issn(issn) when not is_binary(issn), do: false

  def validate_issn(issn) do
    issn
    |> strip_spaces_and_dashes()
    |> do_validate_issn()
  end

  defp do_validate_issn(codepoints) when length(codepoints) != 8, do: false

  defp do_validate_issn(codepoints) do
    [digits, [checksum]] = Enum.chunk_every(codepoints, 7, 7, [])

    checksum = if checksum == "X", do: 10, else: String.to_integer(checksum)
    result = calculate_digit_sum(digits, 8..2)

    11 - rem(result, 11) == checksum
  end

  @doc """
  Validate an ISSN13 number

  ## Examples

      iex> ISN.Validator.validate_issn13("977-0-31784-700-1")
      true
      iex> ISN.Validator.validate_issn13("977-2-43456-100-6")
      true
      iex> ISN.Validator.validate_issn13("977-2-43456-100-5")
      false
  """
  def validate_issn13(issn), do: validate_ean13(issn)

  @doc """
  Validate a 12-digit UPC-A number

  ## Examples

      iex> ISN.Validator.validate_upc("036000291452")
      true
      iex> ISN.Validator.validate_upc("036000291451")
      false
  """
  def validate_upc(upc) when not is_binary(upc), do: false
  def validate_upc(upc), do: validate_ean13("0" <> upc)

  @doc """
  Validate an EAN13 barcode number

  ## Examples

      iex> ISN.Validator.validate_ean13("4006381333931")
      true
      iex> ISN.Validator.validate_ean13("400638133393-1")
      true
      iex> ISN.Validator.validate_ean13("4006381333930")
      false
      iex> ISN.Validator.validate_ean13("400638133393-0")
      false
  """
  def validate_ean13(ean) when not is_binary(ean), do: false

  def validate_ean13(ean) do
    ean
    |> strip_spaces_and_dashes()
    |> do_validate_ean13()
  end

  defp do_validate_ean13(codepoints) when length(codepoints) != 13, do: false

  defp do_validate_ean13(codepoints) do
    digit_sum = calculate_digit_sum(codepoints, Stream.cycle([1, 3]))
    rem(digit_sum, 10) == 0
  end

  defp strip_spaces_and_dashes(input) do
    input
    |> String.codepoints()
    |> Enum.reject(fn x -> x in [" ", "-"] end)
  end

  defp calculate_digit_sum(digits, modifiers) do
    digits
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(modifiers)
    |> Enum.reduce(0, fn {n, mod}, acc -> acc + n * mod end)
  end
end

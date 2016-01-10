# ISN

[![Build Status][4]][5]

ISN adds a [`Postgrex.Extension`][1] and [`Ecto.Type`][2] definitions
for the datatypes defined in the [`isn`][3] PostgreSQL module.

## Usage

### Ecto migrations

```elixir
defmodule MyApp.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :isbn, :isbn13
      # other fields
    end
  end
end
```

### Ecto Models

```elixir
defmodule MyApp.Book do
  use MyApp.Web, :model

  schema "books" do
    field :isbn, ISN.ISBN13
    # other fields
  end
end
```

## Installation

1. Add the package to your Mixfile:
   ```elixir
   defp deps do
     [{:isn, "~> 0.1"}]
   end
   ```

2. Add the isn extension to your database
   ```
   mix do isn.gen.migration, ecto.migrate
   ```

3. Register the postgrex extension in your Repo config
    ```elixir
    config :books, MyApp.Repo,
    adapter: Ecto.Adapters.Postgres,
    extensions: [{Isn, []}]

    ```

## Defined types

`ISN` adds the following ecto and corresponding postgrex types:

Ecto.Type    | Postgrex type
-------------|--------------
`ISN.ISBN`   | `:isbn`
`ISN.ISBN13` | `:isbn13`
`ISN.ISMN`   | `:ismn`
`ISN.ISMN13` | `:ismn13`
`ISN.ISSN`   | `:issn`
`ISN.ISSN13` | `:issn13`
`ISN.EAN13`  | `:ean13`
`ISN.UPC`    | `:upc`

[1]: http://hexdocs.pm/postgrex/Postgrex.Extension.html
[2]: http://hexdocs.pm/ecto/Ecto.Type.html
[3]: http://www.postgresql.org/docs/9.4/static/isn.html
[4]: https://semaphoreci.com/api/v1/projects/be7c4c34-c49e-45c7-9320-3fcc4f7f476a/458429/badge.svg
[5]: https://semaphoreci.com/frost/isn
defmodule FarmbotCore.Asset.Point do
  @moduledoc """
  Points are data around an x,y,z
  """
  use FarmbotCore.Asset.Schema, path: "/api/points"

  schema "points" do
    field(:id, :id)

    has_one(:local_meta, FarmbotCore.Asset.Private.LocalMeta,
      on_delete: :delete_all,
      references: :local_id,
      foreign_key: :asset_local_id
    )

    field(:discarded_at, :utc_datetime)
    field(:gantry_mounted, :boolean)
    field(:meta, :map)
    field(:monitor, :boolean, default: true)
    field(:name, :string)
    field(:openfarm_slug, :string)
    field(:plant_stage, :string)
    field(:planted_at, :utc_datetime)
    field(:pointer_type, :string)
    field(:pullout_direction, :integer)
    field(:radius, :float)
    field(:tool_id, :integer)
    field(:x, :float)
    field(:y, :float)
    field(:z, :float)
    timestamps()
  end

  view point do
    %{
      id: point.id,
      meta: point.meta,
      name: point.name,
      plant_stage: point.plant_stage,
      planted_at: point.planted_at,
      pointer_type: point.pointer_type,
      radius: point.radius,
      tool_id: point.tool_id,
      discarded_at: point.discarded_at,
      gantry_mounted: point.gantry_mounted,
      pullout_direction: point.pullout_direction,
      x: point.x,
      y: point.y,
      z: point.z
    }
  end

  def changeset(point, params \\ %{}) do
    point
    |> cast(params, [
      :id,
      :meta,
      :name,
      :plant_stage,
      :planted_at,
      :pointer_type,
      :radius,
      :x,
      :y,
      :z,
      :tool_id,
      :gantry_mounted,
      :discarded_at,
      :monitor,
      :created_at,
      :updated_at
    ])
    |> validate_required([])
  end
end

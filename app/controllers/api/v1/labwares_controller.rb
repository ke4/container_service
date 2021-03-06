# See README.md for copyright details

class Api::V1::LabwaresController < Api::V1::ApplicationController
  before_action :set_labware, only: [:show, :create, :update]

  # POST /labwares
  def create
    @labware = Labware.new(labware_params)

    if @labware.save
      render json: @labware, status: :created, include: included_relations_to_render
    else
      render json: @labware.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /labwares/1
  def update
    if @labware.update(labware_params)
      render json: @labware, include: included_relations_to_render
    else
      render json: @labware.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_labware
    @labware = Labware.find_by(uuid: params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def labware_params
    params = (labware_json_params[:attributes] or {}).merge(uuid: labware_json_params[:id]).delete_if { |k, v| v.nil? }

    labware_type = @labware ? @labware.labware_type : nil
    if (labware_type_params = labware_json_params.dig(:relationships, :labware_type, :data, :attributes))
      new_labware_type = LabwareType.find_by(labware_type_params)
      if labware_type.nil? or labware_type == new_labware_type
        labware_type = new_labware_type
      else 
        return params.merge(labware_type: new_labware_type)
      end
    end

    metadata = @labware ? @labware.metadata.map { |metadatum| {id: metadatum.id, key: metadatum.key, value: metadatum.value} } : []
    if (metadata_data = labware_json_params.dig(:relationships, :metadata, :data))
      metadata_data.each { |metadatum|
        metadatum = metadatum[:attributes]
        existing_metadatum = metadata.find { |m| m[:key] == metadatum[:key] }
        if existing_metadatum
          existing_metadatum[:value] = metadatum[:value]
        else
          metadata << {key: metadatum[:key], value: metadatum[:value]}
        end
      }
    end

    receptacles_attributes = labware_type ? labware_type.layout.locations.map { |location| {location: location} } : []

    if @labware
      @labware.receptacles.each { |receptacle| 
        receptacle_attributes = receptacles_attributes.find { |attr| attr[:location] == receptacle.location }
        receptacle_attributes[:id] = receptacle.id
        receptacle_attributes[:material_uuid] = receptacle.material_uuid
      }
    end

    if (receptacles_data = labware_json_params.dig(:relationships, :receptacles, :data))
      receptacles_data.each { |receptacle_params|
        location_name = receptacle_params.dig(:relationships, :location, :data, :attributes, :name)
        if (receptacle_attributes = receptacles_attributes.find { |attr| attr[:location].name == location_name })
          receptacle_attributes[:material_uuid] = receptacle_params.dig(:attributes, :material_uuid)
        else
          receptacles_attributes << { material_uuid: receptacle_params.dig(:attributes, :material_uuid), location: Location.find_by(name: location_name) }
        end
      }
    end 

    params.merge(labware_type: labware_type, metadata_attributes: metadata, receptacles_attributes: receptacles_attributes)
  end

  def labware_json_params
    params.require(:data).permit(
      [
        :id,
        attributes: [:external_id, :barcode, :barcode_prefix, :barcode_info],
        relationships: {
          labware_type: {data: {attributes: [:name]}},
          receptacles: { data:
            [
              attributes: [:material_uuid], 
              relationships: {location: {data: {attributes: [:name]}}}
            ]
          },
          metadata: { data: { attributes: [:key, :value] } }
        }
      ]
    )
  end

  def included_relations_to_render
    [:labware_type, :receptacles, :metadata, "receptacles.location"]
  end

  def filter(params)
    labwares = Labware
    params.each do |param_key, param_value|
      labwares = labwares.where("Api::V1::Filters::#{param_key.camelize}Filter".constantize.filter(params))
    end

    labwares
  end

  def query_params
    params.slice(:labware_type, :barcode, :barcode_prefix, :barcode_info,
      :external_id, :created_before, :created_after)
  end
end